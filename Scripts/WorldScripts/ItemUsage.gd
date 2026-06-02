extends Node
func use_item(player: CharacterBody2D, item_name: String) -> void:
	if ItemAttributes == null:
		print("ERROR: ItemAttributes no cargado")
		return
	var attrs = ItemAttributes.get_attributes(item_name)
	if attrs.is_empty():
		print("Item sin atributos: ", item_name)
		return
	var item_type = attrs.get("type", "")
	match item_type:
		"consumable":
			consume_item(player, item_name, attrs)
		"weapon":
			print("Arma equipada: ", item_name)
		"fuel":
			print("Combustible: ", item_name)
		"tool":
			print("Herramienta: ", item_name)
		"material":
			print("Material: ", item_name)
		"story":
			print("Item de historia: ", item_name)
func consume_item(player: CharacterBody2D, _item_name: String, attrs: Dictionary) -> void:
	if attrs.has("health"):
		var health_amount = attrs["health"]
		player.heal(health_amount)
		print("Sanado: +", health_amount, " vida")
	if attrs.has("hunger"):
		print("Hambre satisfecha: +", attrs["hunger"])
	if attrs.has("thirst"):
		print("Sed satisfecha: +", attrs["thirst"])
	if attrs.has("poison_chance"):
		var poison_chance = attrs.get("poison_chance", 0.0)
		if randf() < poison_chance:
			var poison_damage = attrs.get("poison_damage", 1.0)
			var poison_duration = attrs.get("poison_duration", 10.0)
			player.apply_poison(poison_damage, poison_duration)
			print("¡Envenenado! Daño: ", poison_damage, "/s durante ", poison_duration, "s")
