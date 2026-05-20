extends Control
@export var item_texture: TextureRect
@export var amount_label: Label 
var current_equipped_item: String = ""
var current_equipped_amount: int = 0
func _ready() -> void:
	item_texture.texture = null
	amount_label.text = ""
	amount_label.visible = false
func update_equipped_item(item_name: String, amount: int) -> void:
	current_equipped_item = item_name
	current_equipped_amount = amount
	if item_name == "":
		item_texture.texture = null
		amount_label.visible = false
		return
	var textura = InventoryManager.get_inventory_texture(item_name)
	if textura:
		item_texture.texture = textura
	var max_stack = InventoryManager.item_max_stack.get(item_name, 1)
	if max_stack > 1:
		amount_label.text = str(amount)
		amount_label.visible = true
	else:
		amount_label.visible = false
