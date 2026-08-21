extends Resource
class_name UnitPool
## 单位池

## 可用单位列表
@export var available_units: Array[UnitStats]

## 单位池数组(所有单位)
var unit_pool: Array[UnitStats]

func generate_unit_pool():
	unit_pool = []
	
	for unit: UnitStats in available_units:
		for i in unit.pool_count:
			unit_pool.append(unit)

func get_random_unit_by_rarity(rarity: UnitStats.Rarity) -> UnitStats:
	var units := unit_pool.filter(
		func(unit: UnitStats):
			return unit.rarity == rarity
	)
	if units.is_empty():
		return null
	
	var picked_unit: UnitStats = units.pick_random()
	unit_pool.erase(picked_unit)
	return picked_unit
	
func add_unit(unit: UnitStats):
	var combined_count := unit.get_combined_unit_count()
	unit = unit.duplicate()
	unit.tier = 1
	for i in combined_count:
		unit_pool.append(unit)
	
