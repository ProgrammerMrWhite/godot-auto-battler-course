extends Node2D
class_name UnitGrid

signal unit_grid_changed

@export var grid_size: Vector2i

var units: Dictionary

func _ready() -> void:
	for x in grid_size.x:
		for y in grid_size.y:
			units[Vector2i(x, y)] = null

func add_unit(tile: Vector2i, unit: Node):
	units[tile] = unit
	unit_grid_changed.emit()

func remove_unit(tile: Vector2i):
	var unit := units[tile] as Node
	if unit:
		units[tile] = null
		unit_grid_changed.emit()

## 指定瓦片位置是否占用
func is_tile_occupied(tile: Vector2i) -> bool:
	return units[tile] != null

## 网格是否全部占用
func is_grid_full() -> bool:
	return units.keys().all(is_tile_occupied)

func get_first_empty_tile() -> Vector2i:
	for tile in units:
		if not is_tile_occupied(tile):
			return tile
	return Vector2i(-1, -1)

func get_all_units() -> Array[Unit]:
	var arr: Array[Unit] = []
	for unit in units.values():
		if unit:
			arr.append(unit)
	return arr
