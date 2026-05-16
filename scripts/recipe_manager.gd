# recipe_manager.gd
extends Node

@export var all_ingredients: Array[Ingredient] = []
@export var recipes: Array[Recipe] = []

var _recipe_map: Dictionary = {}

func _ready():
	_build_recipe_map()
	#print("=== RecipeManager ready ===")
	#print("Рецептов в массиве: ", recipes.size())
	#print("Ключей в мапе: ", _recipe_map.size())

func _build_recipe_map():
	_recipe_map.clear()
	for recipe in recipes:
		# Проверяем, не пустые ли ссылки на ингредиенты
		if not recipe.base or not recipe.cream or not recipe.topping:
			print("ПРОПУСК РЕЦЕПТА: отсутствует ссылка на ингредиент")
			continue
		
		var b_id = recipe.base.id
		var c_id = recipe.cream.id
		var t_id = recipe.topping.id
		var key = _make_key(b_id, c_id, t_id)
		
		#print("Добавляю: ", key, " | result=", recipe.result.display_name if recipe.result else "NULL")
		_recipe_map[key] = recipe

func get_result(base_id: StringName, cream_id: StringName, topping_id: StringName) -> DessertResult:
	var key = _make_key(base_id, cream_id, topping_id)
	print("Ищем ключ: '", key, "'")
	print("Содержится в мапе: ", _recipe_map.has(key))
	
	if _recipe_map.has(key):
		var recipe: Recipe = _recipe_map[key]
		print("Рецепт найден. Поле result: ", recipe.result)
		if recipe.result:
			print("Возвращаю: ", recipe.result.display_name)
			return recipe.result
		else:
			push_warning("Рецепт есть, но result == null для ключа: ", key)
			return null
	else:
		push_warning("Рецепт не найден для ключа: ", key)
		return null

func _make_key(b: StringName, c: StringName, t: StringName) -> String:
	return str(b) + "|" + str(c) + "|" + str(t)
