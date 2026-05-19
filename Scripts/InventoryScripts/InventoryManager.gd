extends Node

signal item_added

# =========================
# TEXTURAS
# =========================
# =========================
# INVENTORY TEXTURES
# =========================
var inventory_textures = {
	"axe": preload("res://Assets/ItemsInventory/Axe_Item.png"),
	"mini_log": preload("res://Assets/ItemsInventory/MiniLog_Item.png"),
	"stick": preload("res://Assets/ItemsInventory/Stick_Item.png"),
	"stone": preload("res://Assets/ItemsInventory/Stone_Item.png"),
	"sharp_stone": preload("res://Assets/ItemsInventory/Sharp_Stone_Item.png"),
	"rope": preload("res://Assets/ItemsInventory/Rope_Item.png"),
	"torn_cloth": preload("res://Assets/ItemsInventory/Torn_Cloth_Item.png"),
	"rusted_metal": null,
	"raw_meat": preload("res://Assets/ItemsInventory/RawMeat_Item.png"),
	"cooked_meat": preload("res://Assets/ItemsInventory/CookedMeat_Item.png"),
	"berries": preload("res://Assets/ItemsInventory/Berries_Item.png"),
	"mushroom": preload("res://Assets/ItemsInventory/Mushroom_Item.png"),
	"canned_food": preload("res://Assets/ItemsInventory/CannedFood_Item.png"),
	"empty_bottle": preload("res://Assets/ItemsInventory/EmptyBottle_Item.png"),
	"dirty_water": preload("res://Assets/ItemsInventory/DirtyWaterBottle_Item.png"),
	"clean_water": preload("res://Assets/ItemsInventory/WaterBottle_Item.png"),
	"medicinal_herbs": preload("res://Assets/ItemsInventory/MedicinalHerbs_Item.png"),
	"improvised_bandage": preload("res://Assets/ItemsInventory/Vendas_Item.png"),
	"antiseptic": preload("res://Assets/ItemsInventory/Antiseptic_Item.png"),
	"lighter": preload("res://Assets/ItemsInventory/Ligther_item.png"),
	"knife": preload("res://Assets/ItemsInventory/Knife_Item.png"),
	"torn_map": preload("res://Assets/ItemsInventory/Torn_Map_Item.png"),
	"diary_page": null,
	"torn_note": null,
	"old_photo": null,
}

# =========================
# WORLD TEXTURES
# =========================
var world_textures = {
	"axe": preload("res://Assets/ItemsInventory/ItemsGround/Axe_item.png"),
	"mini_log": preload("res://Assets/ItemsInventory/ItemsGround/MiniLog_item.png"),
	"stick": preload("res://Assets/ItemsInventory/ItemsGround/Stick_item.png"),
	"stone": preload("res://Assets/ItemsInventory/ItemsGround/Stone_item.png"),
	"sharp_stone": preload("res://Assets/ItemsInventory/ItemsGround/ShrapStone_item.png"),
	"rope": preload("res://Assets/ItemsInventory/ItemsGround/Rope_item.png"),
	"torn_cloth": preload("res://Assets/ItemsInventory/ItemsGround/Cloth_item.png"),
	"rusted_metal": null,
	"raw_meat": preload("res://Assets/ItemsInventory/ItemsGround/RawMeat_item.png"),
	"cooked_meat": preload("res://Assets/ItemsInventory/ItemsGround/CookedMeat_item.png"),
	"berries": preload("res://Assets/ItemsInventory/ItemsGround/Berries_item.png"),
	"mushroom": preload("res://Assets/ItemsInventory/ItemsGround/Mushroom_item.png"),
	"canned_food": preload("res://Assets/ItemsInventory/ItemsGround/CannedFood_item.png"),
	"empty_bottle": preload("res://Assets/ItemsInventory/ItemsGround/BottleEmpty_item.png"),
	"dirty_water": preload("res://Assets/ItemsInventory/ItemsGround/DirtyWater_item.png"),
	"clean_water": preload("res://Assets/ItemsInventory/ItemsGround/Water_item.png"),
	"medicinal_herbs": preload("res://Assets/ItemsInventory/ItemsGround/Herbs_item.png"),
	"improvised_bandage": preload("res://Assets/ItemsInventory/ItemsGround/Bandage_item.png"),
	"antiseptic": preload("res://Assets/ItemsInventory/ItemsGround/Antiseptic_item.png"),
	"lighter": preload("res://Assets/ItemsInventory/ItemsGround/Lighter_item.png"),
	"knife": preload("res://Assets/ItemsInventory/ItemsGround/Knife_item.png"),
	"torn_map": preload("res://Assets/ItemsInventory/ItemsGround/Map_item.png"),
	"diary_page": null,
	"torn_note": null,
	"old_photo": null,
}

# =========================
# INFO ITEMS
# =========================
var item_info = {
	"axe": {"name": "Axe", "description": "A heavy axe used for chopping\ntrees and basic defense.\nDamage = 10"},
	"mini_log": {"name": "Log", "description": "A thick piece of wood.\nUseful for building fires."},
	"stick": {"name": "Stick", "description": "A thin dry branch.\nCan be used as a torch\nor crafting material."},
	"stone": {"name": "Stone", "description": "A common rock.\nUseful for crafting basic tools."},
	"sharp_stone": {"name": "Sharp Stone", "description": "A jagged rock with a cutting edge.\nDamage = 4"},
	"rope": {"name": "Rope", "description": "A length of old rope.\nEssential for crafting and\nsecuring things."},
	"torn_cloth": {"name": "Torn Cloth", "description": "A piece of ragged fabric.\nCan be used for bandages \ndddor insulation."},
	"rusted_metal": {"name": "Rusted Metal", "description": "A corroded metal scrap.\nStill useful for crafting."},
	"broken_glass": {"name": "Broken Glass", "description": "A sharp shard of glass.\nDangerous but useful as a cutting tool."},
	"raw_meat": {"name": "Raw Meat", "description": "Uncooked animal meat.\nCook it before eating.\n+10 Hunger (raw)"},
	"cooked_meat": {"name": "Cooked Meat", "description": "Well-cooked animal meat.\nRestores hunger significantly.\n+30 Hunger"},
	"berries": {"name": "Berries", "description": "Wild berries found in the forest.\n+10 Hunger  +5 Thirst"},
	"mushroom": {"name": "Mushroom", "description": "A wild mushroom.\nEdible but inspect carefully.\n+15 Hunger"},
	"canned_food": {"name": "Canned Food", "description": "A sealed can of preserved food.\nRare but very filling.\n+40 Hunger"},
	"empty_bottle": {"name": "Empty Bottle", "description": "Yeah it's an empty bottle \nWOOOW"},
	"dirty_water": {"name": "Dirty Water", "description": "Contaminated water.\nBoil it before drinking.\n+10 Thirst (risky)"},
	"clean_water": {"name": "Clean Water", "description": "Purified safe water.\n+30 Thirst"},
	"medicinal_herbs": {"name": "Medicinal Herbs", "description": "Wild herbs with healing properties.\n+15 Health"},
	"improvised_bandage": {"name": "Bandage", "description": "A rough cloth bandage.\nStops bleedings, heals minor wounds.\n+20 Health"},
	"antiseptic": {"name": "Antiseptic", "description": "A chemical solution\nto prevent infection.\n+10 Health  Prevents infection"},
	"lighter": {"name": "Lighter", "description": "A small fuel lighter.\nEssential for starting fires.\nLimited uses."},
	"knife": {"name": "Knife", "description": "A worn survival knife.\nUseful for hunting and defense.\nDamage = 6"},
	"torn_map": {"name": "Torn Map", "description": "A fragment of an old map.\nMaybe it leads somewhere important."},
	"diary_page": {"name": "Diary Page", "description": "A torn page from someone's diary.\nThe handwriting is familiar..."},
	"torn_note": {"name": "Torn Note", "description": "A fragment of a handwritten note.\nThe rest is missing."},
	"old_photo": {"name": "Old Photo", "description": "A faded photograph.\nTwo people smiling. Who are they?"},
}

# =========================
# STACKS
# =========================
var item_max_stack = {
	"axe": 1,
	"stick": 20,
	"mini_log": 15,
	"lighter": 1,
	"knife": 1,
	"animal_trap": 1,
	"torn_map": 1,
	"stone": 20,
	"sharp_stone": 20,
	"rope": 15,
	"torn_cloth": 20,
	"rusted_metal": 15,
	"raw_meat": 15,
	"cooked_meat": 15,
	"berries": 20,
	"mushroom": 20,
	"canned_food": 15,
	"empty_bottle" : 15,
	"dirty_water": 10,
	"clean_water": 10,
	"medicinal_herbs": 20,
	"improvised_bandage": 10,
	"antiseptic": 10,
	"diary_page": 1,
	"torn_note": 1,
	"old_photo": 1,
}

# =========================
# EQUIPABLES
# =========================
var equippable_items = [
	"axe",
	"raw_meat",
	"cooked_meat",
	"berries",
	"canned_food",
	"clean_water",
	"dirty_water",
	"improvised_bandage",
	"medicinal_herbs",
	"antiseptic",
	"lighter",
	"knife",
	"torn_map"
]

# =========================
# INVENTORY
# =========================
const MAX_SLOTS := 16
var slots = []

func _ready() -> void:

	for i in range(MAX_SLOTS):
		slots.append(null)

# =========================
# ADD ITEM
# =========================
func add_item(nombre: String) -> bool:
	var max_stack = item_max_stack.get(nombre, 1)
	# STACK
	for i in range(MAX_SLOTS):
		if slots[i] != null:
			if slots[i]["name"] == nombre:
				if slots[i]["amount"] < max_stack:
					slots[i]["amount"] += 1
					item_added.emit()
					return true
	# EMPTY SLOT
	for i in range(MAX_SLOTS):
		if slots[i] == null:
			slots[i] = {
				"name": nombre,
				"amount": 1
			}
			item_added.emit()
			return true
	print("Inventory full")
	return false
# =========================
# SWAP SLOTS
# =========================
func swap_slots(from_slot: int, to_slot: int) -> void:
	var temp = slots[from_slot]
	slots[from_slot] = slots[to_slot]
	slots[to_slot] = temp
	item_added.emit()
	
func get_inventory_texture(nombre: String) -> Texture2D:
	return inventory_textures.get(nombre, null)
	
func get_world_texture(nombre: String) -> Texture2D:
	return world_textures.get(nombre, null)

func get_item_info(nombre: String) -> Dictionary:
	return item_info.get(nombre, {
		"name": nombre,
		"description": "No description available."
	})

func is_equippable(nombre: String) -> bool:
	return nombre in equippable_items

func remove_item_from_slot(slot_index: int) -> void:
	if slot_index < 0:
		return
	if slot_index >= MAX_SLOTS:
		return
	slots[slot_index] = null
	item_added.emit()
