extends Resource
class_name PlayerStats
## 玩家状态

@export_range(0, 99) var gold: int : set = _set_gold
@export_range(0, 99) var xp: int : set = _set_xp
@export_range(1, 10) var level: int : set = _set_level

func _set_gold(v):
	gold = v
	emit_changed()

func _set_xp(v):
	xp = v
	emit_changed()

func _set_level(v):
	level = v
	emit_changed()
