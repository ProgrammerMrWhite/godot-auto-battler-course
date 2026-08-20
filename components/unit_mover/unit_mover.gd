extends Node
class_name UnitMover
## 单位移动组件

## 战斗区域
@export var game_area: PlayArea
## 备战区域
@export var bench_area: PlayArea


func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		setup_unit(unit)


func setup_unit(unit: Unit):
	unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	unit.drag_and_drop.drag_canceled.connect(_on_unit_drag_canceled.bind(unit))
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))

func _set_highlighters(enabled: bool):
	game_area.tile_highlighter.enabled = enabled
	bench_area.tile_highlighter.enabled = enabled

## 根据全局坐标获取指定游戏区域
func _get_play_area_for_position(global: Vector2) -> PlayArea:
	var dropped_area: PlayArea = null
	if _is_global_in_area(global, game_area):
		dropped_area = game_area
	elif _is_global_in_area(global, bench_area):
		dropped_area = bench_area
	return dropped_area

## 判断全局坐标是否在游戏区域内
func _is_global_in_area(global: Vector2, play_area: PlayArea) -> bool:
	return play_area.is_tile_in_bounds(play_area.get_tile_from_global(global))

## 重置单位到起始位置
func _reset_unit_to_starting_position(starting_position: Vector2, unit: Unit):
	var starting_area := _get_play_area_for_position(starting_position)
	if starting_area:
		var tile := starting_area.get_tile_from_global(starting_position)
		unit.reset_after_dragging(starting_position)
		starting_area.unit_grid.add_unit(tile, unit)

## 移动单位
func _move_unit(unit: Unit, play_area: PlayArea, tile: Vector2i):
	play_area.unit_grid.add_unit(tile, unit)
	unit.global_position = play_area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE
	unit.reparent(play_area.unit_grid)

func _on_unit_drag_started(unit: Unit):
	_set_highlighters(true)
	var area := _get_play_area_for_position(unit.global_position)
	if area:
		var tile := area.get_tile_from_global(unit.global_position)
		area.unit_grid.remove_unit(tile)


func _on_unit_drag_canceled(starting_position: Vector2, unit: Unit):
	_set_highlighters(false)
	_reset_unit_to_starting_position(starting_position, unit)


func _on_unit_dropped(starting_position: Vector2, unit: Unit):
	_set_highlighters(false)
	
	var orgin_area := _get_play_area_for_position(starting_position)
	var dropped_area := _get_play_area_for_position(unit.get_global_mouse_position())
	# 判断放置的位置是否是游戏区域内
	if dropped_area:
		var orgin_tile := orgin_area.get_tile_from_global(starting_position)
		var dropped_tile := dropped_area.get_tile_from_global(unit.get_global_mouse_position())
		# 判断瓦片内是否有单位
		if dropped_area.unit_grid.is_tile_occupied(dropped_tile):
			var orgin_unit: Unit = dropped_area.unit_grid.units[dropped_tile]
			# 占用时,交换位置
			dropped_area.unit_grid.remove_unit(dropped_tile)
			_move_unit(orgin_unit, orgin_area, orgin_tile)
		_move_unit(unit, dropped_area, dropped_tile)
	else:
		_reset_unit_to_starting_position(starting_position, unit)
	
	
