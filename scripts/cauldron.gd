# Cauldron.gd
extends Control

signal ingredient_added(category: Ingredient.Category)
signal dessert_ready(result: DessertResult)
signal base_dropped(base_name: String)
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
	if ingredient.category == Ingredient.Category.BASE:
		base_dropped.emit(ingredient.id)
	# Сообщаем UI: «категория занята»
	ingredient_added.emit(ingredient.category)
	
	# Если все три категории на месте — готовим
	if _current.size() == 3:
		
		var base_id = _current[Ingredient.Category.BASE].id
		var cream_id = _current[Ingredient.Category.CREAM].id
		var topping_id = _current[Ingredient.Category.TOPPING].id
		print("Запрашиваю: base=%s cream=%s topping=%s" % [base_id, cream_id, topping_id])
	
		var result = RecipeManager.get_result(base_id, cream_id, topping_id)
		print("Результат: ", result)
		$"../Puf".play("puf")
		dessert_ready.emit(result)
		_current.clear()
		cleared.emit()
