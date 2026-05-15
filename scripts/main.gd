extends Node

@onready var menu = $Menu
@onready var cauldron = $MainUI/Cauldron
@onready var table = $Table
func _ready():
	cauldron.base_dropped.connect(table.change_fire_mode)
	
	
func _on_start_pressed():
	menu.hide()

func _on_exit_pressed():
	get_tree().quit()
