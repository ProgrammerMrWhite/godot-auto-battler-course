extends Node2D
class_name Arena
## 竞技场

## 瓦片尺寸
const CELL_SIZE := Vector2(32, 32)
## 瓦片一半尺寸
const HALF_CELL_SIZE := Vector2(16, 16)
## 瓦片四分之一尺寸
const QUARTER_CELL_SIZE := Vector2(8, 8)

@onready var unit_mover: UnitMover = %UnitMover
@onready var unit_spawner: UnitSpawner = %UnitSpawner
@onready var sell_portal: SellPortal = %SellPortal
@onready var shop: Shop = %Shop

func _ready() -> void:
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
	unit_spawner.unit_spawned.connect(sell_portal.setup_unit)
	shop.unit_bought.connect(unit_spawner.spawn_unit)
