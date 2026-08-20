extends Button
class_name UnitCard

## 购买单位
signal unit_bought(unit: UnitStats)

## 悬停卡片边框颜色
const HOVER_BORDER_COLOR := Color("fafa82")

@export var player_stats: PlayerStats
@export var unit_stats: UnitStats : set = _set_unit_stats

@onready var traits: Label = %Traits
@onready var bottom: Panel = %Bottom
@onready var unit_name: Label = %UnitName
@onready var gold_cost: Label = %GoldCost
@onready var border: Panel = %Border
@onready var unit_icon: TextureRect = %UnitIcon
@onready var empty_placeholder: Panel = %EmptyPlaceholder
@onready var border_sbf: StyleBoxFlat = border.get_theme_stylebox("panel")
@onready var bottom_sbf: StyleBoxFlat = bottom.get_theme_stylebox("panel")

## 此卡片位是否已经购买
var bought := false
## 边框颜色
var border_color : Color

func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()
	unit_bought.connect(func(unit: UnitStats):
		print("购买了单位:", unit.name)
		print("玩家金币:", str(player_stats.gold))
		)

func _set_unit_stats(v):
	unit_stats = v
	if not is_node_ready(): await ready
	
	if not unit_stats:
		empty_placeholder.show()
		disabled = true
		bought = true
		return
		
	border_color = unit_stats.RARITY_COLORS[unit_stats.rarity]
	border_sbf.border_color = border_color
	bottom_sbf.bg_color = border_color
	unit_name.text = unit_stats.name
	gold_cost.text = str(unit_stats.gold_cost)
	var texture := unit_icon.texture as AtlasTexture
	texture.region.position = Vector2(unit_stats.skin_coordinates) * Arena.CELL_SIZE
	

func _on_player_stats_changed():
	if not unit_stats: return
	
	var has_enough_gold := player_stats.gold >= unit_stats.gold_cost
	disabled = not has_enough_gold
	
	if has_enough_gold or bought:
		modulate = Color(Color.WHITE, 1.0)
	else:
		modulate = Color(Color.WHITE, .5)
	

func _on_pressed() -> void:
	if bought: return
	
	bought = true
	empty_placeholder.show()
	player_stats.gold -= unit_stats.gold_cost
	unit_bought.emit(unit_stats)


func _on_mouse_entered() -> void:
	if disabled: return
	border_sbf.border_color = HOVER_BORDER_COLOR


func _on_mouse_exited() -> void:
	border_sbf.border_color = border_color
