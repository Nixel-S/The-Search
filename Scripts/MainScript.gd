extends Node2D

func _ready() -> void:
	$CanvasLayer/Inventory.equip_requested.connect($CanvasLayer/Belt.on_equip_requested)
	$CanvasLayer/Belt.equip_done.connect($CanvasLayer/Inventory.reopen_inventory)
	$CanvasLayer/Belt.warning_label = $CanvasLayer/WarningLabel
