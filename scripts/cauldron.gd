# Cauldron.gd
extends Control

signal ingredient_added(category: Ingredient.Category)
signal dessert_ready(result: DessertResult)
signal cleared()

var _current: Dictionary = {}  # Category (int) -> Ingredient

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not data is Dictionary or not data.has("ingredient"):
		return false
	var ingredient: Ingredient = data["ingredient"]
	# Проверяем, не занята ли уже категория
	return not _current.has(ingredient.category)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var ingredient: Ingredient = data["ingredient"]
	_current[ingredient.category] = ingredient
	
	# Сообщаем UI: «категория занята»
	ingredient_added.emit(ingredient.category)
	
	# Если все три категории на месте — готовим
	if _current.size() == 3:
		var result = RecipeManager.get_result(
			_current[Ingredient.Category.BASE].id,
			_current[Ingredient.Category.CREAM].id,
			_current[Ingredient.Category.TOPPING].id
		)
		dessert_ready.emit(result)
		_current.clear()
		cleared.emit()
