extends Control

#|------Variables----------|
#region
@export var food_bar: TextureProgressBar
@export var water_bar: TextureProgressBar
@export var foodlabel: Label
@export var waterlabel: Label

var food = 100
var water = 100
var hovering_food = false
var hovering_water = false
#endregion

#|------Funciones--------|
#region
func _ready() -> void:
	foodlabel.visible = false
	waterlabel.visible = false
	hambre()
	sed()
	food_bar.value = 100
	water_bar.value = 100
	
func hambre():
	while true:
		if food > 0:
			await get_tree().create_timer(15.0).timeout
			food -= 1
			food = clamp(food, 0, 100)
			food_bar.value = food
			foodlabel.text = str(food) + "%"
		else:
			food -= 0
		
func sed():
	while true:
		if water > 0:
			await get_tree().create_timer(11.0).timeout
			water -= 1
			water = clamp(water, 0 ,100)
			water_bar.value = water
			waterlabel.text = str(water) + "%" 
		else:
			water -=0

func _on_food_mouse_entered() -> void:
	hovering_food = true
	await get_tree().create_timer(1.5).timeout
	
	if hovering_food:
		foodlabel.visible = true

func _on_food_mouse_exited() -> void:
	hovering_food = false
	foodlabel.visible = false

func _on_water_mouse_entered() -> void:
	hovering_water = true
	await get_tree().create_timer(1.5).timeout
	
	if hovering_water:
		waterlabel.visible = true
	
func _on_water_mouse_exited() -> void:
	hovering_water = false
	waterlabel.visible = false
#endregion
