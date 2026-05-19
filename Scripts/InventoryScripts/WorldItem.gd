extends Area2D

@export var e_key: TextureRect
@export var item_name: String = ""
@export var pop_sound: AudioStreamPlayer
@export var sprite: Sprite2D

var can_pickup = false
var cantidad = 0

func _ready() -> void:
	e_key.visible = false
	var e_tween = create_tween()
	e_tween.set_loops()
	e_tween.tween_property(e_key, "position:y", -35, 0.5)
	e_tween.tween_property(e_key, "position:y", -30, 0.5)
	var item_tween = create_tween()
	item_tween.set_loops()
	item_tween.tween_property(sprite, "position:y", -1, 0.5)
	item_tween.tween_property(sprite, "position:y", 1, 0.5)
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

func _on_area_entered(_area: Area2D) -> void:
	can_pickup = true
	e_key.visible = true

func _on_area_exited(_area: Area2D) -> void:
	can_pickup = false
	e_key.visible = false
