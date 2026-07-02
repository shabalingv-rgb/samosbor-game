extends CanvasLayer
## Minimal HUD (Sprint 2.3): biomass, terror, detection risk and current phase.
##
## Pure view layer — reads the GameManager autoload (single source of truth) and
## refreshes on its signals; never mutates state. UI is built in code so the
## .tscn stays a one-line CanvasLayer. Aesthetic is a placeholder for the
## eventual "заметки карандашом на полях обоев" styling.

# Bars are gauges, not hard caps — the number label shows the true value while
# the bar fills toward these soft display maxima.
@export var biomass_bar_max: float = 200.0
@export var terror_bar_max: float = 200.0

const TEXT_COLOR: Color = Color(0.16, 0.14, 0.12)
const PANEL_COLOR: Color = Color(0.90, 0.86, 0.74, 0.92)   # старая бумага
const PANEL_BORDER: Color = Color(0.30, 0.28, 0.24, 0.85)
const BIOMASS_FILL: Color = Color(0.62, 0.22, 0.24)        # мясо/биомасса
const TERROR_FILL: Color = Color(0.45, 0.25, 0.60)         # фиолетовый ужас
const DETECTION_FILL: Color = Color(0.75, 0.55, 0.15)      # тревожный янтарь
const PHASE_HIDDEN_COLOR: Color = Color(0.24, 0.36, 0.24)  # приглушённо-зелёный
const PHASE_ACTIVE_COLOR: Color = Color(0.66, 0.14, 0.14)  # тревожно-красный

var _phase_label: Label
var _biomass_bar: ProgressBar
var _biomass_value: Label
var _terror_bar: ProgressBar
var _terror_value: Label
var _detection_bar: ProgressBar
var _detection_value: Label

func _ready() -> void:
	_build_ui()
	GameManager.resources_changed.connect(_on_resources_changed)
	GameManager.phase_changed.connect(_on_phase_changed)
	GameManager.detection_changed.connect(_on_detection_changed)
	_refresh_all()

func _exit_tree() -> void:
	# Autoload signals — disconnect to avoid dangling references on reload.
	if GameManager.resources_changed.is_connected(_on_resources_changed):
		GameManager.resources_changed.disconnect(_on_resources_changed)
	if GameManager.phase_changed.is_connected(_on_phase_changed):
		GameManager.phase_changed.disconnect(_on_phase_changed)
	if GameManager.detection_changed.is_connected(_on_detection_changed):
		GameManager.detection_changed.disconnect(_on_detection_changed)

# --- UI construction -------------------------------------------------------

func _build_ui() -> void:
	var panel: PanelContainer = PanelContainer.new()
	panel.position = Vector2(16.0, 16.0)
	panel.custom_minimum_size = Vector2(320.0, 0.0)
	panel.add_theme_stylebox_override("panel", _panel_style())
	add_child(panel)

	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	_phase_label = Label.new()
	_phase_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(_phase_label)

	var biomass_row: Array = _add_resource_row(vbox, "Биомасса", BIOMASS_FILL)
	_biomass_bar = biomass_row[0]
	_biomass_value = biomass_row[1]

	var terror_row: Array = _add_resource_row(vbox, "Ужас", TERROR_FILL)
	_terror_bar = terror_row[0]
	_terror_value = terror_row[1]

	var detection_row: Array = _add_resource_row(vbox, "Обнаружение", DETECTION_FILL)
	_detection_bar = detection_row[0]
	_detection_value = detection_row[1]

func _panel_style() -> StyleBoxFlat:
	var sb: StyleBoxFlat = StyleBoxFlat.new()
	sb.bg_color = PANEL_COLOR
	sb.set_corner_radius_all(4)
	sb.set_border_width_all(2)
	sb.border_color = PANEL_BORDER
	sb.set_content_margin_all(12.0)
	return sb

func _add_resource_row(vbox: VBoxContainer, name_text: String, fill: Color) -> Array:
	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)

	var name_label: Label = Label.new()
	name_label.text = name_text
	name_label.custom_minimum_size = Vector2(104.0, 0.0)
	name_label.add_theme_color_override("font_color", TEXT_COLOR)

	var bar: ProgressBar = _make_bar(fill)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	var value_label: Label = Label.new()
	value_label.custom_minimum_size = Vector2(48.0, 0.0)
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.add_theme_color_override("font_color", TEXT_COLOR)

	row.add_child(name_label)
	row.add_child(bar)
	row.add_child(value_label)
	vbox.add_child(row)
	return [bar, value_label]

func _make_bar(fill: Color) -> ProgressBar:
	var bar: ProgressBar = ProgressBar.new()
	bar.show_percentage = false
	bar.min_value = 0.0
	bar.max_value = 100.0
	bar.custom_minimum_size = Vector2(150.0, 16.0)

	var bg: StyleBoxFlat = StyleBoxFlat.new()
	bg.bg_color = Color(0.0, 0.0, 0.0, 0.18)
	bg.set_corner_radius_all(3)
	var fg: StyleBoxFlat = StyleBoxFlat.new()
	fg.bg_color = fill
	fg.set_corner_radius_all(3)
	bar.add_theme_stylebox_override("background", bg)
	bar.add_theme_stylebox_override("fill", fg)
	return bar

# --- Signal handlers -------------------------------------------------------

func _refresh_all() -> void:
	_on_resources_changed()
	_on_phase_changed(GameManager.phase)
	_on_detection_changed(GameManager.detection_risk)

func _on_resources_changed() -> void:
	_biomass_value.text = str(GameManager.biomass)
	_biomass_bar.value = clampf(float(GameManager.biomass) / biomass_bar_max * 100.0, 0.0, 100.0)
	_terror_value.text = str(GameManager.terror)
	_terror_bar.value = clampf(float(GameManager.terror) / terror_bar_max * 100.0, 0.0, 100.0)

func _on_phase_changed(phase: String) -> void:
	if phase == "accumulation":
		_phase_label.text = "ФАЗА: СКРЫТОЕ НАКОПЛЕНИЕ"
		_phase_label.add_theme_color_override("font_color", PHASE_HIDDEN_COLOR)
	else:
		_phase_label.text = "ФАЗА: АКТИВНЫЙ САМОСБОР"
		_phase_label.add_theme_color_override("font_color", PHASE_ACTIVE_COLOR)

func _on_detection_changed(risk: float) -> void:
	_detection_value.text = "%d%%" % int(round(risk * 100.0))
	_detection_bar.value = clampf(risk * 100.0, 0.0, 100.0)
