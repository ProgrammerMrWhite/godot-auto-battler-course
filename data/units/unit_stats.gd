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

@export_category("视觉效果")
## 单位皮肤坐标
@export var skin_coordinates: Vector2i

func _to_string() -> String:
	return name
