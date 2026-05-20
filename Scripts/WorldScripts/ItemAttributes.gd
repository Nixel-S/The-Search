extends Node
var item_attributes = {
	"axe": {
		"type": "weapon",
		"damage": 10
	},
	"mini_log": {
		"type": "fuel",
		"fuel_amount": 10
	},
	"stick": {
		"type": "fuel",
		"fuel_amount": 4
	},
	"stone": {
		"type": "weapon",
		"damage": 3
	},
	"sharp_stone": {
		"type": "weapon",
		"damage": 7
	},
	"rope": {
		"type": "material",
	},
	"torn_cloth": {
		"type": "material",
	},
	"rusted_metal": {
		"type": "material",
	},
	"raw_meat": {
		"type": "consumable",
		"hunger": 15,
		"thirst": 1,
		"poison_damage": 1.0,
		"poison_duration": 20.0,
		"poison_chance": 0.15
	},
	"cooked_meat": {
		"type": "consumable",
		"hunger": 30,
		"health": 3,
		"thirst": 5
	},
	"berries": {
		"type": "consumable",
		"hunger": 10,
		"health": 1,
		"thirst": 5
	},
	"mushroom": {
		"type": "consumable",
		"hunger": 20,
		"thirst": 5,
		"poison_damage": 1.0,
		"poison_duration": 15.0,
		"poison_chance": 0.05
	},
	"canned_food": {
		"type": "consumable",
		"hunger": 50,
		"health": 5,
		"thirst": 7
	},
	"empty_bottle": {
		"type": "material",
	},
	"dirty_water": {
		"type": "consumable",
		"thirst": 35,
		"poison_damage": 1.0,
		"poison_duration": 15.0,
		"poison_chance": 0.50
	},
	"clean_water": {
		"type": "consumable",
		"thirst": 45
	},
	"medicinal_herbs": {
		"type": "consumable",
		"health": 20
	},
	"improvised_bandage": {
		"type": "consumable",
		"health": 45
	},
	"antiseptic": {
		"type": "consumable",
		"health": 45
	},
	"lighter": {
		"type": "tool"
	},
	"knife": {
		"type": "weapon",
		"damage": 25
	},
	"torn_map": {
		"type": "story"
	},
	"diary_page": {
		"type": "story"
	},
	"torn_note": {
		"type": "story"
	},
	"old_photo": {
		"type": "story"
	}
}
func get_attributes(item_name: String) -> Dictionary:
	return item_attributes.get(item_name, {})
func has_attribute(item_name: String, attribute: String) -> bool:
	var attrs = get_attributes(item_name)
	return attrs.has(attribute)
func get_attribute(item_name: String, attribute: String):
	var attrs = get_attributes(item_name)
	return attrs.get(attribute, null)
