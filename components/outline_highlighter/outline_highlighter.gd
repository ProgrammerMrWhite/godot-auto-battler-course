extends Node
class_name OutlineHighlighter
## 高亮组件

## 显示对象画布
@export var visuals: CanvasGroup
## 轮廓线颜色
@export var outline_color: Color
## 轮廓线粗细
@export_range(1,10) var outline_thickness: int

var material: ShaderMaterial

func _ready() -> void:
	material = visuals.material
	material.set_shader_parameter("line_color", outline_color)

func clear_highlight():
	material.set_shader_parameter("line_thickness", 0)

func show_highlight():
	material.set_shader_parameter("line_thickness", outline_thickness)
