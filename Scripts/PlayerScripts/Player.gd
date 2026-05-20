extends CharacterBody2D
@onready var character_sprite = $AnimatedSprite2D
@onready var colision: CollisionShape2D
@export var inventory_ui: Control
@export var canvas_modulate: CanvasModulate
var last_direction = "s"
const velocidad = 100
const velocidad_run = 150
var current_health: float = 100.0
var max_health: float = 100.0
var is_poisoned: bool = false
var poison_damage_per_second: float = 0.0
var poison_duration: float = 0.0
func _ready() -> void:
	add_to_group("player")
	if canvas_modulate == null:
		canvas_modulate = get_tree().root.get_node("CanvasModulate")
func _physics_process(_delta):
	apply_poison_damage(_delta)
	update_visual_health()
	var horizontal = Input.get_axis("left", "right")
	var vertical = Input.get_axis("up", "down")
	var direction = Vector2(horizontal, vertical)
	direction = direction.normalized()
	var current_speed = velocidad
	if Input.is_action_pressed("run") and current_health > 5:
		current_speed = velocidad_run
	else:
		var health_penalty = (100.0 - current_health) / 100.0 * 0.05
		current_speed = velocidad * (1.0 - health_penalty)
	velocity = direction * current_speed
	if direction.x > 0 and direction.y < 0:
		character_sprite.play("walk_ne")
		last_direction = "ne"
	elif direction.x < 0 and direction.y < 0:
		character_sprite.play("walk_nw")
		last_direction = "nw"
	elif direction.x > 0 and direction.y > 0:
		character_sprite.play("walk_se")
		last_direction = "se"
	elif direction.x < 0 and direction.y > 0:
		character_sprite.play("walk_sw")
		last_direction = "sw"
	elif direction.y < 0:
		character_sprite.play("walk_n")
		last_direction = "n"
	elif direction.y > 0:
		character_sprite.play("walk_s")
		last_direction = "s"
	elif direction.x > 0:
		character_sprite.play("walk_e")
		last_direction = "e"
	elif direction.x < 0:
		character_sprite.play("walk_w")
		last_direction = "w"
	if direction == Vector2.ZERO:
		play_idle()
	move_and_slide()
func play_idle():
	if last_direction == "n":
		character_sprite.play("idle_n")
	elif last_direction == "s":
		character_sprite.play("idle_s")
	elif last_direction == "w":
		character_sprite.play("idle_w")
	elif last_direction == "e":
		character_sprite.play("idle_e")
	elif last_direction == "nw":
		character_sprite.play("idle_nw")
	elif last_direction == "ne":
		character_sprite.play("idle_ne")
	elif last_direction == "sw":
		character_sprite.play("idle_sw")
	elif last_direction == "se":
		character_sprite.play("idle_se")
func take_damage(amount: float) -> void:
	current_health -= amount
	if current_health < 0:
		current_health = 0
	if current_health <= 0:
		die()
func heal(amount: float) -> void:
	current_health += amount
	if current_health > max_health:
		current_health = max_health
func apply_poison(damage_per_second: float, duration: float) -> void:
	poison_damage_per_second = damage_per_second
	poison_duration = duration
	is_poisoned = true
func apply_poison_damage(delta: float) -> void:
	if is_poisoned:
		poison_duration -= delta
		take_damage(poison_damage_per_second * delta)
		if poison_duration <= 0:
			is_poisoned = false
			poison_damage_per_second = 0.0
func update_visual_health() -> void:
	var health_ratio = current_health / max_health
	var color = Color.WHITE.lerp(Color.BLACK, 1.0 - health_ratio)
	if canvas_modulate:
		canvas_modulate.color = color
func die() -> void:
	print("Player murio")
	get_tree().reload_current_scene()
