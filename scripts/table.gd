extends AnimatedSprite2D
func _ready():
	# При старте игры включаем средний огонь по умолчанию
	play("medium")

# Эту функцию вызываем, когда игрок закинул основу в котел
func change_fire_mode(base_name: String):
	
	match base_name:
		"cornet_base":
			play("cold")    # Godot сам начнет крутить цикличную анимацию холода
		"cocktail_base":
			play("medium")
			  # Включается анимация маффина
		"waffle_base","muffin_base":
			play("hot")     # Включается максимальный огонь
