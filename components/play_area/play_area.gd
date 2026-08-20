extends TileMapLayer
class_name PlayArea
## 游玩区域

## 游戏区域
@export var unit_grid: UnitGrid
@export var tile_highlighter: TileHighlighter

## 游玩区域矩形
var bounds: Rect2i

func _ready() -> void:
	bounds = Rect2i(Vector2.ZERO, unit_grid.grid_size)
	
## 根据全局坐标获取瓦片坐标
func get_tile_from_global(global: Vector2) -> Vector2i:
	return local_to_map(to_local(global))
	
## 根据瓦片坐标获取全局坐标
func get_global_from_tile(tile: Vector2i) -> Vector2:
	return to_global(map_to_local(tile))

## 获得鼠标悬停瓦片
func get_hovered_tile() -> Vector2i:
	return local_to_map(get_local_mouse_position())

## 判断指定坐标是否在区域内
func is_tile_in_bounds(tile: Vector2i) -> bool:
	return bounds.has_point(tile)
