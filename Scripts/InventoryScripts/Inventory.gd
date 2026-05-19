extends Control

signal equip_requested(item_name, inv_slot)

@export var infomenu: Control
@export var equip: TextureRect
@export var animacion_inv: AnimationPlayer
@export var item_display_preview: TextureRect
@export var item_name_label: Label
@export var item_description_label: Label
@export var world_item_scene: PackedScene

var inventory_open := false
var selected_slot := -1


func _ready() -> void:
	visible = false
	inventory_open = false
	InventoryManager.item_added.connect(actualizar_slots)
	for i in range(16):
		var slot = get_node("SlotsContainer/" + str(i + 1))
		slot.slot_index = i
		slot.pressed.connect(_on_slot_clicked.bind(i))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("equip") and inventory_open:
		if selected_slot != -1 and equip.visible:
			var slot_data = InventoryManager.slots[selected_slot]
			if slot_data != null:
				var item = slot_data["name"]
				equip_requested.emit(item, selected_slot)
				inventory_open = false
				visible = false
				infomenu.visible = false
				selected_slot = -1

	if Input.is_action_just_pressed("drop") and inventory_open:
		if selected_slot != -1:
			var slot_data = InventoryManager.slots[selected_slot]
			if slot_data != null:
				var item_name = slot_data["name"]
				var player = get_tree().get_first_node_in_group("player")
				if player:
					var dropped = world_item_scene.instantiate()
					dropped.item_name = item_name
					dropped.global_position = player.global_position
					get_tree().current_scene.add_child(dropped)
				InventoryManager.remove_item_from_slot(selected_slot)
				infomenu.visible = false
				selected_slot = -1
				actualizar_slots()

	if Input.is_action_just_pressed("inventory"):
		inventory_open = !inventory_open
		if inventory_open:
			animacion_inv.stop()
			infomenu.visible = false
			await get_tree().process_frame
			visible = true
			animacion_inv.play("open_inventory")
			actualizar_slots()
		else:
			infomenu.visible = false
			selected_slot = -1
			animacion_inv.play("close_inventory")
			await animacion_inv.animation_finished
			if not inventory_open:
				visible = false

func actualizar_slots() -> void:
	for i in range(16):
		var slot = get_node("SlotsContainer/" + str(i + 1))
		var item_display = slot.get_node("ItemTexture")
		var amount_label = slot.get_node("Amount")
		var slot_data = InventoryManager.slots[i]
		if slot_data != null:
			item_display.texture = InventoryManager.get_inventory_texture(slot_data["name"])
			item_display.visible = true
			var max_stack = InventoryManager.item_max_stack.get(slot_data["name"], 1)
			if max_stack > 1:
				amount_label.text = str(slot_data["amount"])
				amount_label.visible = true
			else:
				amount_label.visible = false
		else:
			item_display.visible = false
			amount_label.visible = false


func _on_slot_clicked(slot_index: int) -> void:
	selected_slot = slot_index
	var slot_data = InventoryManager.slots[slot_index]
	if slot_data == null:
		infomenu.visible = false
		return
	infomenu.visible = true
	equip.visible = InventoryManager.is_equippable(slot_data["name"])
	var item_name = slot_data["name"]
	var info = InventoryManager.get_item_info(item_name)
	item_name_label.text = info["name"]
	item_description_label.text = info["description"]
	item_display_preview.texture = InventoryManager.get_inventory_texture(item_name)

func reopen_inventory() -> void:
	inventory_open = true
	animacion_inv.stop()
	await get_tree().process_frame
	visible = true
	animacion_inv.play("open_inventory")
	actualizar_slots()
