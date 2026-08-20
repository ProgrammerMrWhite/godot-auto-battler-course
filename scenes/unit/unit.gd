@tool
extends Area2D
class_name Unit
## 单位

## 快速出售信号
signal quick_sell_pressed

## 单位属性
@export var stats: UnitStats: set = set_stats

@onready var skin: Sprite2D = %Skin
@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar
@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var velocity_based_rotation: VelocityBasedRotation = $VelocityBasedRotation
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter

var is_hovered := false

func set_stats(v):
	stats = v
	
	if v == null: return
	if not is_node_ready():
		await ready
	
	skin.region_rect.position = Vector2(stats.skin_coordinates) * Arena.CELL_SIZE


func _ready() -> void:
	if not Engine.is_editor_hint():
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)
		drag_and_drop.drag_started.connect(_on_drag_started)

func _input(event: InputEvent) -> void:
	if is_hovered and event.is_action_pressed("quick_sell"):
		quick_sell_pressed.emit()

func _on_mouse_entered() -> void:
	if drag_and_drop.is_dragging: return
	
	outline_highlighter.show_highlight()
	z_index = 1
	is_hovered = true


func _on_mouse_exited() -> void:
	if drag_and_drop.is_dragging: return
	
	outline_highlighter.clear_highlight()
	z_index = 0
	is_hovered = false


func _on_drag_started():
	velocity_based_rotation.enabled = true

func _on_drag_canceled(starting_position: Vector2):
	reset_after_dragging(starting_position)

func reset_after_dragging(starting_position: Vector2):
	velocity_based_rotation.enabled = false
	global_position = starting_position
