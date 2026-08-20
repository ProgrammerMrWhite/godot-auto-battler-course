extends Node
class_name TileHighlighter
## 瓦片高亮组件

## 组件是否启用
@export var enabled: bool = true : set = _set_enabled
## 游玩区域
@export var play_area: PlayArea
## 高亮瓦片tilemap
@export var highlight_layer: TileMapLayer
## 高亮瓦片坐标(图集)
@export var tile: Vector2i

@onready var source_id := highlight_layer.tile_set.get_source_id(0)

func _process(_delta: float) -> void:
	if not enabled: return
	
	var selected_tile := play_area.get_hovered_tile()
	
	if not play_area.is_tile_in_bounds(selected_tile):
		highlight_layer.clear()
		return
	
	_update_tile(selected_tile)


func _set_enabled(v):
	enabled = v
	if not enabled and play_area:
		highlight_layer.clear()

func _update_tile(selected_tile: Vector2i):
	highlight_layer.clear()
	highlight_layer.set_cell(selected_tile, source_id, tile)
	
