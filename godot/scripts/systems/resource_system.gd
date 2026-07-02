extends Node
## Economy engine for Samosbor.
##
## Owns the RULES of resource generation and spending. Does not store the
## authoritative values — those live in the GameManager autoload (single source
## of truth). This node reads/writes through GameManager so that UI can bind to
## GameManager signals without knowing the economy exists.
##
## Design: GameManager = state + signals. ResourceSystem = rules. PhaseManager =
## phase transitions. See ARCHITECTURE_RESOURCES.md.

# Passive trickle during the accumulation phase, before mutation multipliers.
# GDD: "Биомасса генерируется медленно", "Ужас из звуков/видений/теней".
@export var passive_biomass_per_sec: float = 0.5
@export var passive_terror_per_sec: float = 0.8

# Discrete terror events (GDD 2.2). Values are midpoints of the design ranges;
# mutation multipliers scale them at runtime.
const TERROR_SOURCES: Dictionary = {
	"sound": 3,   # скрежет, шум вентиляции: 1-5
	"vision": 5,  # тени, силуэты, глаза в стене: 2-8
	"dream": 6,   # голоса, ментальный контакт: 3-10
	"altar": 10,  # куски биомассы, алтари: 5-15
}

# Raised by the Mentality / Biomass development trees later.
var terror_gen_multiplier: float = 1.0
var biomass_gen_multiplier: float = 1.0

# Fractional carry so slow per-second rates still accumulate integer resources.
var _biomass_accumulator: float = 0.0
var _terror_accumulator: float = 0.0

func _process(delta: float) -> void:
	# Passive generation only happens while hidden (Фаза 1).
	if GameManager.phase != "accumulation":
		return

	_biomass_accumulator += passive_biomass_per_sec * biomass_gen_multiplier * delta
	_terror_accumulator += passive_terror_per_sec * terror_gen_multiplier * delta

	var biomass_gain: int = int(_biomass_accumulator)
	if biomass_gain > 0:
		_biomass_accumulator -= float(biomass_gain)
		GameManager.modify_biomass(biomass_gain)

	var terror_gain: int = int(_terror_accumulator)
	if terror_gain > 0:
		_terror_accumulator -= float(terror_gain)
		GameManager.modify_terror(terror_gain)

## Discrete terror gain from a named source (a scream, a vision, a shared dream).
func gain_terror_from(source: String) -> void:
	var base: int = TERROR_SOURCES.get(source, 0)
	if base <= 0:
		push_warning("ResourceSystem: unknown terror source '%s'" % source)
		return
	GameManager.modify_terror(int(round(base * terror_gen_multiplier)))

## Biomass from a consumed body. GDD: тела где выжило >30% дают биомассу
## пропорционально. survival_ratio is 0.0..1.0 of the body left to absorb.
func gain_biomass_from_body(survival_ratio: float) -> void:
	if survival_ratio <= 0.3:
		return
	var amount: int = int(round(survival_ratio * 20.0 * biomass_gen_multiplier))
	GameManager.modify_biomass(amount)

## True if the current pools cover the cost (used to gate mutations/abilities).
func can_afford(biomass_cost: int, terror_cost: int) -> bool:
	return GameManager.biomass >= biomass_cost and GameManager.terror >= terror_cost

## Atomically spends both resources; returns false and spends nothing if short.
func try_spend(biomass_cost: int, terror_cost: int) -> bool:
	if not can_afford(biomass_cost, terror_cost):
		return false
	GameManager.modify_biomass(-biomass_cost)
	GameManager.modify_terror(-terror_cost)
	return true
