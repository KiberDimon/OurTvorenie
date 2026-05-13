# IngredientCard.gd
extends Control

@export var ingredient: Ingredient
@onready var label: Label



func _get_drag_data(at_position: Vector2) -> Variant:
	# Создаём визуальный превью (дубликат иконки)
	var preview = TextureRect.new()
	preview.texture = ingredient.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = Vector2(80, 80)
	set_drag_preview(preview)
	
	# Возвращаем данные, которые полетят в котёл
	return { "ingredient": ingredient }

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# Мы не разрешаем дропать на сами карточки
	return false
