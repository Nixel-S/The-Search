extends TextureButton

var slot_index: int = 0

@export var dragged_item: TextureRect

func _ready() -> void:
	if dragged_item:
		dragged_item.visible = false


func _process(_delta: float) -> void:
	if dragged_item and dragged_item.visible:
		dragged_item.global_position = get_global_mouse_position() - dragged_item.size / 2


func _get_drag_data(_at_position: Vector2):
	var slot_data = InventoryManager.slots[slot_index]
	if slot_data == null:
		return null
	if dragged_item:
		dragged_item.texture = InventoryManager.get_texture(slot_data["name"])
		dragged_item.visible = true
	return slot_index


func _can_drop_data(_at_position: Vector2, data) -> bool:
	return data is int


func _drop_data(_at_position: Vector2, data) -> void:
	if dragged_item:
		dragged_item.visible = false
	if data == null:
		return
	if data == slot_index:
		return
	InventoryManager.swap_slots(data, slot_index)


func _notification(what):

	if what == NOTIFICATION_DRAG_END:
		if dragged_item:
			dragged_item.visible = false
