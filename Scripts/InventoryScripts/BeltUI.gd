extends Control
@export var animacion: AnimationPlayer
@export var slot_label: Label
@export var warning_label: Label
@export var slot1_node: TextureButton
@export var slot2_node: TextureButton
@export var slot3_node: TextureButton
@export var slot4_node: TextureButton
@export var slot1_display: TextureRect
@export var slot2_display: TextureRect
@export var slot3_display: TextureRect
@export var slot4_display: TextureRect
@export var slot1_amount: Label
@export var slot2_amount: Label
@export var slot3_amount: Label
@export var slot4_amount: Label
var belt_open = false
var selected_slot = -1
var item_to_equip = ""
var equip_mode = false
var inventory_slot_origin = -1
var belt_slots = {
	1: null,
	2: null,
	3: null,
	4: null
}
var slot1_base: Vector2
var slot2_base: Vector2
var slot3_base: Vector2
var slot4_base: Vector2
signal equip_done
func _ready() -> void:
	visible = false
	belt_open = false
	if slot1_node: slot1_base = slot1_node.position
	if slot2_node: slot2_base = slot2_node.position
	if slot3_node: slot3_base = slot3_node.position
	if slot4_node: slot4_base = slot4_node.position
	if slot1_display: slot1_display.visible = false
	if slot2_display: slot2_display.visible = false
	if slot3_display: slot3_display.visible = false
	if slot4_display: slot4_display.visible = false
	if slot1_amount: slot1_amount.visible = false
	if slot2_amount: slot2_amount.visible = false
	if slot3_amount: slot3_amount.visible = false
	if slot4_amount: slot4_amount.visible = false
func on_equip_requested(item_name: String, inv_slot: int) -> void:
	item_to_equip = item_name
	inventory_slot_origin = inv_slot
	equip_mode = true
	belt_open = true
	animacion.stop()
	visible = true
	animacion.play("open_belt")
func _process(_delta: float) -> void:
	if equip_mode:
		return
	if Input.is_action_pressed("belt-recargar"):
		if not belt_open:
			belt_open = true
			animacion.stop()
			await get_tree().process_frame
			visible = true
			animacion.play("open_belt")
	else:
		if belt_open:
			belt_open = false
			animacion.play("close_belt")
			await animacion.animation_finished
			if not belt_open:
				visible = false
func _on_slot_pressed(slot_index: int) -> void:
	selected_slot = slot_index
	if equip_mode and item_to_equip != "":
		if belt_slots[slot_index] != null:
			var old_item_name = belt_slots[slot_index]["name"]
			var old_item_amount = belt_slots[slot_index]["amount"]
			belt_slots[slot_index] = {
				"name": item_to_equip,
				"amount": InventoryManager.slots[inventory_slot_origin]["amount"] if InventoryManager.slots[inventory_slot_origin] != null else 1
			}
			InventoryManager.slots[inventory_slot_origin] = {
				"name": old_item_name,
				"amount": old_item_amount
			}
		else:
			var inv_data = InventoryManager.slots[inventory_slot_origin]
			belt_slots[slot_index] = {
				"name": item_to_equip,
				"amount": inv_data["amount"] if inv_data != null else 1
			}
			InventoryManager.remove_item_from_slot(inventory_slot_origin)
		actualizar_belt()
		equip_mode = false
		item_to_equip = ""
		belt_open = false
		animacion.play("close_belt")
		await animacion.animation_finished
		visible = false
		var player = get_tree().get_first_node_in_group("player")
		if player:
			ItemUsage.use_item(player, belt_slots[slot_index]["name"])
		equip_done.emit()
func actualizar_belt() -> void:
	var displays = [null, slot1_display, slot2_display, slot3_display, slot4_display]
	var amounts = [null, slot1_amount, slot2_amount, slot3_amount, slot4_amount]
	for i in range(1, 5):
		if displays[i] == null:
			continue
		if belt_slots[i] != null:
			var item_name = belt_slots[i]["name"]
			var item_amount = belt_slots[i]["amount"]
			var textura = InventoryManager.get_inventory_texture(item_name)
			displays[i].texture = textura
			displays[i].visible = true
			var max_stack = InventoryManager.item_max_stack.get(item_name, 1)
			if max_stack > 1 and amounts[i] != null:
				amounts[i].text = str(item_amount)
				amounts[i].visible = true
			else:
				if amounts[i]: amounts[i].visible = false
		else:
			displays[i].texture = null
			displays[i].visible = false
			if amounts[i]: amounts[i].visible = false
func show_warning(text: String) -> void:
	warning_label.text = text
	warning_label.modulate.a = 1.0
	warning_label.visible = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_property(warning_label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): warning_label.visible = false)
func _on_slot_1_mouse_entered() -> void:
	slot_label.text = belt_slots[1]["name"] if belt_slots[1] != null else "Empty"
	var tween = create_tween()
	tween.tween_property(slot1_node, "position:y", slot1_base.y - 5, 0.1)
func _on_slot_1_mouse_exited() -> void:
	slot_label.text = ""
	var tween = create_tween()
	tween.tween_property(slot1_node, "position:y", slot1_base.y, 0.1)
func _on_slot_2_mouse_entered() -> void:
	slot_label.text = belt_slots[2]["name"] if belt_slots[2] != null else "Empty"
	var tween = create_tween()
	tween.tween_property(slot2_node, "position:x", slot2_base.x + 5, 0.1)
func _on_slot_2_mouse_exited() -> void:
	slot_label.text = ""
	var tween = create_tween()
	tween.tween_property(slot2_node, "position:x", slot2_base.x, 0.1)
func _on_slot_3_mouse_entered() -> void:
	slot_label.text = belt_slots[3]["name"] if belt_slots[3] != null else "Empty"
	var tween = create_tween()
	tween.tween_property(slot3_node, "position:y", slot3_base.y + 5, 0.1)
func _on_slot_3_mouse_exited() -> void:
	slot_label.text = ""
	var tween = create_tween()
	tween.tween_property(slot3_node, "position:y", slot3_base.y, 0.1)
func _on_slot_4_mouse_entered() -> void:
	slot_label.text = belt_slots[4]["name"] if belt_slots[4] != null else "Empty"
	var tween = create_tween()
	tween.tween_property(slot4_node, "position:x", slot4_base.x - 5, 0.1)
func _on_slot_4_mouse_exited() -> void:
	slot_label.text = ""
	var tween = create_tween()
	tween.tween_property(slot4_node, "position:x", slot4_base.x, 0.1)
func _on_slot_1_pressed() -> void:
	_on_slot_pressed(1)
func _on_slot_2_pressed() -> void:
	_on_slot_pressed(2)
func _on_slot_3_pressed() -> void:
	_on_slot_pressed(3)
func _on_slot_4_pressed() -> void:
	_on_slot_pressed(4)
