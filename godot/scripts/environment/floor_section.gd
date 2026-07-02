extends Node2D
## One side of a Gigakhrushchyovka floor (GDD 2.3 «Механика Кольца»).
##
## Placeholder geometry only (Sprint 2.2): central shaft + corridor + a row of
## rooms drawn as flat Node2D primitives in the muted "Soviet wallpaper" palette.
## Real hand-drawn sprites, the Line-Boil effect and side-switching come later;
## the ventilation network is built as a child so Sprint 3 can fill it.

@export var room_count: int = 4
@export var section_size: Vector2 = Vector2(1120, 360)

# «Рисунок карандашами на советских обоях» — приглушённая палитра-заглушка.
const COLOR_WALLPAPER: Color = Color(0.80, 0.74, 0.62)
const COLOR_SHAFT: Color = Color(0.44, 0.42, 0.40)
const COLOR_ROOM: Color = Color(0.68, 0.65, 0.58)
const COLOR_ROOM_OUTLINE: Color = Color(0.32, 0.30, 0.27)
const COLOR_CORRIDOR: Color = Color(0.52, 0.49, 0.45)

const SHAFT_WIDTH: float = 80.0
const ROOM_TOP: float = 70.0
const ROOM_BOTTOM_MARGIN: float = 75.0  # оставляем место под коридор + нижнюю магистраль
const ROOM_GAP: float = 16.0

@onready var _ventilation: Node2D = $Ventilation

func _ready() -> void:
	_build()

func _build() -> void:
	var rooms: Array = _compute_rooms()
	_add_rect(Rect2(Vector2.ZERO, section_size), COLOR_WALLPAPER, -10)          # обои
	_add_rect(Rect2(0.0, 0.0, SHAFT_WIDTH, section_size.y), COLOR_SHAFT, -8)     # шахта
	_add_rect(_corridor_rect(rooms), COLOR_CORRIDOR, -6)                         # коридор
	for r in rooms:
		_add_rect(r, COLOR_ROOM, 0)
		_add_outline(r, COLOR_ROOM_OUTLINE)
	_ventilation.build_network(section_size, rooms)

func _compute_rooms() -> Array:
	var rooms: Array = []
	var usable_x: float = section_size.x - SHAFT_WIDTH - 20.0
	var room_w: float = (usable_x - ROOM_GAP * float(room_count - 1)) / float(room_count)
	var room_h: float = section_size.y - ROOM_TOP - ROOM_BOTTOM_MARGIN
	for i in room_count:
		var x: float = SHAFT_WIDTH + 20.0 + float(i) * (room_w + ROOM_GAP)
		rooms.append(Rect2(x, ROOM_TOP, room_w, room_h))
	return rooms

func _corridor_rect(rooms: Array) -> Rect2:
	# Полоса между низом комнат и нижней вентиляционной магистралью (путь NPC).
	var room_bottom: float = ROOM_TOP + (section_size.y - ROOM_TOP - ROOM_BOTTOM_MARGIN)
	var top: float = room_bottom + 10.0
	return Rect2(SHAFT_WIDTH, top, section_size.x - SHAFT_WIDTH, section_size.y - 30.0 - top)

func _add_rect(rect: Rect2, color: Color, z: int) -> void:
	var poly: Polygon2D = Polygon2D.new()
	poly.polygon = PackedVector2Array([
		rect.position,
		rect.position + Vector2(rect.size.x, 0.0),
		rect.position + rect.size,
		rect.position + Vector2(0.0, rect.size.y),
	])
	poly.color = color
	poly.z_index = z
	add_child(poly)

func _add_outline(rect: Rect2, color: Color) -> void:
	var line: Line2D = Line2D.new()
	line.points = PackedVector2Array([
		rect.position,
		rect.position + Vector2(rect.size.x, 0.0),
		rect.position + rect.size,
		rect.position + Vector2(0.0, rect.size.y),
		rect.position,
	])
	line.width = 2.0
	line.default_color = color
	line.z_index = 1
	add_child(line)
