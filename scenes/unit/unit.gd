@tool
extends Area2D
class_name Unit
## 单位

## 单位属性
@export var stats: UnitStats: set = set_stats

@onready var skin: Sprite2D = %Skin
@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar


func set_stats(v):
	stats = v
	
	if v == null: return
	if not is_node_ready():
		await ready
	
	skin.region_rect.position = Vector2(stats.skin_coordinates) * Arena.CELL_SIZE
