extends Node
class_name UnitSpawner
## 单位生成器

## 单位生成信号
signal unit_spawned(unit: Unit)

## 单位预制体
const UNIT = preload("uid://nmju18ckpjp0")

@export var game_area: PlayArea
@export var bench_area: PlayArea


## 获取可用区域
func _get_first_available_area() -> PlayArea:
	if not bench_area.unit_grid.is_grid_full():
		return bench_area
	elif not game_area.unit_grid.is_grid_full():
		return game_area
	return null

## 生成单位
func spawn_unit(unit: UnitStats):
	var area := _get_first_available_area()
	# TODO 当前没有空置区域放置单位,需要后续更改
	assert(area, "当前没有空置区域放置单位!")
	
	var new_unit := UNIT.instantiate() as Unit
	var tile := area.unit_grid.get_first_empty_tile()
	area.unit_grid.add_child(new_unit)
	area.unit_grid.add_unit(tile, new_unit)
	new_unit.stats = unit
	new_unit.global_position = area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE
	unit_spawned.emit(new_unit)
	
