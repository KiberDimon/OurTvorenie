extends Control

enum Temp { COLD, MEDIUM, HOT }
var direction = 1
var current_temp = Temp.MEDIUM

@onready var wand = $".."
func _on_pressed() -> void:
	print("Текущая температура: ", current_temp)
	
	if current_temp == Temp.HOT:
		direction = -1
	elif current_temp == Temp.COLD:
		direction = 1
		
	current_temp = (current_temp + direction) as Temp
	update_visuals()
	
func update_visuals():
	
	var target_rotation = 0 # Угол в градусах
	
	match current_temp:
		Temp.HOT:
			target_rotation = -30 # Смотрит вверх
			self.self_modulate = Color(1, 0.2, 0)
		Temp.MEDIUM:
			target_rotation = 0   # Смотрит прямо
			self.self_modulate = Color(1, 1, 1)
		Temp.COLD:
			target_rotation = 30  # Смотрит вниз
			self.self_modulate = Color(0, 0.5, 1)

	var tween = create_tween()
	tween.tween_property(wand, "rotation_degrees", target_rotation, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
