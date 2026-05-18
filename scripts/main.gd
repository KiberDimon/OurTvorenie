extends Node

@onready var menu = $Menu
@onready var cauldron = $MainUI/Cauldron
@onready var table = $Table
func _ready():
	AudioManager.play_sfx(preload("res://audio/audio_assets/костер.mp3"))
	cauldron.base_dropped.connect(table.change_fire_mode)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _on_start_pressed():
	menu.hide()
func _notification(what: int) -> void:
	match what:
		# Срабатывает автоматически, когда игрок зажал и потащил ингредиент
		NOTIFICATION_DRAG_BEGIN:
			$Cursor.hide() # Полностью прячем курсор
			
		# Срабатывает автоматически, когда игрок отпустил ингредиент (в котел или мимо)
		NOTIFICATION_DRAG_END:
			$Cursor.show() # Возвращаем курсор назад
func _on_exit_pressed():
	get_tree().quit()
