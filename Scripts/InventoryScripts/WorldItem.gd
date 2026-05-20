extends Area2D
@export var e_key: TextureRect
@export var item_name: String = ""
@export var pop_sound: AudioStreamPlayer
@export var sprite: Sprite2D
var can_pickup = false
func _ready() -> void:
	e_key.visible = false
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	scale = Vector2(0.35, 0.35)
	var e_tween = create_tween()
	e_tween.set_loops()
	e_tween.tween_property(e_key, "position:y", -90, 0.5)
	e_tween.tween_property(e_key, "position:y", -80, 0.5)
	var item_tween = create_tween()
	item_tween.set_loops()
	item_tween.tween_property(sprite, "position:y", -3, 0.5)
	item_tween.tween_property(sprite, "position:y", 3, 0.5)
	var textura = InventoryManager.get_world_texture(item_name)
	if textura:
		sprite.texture = textura
func _process(_delta):
	if can_pickup and Input.is_action_just_pressed("action"):
		var picked = InventoryManager.add_item(item_name)
		if picked:
			pop_sound.play()
			await pop_sound.finished
			queue_free()
		else:
			show_inventory_full()
func _on_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("player"):
		can_pickup = true
		e_key.visible = true
func _on_area_exited(_area: Area2D) -> void:
	if _area.is_in_group("player"):
		can_pickup = false
		e_key.visible = false
func show_inventory_full() -> void:
	var inventory = get_tree().get_first_node_in_group("inventory")
	if inventory and inventory.has_method("show_warning"):
		inventory.show_warning("¡ Full Inventory !")
