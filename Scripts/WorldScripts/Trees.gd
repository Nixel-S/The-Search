extends Node2D
@export var tree_type: int = 0
@export var sprite: Sprite2D
@export var collision: CollisionShape2D
@export var detection_area: Area2D
var max_health: int = 4
var current_health: int = 4
var last_hit_time: float = 0.0
var hit_cooldown: float = 0.5
var is_dead: bool = false
var hurt_animation_playing: bool = false
var player_in_range: bool = false
func _ready() -> void:
	if sprite == null:
		sprite = $Sprite2D
	if detection_area == null:
		detection_area = $Area2D
	current_health = max_health
	detection_area.area_entered.connect(_on_area_entered)
	detection_area.area_exited.connect(_on_area_exited)
func _process(_delta: float) -> void:
	if not player_in_range:
		return
	if Input.is_action_just_pressed("action"):
		attempt_hit()
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_in_range = true
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_in_range = false
func attempt_hit() -> void:
	if is_dead:
		return
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_hit_time < hit_cooldown:
		return
	var equipped_item = get_equipped_item()
	if equipped_item != "axe" and equipped_item != "knife":
		return
	last_hit_time = current_time
	take_damage()
func take_damage() -> void:
	current_health -= 1
	play_hurt_animation()
	print("Árbol golpeado. Salud: ", current_health)
	if current_health <= 0:
		die()
func play_hurt_animation() -> void:
	if hurt_animation_playing:
		return
	hurt_animation_playing = true
	var original_texture = sprite.texture
	var hurt_texture = preload("res://Tiles/Arbol_Hurt.png")
	sprite.texture = hurt_texture
	await get_tree().create_timer(0.2).timeout
	sprite.texture = original_texture
	hurt_animation_playing = false
func die() -> void:
	is_dead = true
	print("Árbol cortado!")
	drop_items()
	queue_free()
func drop_items() -> void:
	var mini_logs = randi_range(4, 6)
	var sticks = randi_range(2, 3)
	print("Dropeando: ", mini_logs, " mini_logs y ", sticks, " sticks")
	for i in range(mini_logs):
		create_world_item("mini_log")
	for i in range(sticks):
		create_world_item("stick")
func create_world_item(item_name: String) -> void:
	var world_item_scene = preload("res://Escenas/WorldItem.tscn")
	var dropped = world_item_scene.instantiate()
	dropped.item_name = item_name
	dropped.global_position = global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
	dropped.scale = Vector2(0.35, 0.35)
	get_tree().current_scene.add_child(dropped)
func get_equipped_item() -> String:
	var belt = get_tree().get_first_node_in_group("belt")
	if belt and belt.has_method("get_equipped_item"):
		return belt.get_equipped_item()
	return ""
