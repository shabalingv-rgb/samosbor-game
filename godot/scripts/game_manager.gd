extends Node

# Global game state
var current_floor: int = 1
var phase: String = "accumulation"  # accumulation | active
var biomass: int = 50
var terror: int = 30
var detection_risk: float = 0.0

# Signals
signal phase_changed(new_phase: String)
signal resources_changed
signal detection_changed(risk: float)
signal floor_changed(new_floor: int)

func _ready() -> void:
	print("Game Manager initialized")
	print("Floor: %d | Phase: %s | Biomass: %d | Terror: %d" % [current_floor, phase, biomass, terror])

func _process(delta: float) -> void:
	# Placeholder for game loop
	pass

func change_phase(new_phase: String) -> void:
	if new_phase in ["accumulation", "active"]:
		phase = new_phase
		emit_signal("phase_changed", new_phase)
		print("Phase changed to: %s" % new_phase)

func modify_biomass(amount: int) -> void:
	biomass = max(0, biomass + amount)
	emit_signal("resources_changed")

func modify_terror(amount: int) -> void:
	terror = max(0, terror + amount)
	emit_signal("resources_changed")

func set_detection_risk(risk: float) -> void:
	detection_risk = clamp(risk, 0.0, 1.0)
	emit_signal("detection_changed", detection_risk)
	if detection_risk > 0.95:
		print("WARNING: Detection risk critical! Phase 2 will trigger automatically.")

func advance_floor() -> void:
	current_floor += 1
	biomass = 50  # Reset
	terror = 30
	detection_risk = 0.0
	emit_signal("floor_changed", current_floor)
	print("Advanced to floor: %d" % current_floor)
