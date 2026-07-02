extends Node2D
## Visual ventilation network for one floor side (GDD 2.4 «Respiration Network»).
##
## Builds addressable segments in the design hierarchy — main vertical trunk →
## side trunks (under ceiling / under floor) → per-room branches — as Line2D
## nodes. Sprint 2 leaves them all empty (grey); Sprint 3's propagation will
## call set_fill() to lerp each segment grey→purple as the Samosbor takes it.

const COLOR_EMPTY: Color = Color(0.40, 0.43, 0.48)   # обычная вентиляция (холодный серый)
const COLOR_FILLED: Color = Color(0.55, 0.20, 0.75)  # фиолетовое свечение (в контроле)
const LINE_WIDTH: float = 5.0
const TOP_TRUNK_Y: float = 30.0
const BOTTOM_TRUNK_MARGIN: float = 30.0  # от нижнего края секции
const TRUNK_X: float = 40.0

var _segments: Dictionary = {}  # String id -> Line2D

## Rebuilds the network for a section of `section_size` with the given room
## rects (Array[Rect2]); branches drop from the top trunk into each room.
func build_network(section_size: Vector2, room_rects: Array) -> void:
	_clear()
	var bottom_y: float = section_size.y - BOTTOM_TRUNK_MARGIN

	# Главная магистраль: вертикаль сквозь все этажи (заполняется первой).
	_add_segment("main", PackedVector2Array([
		Vector2(TRUNK_X, 0.0), Vector2(TRUNK_X, section_size.y)]))

	# Боковые магистрали под потолком и под полом.
	_add_segment("side_top", PackedVector2Array([
		Vector2(TRUNK_X, TOP_TRUNK_Y), Vector2(section_size.x, TOP_TRUNK_Y)]))
	_add_segment("side_bottom", PackedVector2Array([
		Vector2(TRUNK_X, bottom_y), Vector2(section_size.x, bottom_y)]))

	# Ветви от верхней магистрали в каждую комнату.
	for i in room_rects.size():
		var r: Rect2 = room_rects[i]
		var branch_x: float = r.position.x + r.size.x * 0.5
		_add_segment("branch_%d" % i, PackedVector2Array([
			Vector2(branch_x, TOP_TRUNK_Y), Vector2(branch_x, r.position.y)]))

## Lerp a single segment toward the filled (purple) colour. ratio 0..1.
func set_fill(id: String, ratio: float) -> void:
	if not _segments.has(id):
		push_warning("Ventilation: unknown segment '%s'" % id)
		return
	var line: Line2D = _segments[id]
	line.default_color = COLOR_EMPTY.lerp(COLOR_FILLED, clampf(ratio, 0.0, 1.0))

func segment_ids() -> Array:
	return _segments.keys()

func _add_segment(id: String, points: PackedVector2Array) -> void:
	var line: Line2D = Line2D.new()
	line.name = "Vent_" + id
	line.points = points
	line.width = LINE_WIDTH
	line.default_color = COLOR_EMPTY
	line.z_index = 5
	add_child(line)
	_segments[id] = line

func _clear() -> void:
	for line in _segments.values():
		line.queue_free()
	_segments.clear()
