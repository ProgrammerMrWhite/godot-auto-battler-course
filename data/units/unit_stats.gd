extends Resource
class_name UnitStats
## 单位属性

## 稀有度列表
enum Rarity {
	## 普通
	COMMON,
	## 罕见
	UNCOMMON,
	## 稀有
	RARE,
	## 传说
	LEGENDARY
}

## 稀有度颜色
const RARITY_COLORS := {
	Rarity.COMMON: Color("124a2e"),
	Rarity.UNCOMMON: Color("1c527c"),
	Rarity.RARE: Color("ab0979"),
	Rarity.LEGENDARY: Color("ea940b"),
}

## 单位名称
@export var name: String

@export_category("数据")
## 单位稀有度
@export var rarity: Rarity
## 单位造价
@export var gold_cost := 1
## 单位级别
@export_range(1, 3) var tier := 1 : set = _set_tier


@export_category("视觉效果")
## 单位皮肤坐标
@export var skin_coordinates: Vector2i

## 获取单位总数(合成数量)
func get_combined_unit_count() -> int:
	return 3 ** (tier - 1)

func get_gold_value() -> int:
	return get_combined_unit_count() * gold_cost

func _to_string() -> String:
	return name

func _set_tier(v):
	tier = v
	emit_changed()
