extends Node

@onready var menu = $Menu
@onready var game_level = $GameLevel

func _on_start_pressed():
	menu.hide()
	game_level.show()

func _on_exit_pressed():
	get_tree().quit()
