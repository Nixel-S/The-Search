extends CharacterBody2D

#|----------------------------------Variables----------------------------------|
@onready var character_sprite = $AnimatedSprite2D
@onready var colision: CollisionShape2D
@export var inventory_ui: Control

var last_direction = "s"

#|---------------------------------Constantes----------------------------------|
const velocidad = 100
const velocidad_run = 150

#|---------------------------------Funciones-----------------------------------|
func _physics_process(_delta):

	#|------------------- Inventario abierto -------------------|


	#|-----------------------------Direcciones---------------------------------| 
	var horizontal = Input.get_axis("left", "right")
	var vertical = Input.get_axis("up", "down")

	var direction = Vector2(horizontal, vertical)

	direction = direction.normalized()

	#|-----------------------------Correr--------------------------------------|
	if Input.is_action_pressed("run"):
		velocity = direction * velocidad_run
		
	else:
		velocity = direction * velocidad

	#|----------------------------Animaciones----------------------------------|

	#|-Diagonales-|
#region Diagonales M
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
#endregion
	#|-Cardinales-|
#region Cardinales M
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
#endregion

	#|------------Idles-----------|
	if direction == Vector2.ZERO:
		play_idle()

	move_and_slide()


#|-------------------------- Funcion Idle -----------------------------------|
func play_idle():

	#|---Cardinales---|
#region Cardinales
	if last_direction == "n":
		character_sprite.play("idle_n")

	elif last_direction == "s":
		character_sprite.play("idle_s")

	elif last_direction == "w":
		character_sprite.play("idle_w")

	elif last_direction == "e":
		character_sprite.play("idle_e")
#endregion

	#|---Diagonales---|
#region Diagonales
	elif last_direction == "nw":
		character_sprite.play("idle_nw")

	elif last_direction == "ne":
		character_sprite.play("idle_ne")

	elif last_direction == "sw":
		character_sprite.play("idle_sw")

	elif last_direction == "se":
		character_sprite.play("idle_se")
#endregion
