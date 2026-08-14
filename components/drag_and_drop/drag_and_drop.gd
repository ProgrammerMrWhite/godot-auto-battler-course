extends Node
class_name DragAndDrop
## 拖放组件

## 拖动终止信号
signal drag_canceled(starting_position: Vector2)
## 拖动开始
signal drag_started
## 拖动释放
signal dropped(starting_position: Vector2)

## 是否启用
@export var enabled: bool = true
## 拖放目标
@export var target: Area2D

## 拖放开始位置
var starting_position: Vector2
## 偏移量记录
var offset := Vector2.ZERO
## 是否正在拖放
var is_dragging := false

func _ready() -> void:
	assert(target, "拖放组件没有目标!")
	target.input_event.connect(_on_target_input_event.unbind(1))

func _process(_delta: float) -> void:
	if is_dragging and target:
		target.global_position = target.get_global_mouse_position() + offset

func _input(event: InputEvent) -> void:
	if is_dragging and event.is_action_pressed("cancel_drag"):
		_cancel_dragging()
	elif is_dragging and event.is_action_released("select"):
		_drop()

func _end_dragging():
	is_dragging = false
	target.remove_from_group("dragging")
	target.z_index = 0

func _cancel_dragging():
	_end_dragging()
	drag_canceled.emit(starting_position)

func _start_dragging():
	is_dragging = true
	starting_position = target.global_position
	target.add_to_group("dragging")
	target.z_index = 99
	offset = target.global_position - target.get_global_mouse_position()
	drag_started.emit()

func _drop():
	_end_dragging()
	dropped.emit(starting_position)

func _on_target_input_event(_viewport: Node, event: InputEvent):
	if not enabled: return
	
	var dragging_object := get_tree().get_first_node_in_group("dragging")
	# 如果没有在拖动,并且全局已经存在唯一拖动对象时,表示当前组件不可启用
	if not is_dragging and dragging_object: return
	
	if not is_dragging and event.is_action_pressed("select"):
		_start_dragging()
