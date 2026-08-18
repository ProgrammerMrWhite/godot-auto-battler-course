extends Node
class_name VelocityBasedRotation
## 基于速度的旋转组件

## 是否启用组件
@export var enabled: bool = true : set = _set_enabled
## 旋转目标单位
@export var target: Node2D
## 平滑旋转到最大角度时间
@export_range(0.25,1.5) var lerp_seconds := .4
## 旋转角度
@export var max_ratation_degrees := 60
## 开始旋转的最小速度要求(像素)
@export var x_velocity_threshold := 3.0

## 上一帧所在位置(用于比较速度使用)
var last_position: Vector2
## 当前拖动速度
var velocity: Vector2
## 旋转角度
var angle: float
## 旋转到最大角度进度(百分比)
var progress: float
## 旋转时长
var time_elapsed := 0.0

func _physics_process(delta: float) -> void:
	if not enabled or not target: return
	
	velocity = target.global_position - last_position
	last_position = target.global_position
	progress = time_elapsed / lerp_seconds
	
	if abs(velocity.x) > x_velocity_threshold:
		angle = velocity.normalized().x * deg_to_rad(max_ratation_degrees)
	else:
		angle = 0.0
	
	target.rotation = lerp_angle(target.rotation, angle, progress)
	time_elapsed += delta
	
	if progress >= 1.0:
		time_elapsed = 0
	
func _set_enabled(v):
	enabled = v
	if target and enabled == false:
		target.rotation = 0.0
	
