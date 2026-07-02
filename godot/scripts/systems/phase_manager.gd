extends Node
## Drives the two-phase cycle (GDD: Фаза 1 скрытого накопления / Фаза 2
## активного самосбора) and the detection thresholds that force it.
##
## Listens to GameManager.detection_changed and flips GameManager.phase. Other
## systems react to the phase_changed / outbreak signals rather than polling.

# GDD detection thresholds.
const DETECTION_LIQUIDATORS_ACTIVE: float = 0.80  # >80%: ликвидаторы активируются
const DETECTION_FORCE_OUTBREAK: float = 0.95      # >95%: принудительная Фаза 2

signal liquidators_alerted   ## Fired once when risk first crosses 80%.
signal outbreak_started(forced: bool)  ## Фаза 2 begins (forced or player-chosen).

var _liquidators_alerted: bool = false

func _ready() -> void:
	GameManager.detection_changed.connect(_on_detection_changed)

func _exit_tree() -> void:
	# Autoload signal — must disconnect to avoid dangling references on reload.
	if GameManager.detection_changed.is_connected(_on_detection_changed):
		GameManager.detection_changed.disconnect(_on_detection_changed)

func _on_detection_changed(risk: float) -> void:
	if risk >= DETECTION_LIQUIDATORS_ACTIVE and not _liquidators_alerted:
		_liquidators_alerted = true
		liquidators_alerted.emit()

	if risk >= DETECTION_FORCE_OUTBREAK and GameManager.phase == "accumulation":
		_start_outbreak(true)

## Reset to the hidden phase — used at the start of a floor.
func begin_accumulation() -> void:
	_liquidators_alerted = false
	GameManager.change_phase("accumulation")

## Player voluntarily reveals the Samosbor (siren, hermetic doors seal).
func trigger_outbreak() -> void:
	if GameManager.phase == "accumulation":
		_start_outbreak(false)

func _start_outbreak(forced: bool) -> void:
	GameManager.change_phase("active")
	outbreak_started.emit(forced)
