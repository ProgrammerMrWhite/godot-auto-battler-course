extends Area2D
class_name SellPortal

@export var unit_pool: UnitPool
@export var player_stats: PlayerStats

@onready var outline_highlighter: OutlineHighlighter = %OutlineHighlighter
@onready var gold: HBoxContainer = %Gold
@onready var gold_label: Label = %GoldLabel

var current_unit: Unit

func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		setup_unit(unit)


func setup_unit(unit: Unit):
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))
	unit.quick_sell_pressed.connect(_on_unit_sell.bind(unit))


func _on_unit_sell(unit: Unit):
	player_stats.gold += unit.stats.get_gold_value()
	# TODO 后续处理
	unit_pool.add_unit(unit.stats)
	unit.queue_free()


func _on_unit_dropped(_starting_position: Vector2, unit: Unit):
	if unit and unit == current_unit:
		_on_unit_sell(unit)

func _on_area_entered(unit: Unit) -> void:
	current_unit = unit
	gold_label.text = str(unit.stats.get_gold_value())
	outline_highlighter.show_highlight()
	gold.show()
	


func _on_area_exited(unit: Unit) -> void:
	if unit and unit == current_unit:
		current_unit = null
	outline_highlighter.clear_highlight()
	gold.hide()
