# recipe_manager.gd
extends Node

# Массивы, которые мы заполним в редакторе
@export var all_ingredients: Array[Ingredient] = []
@export var recipes: Array[Recipe] = []

var _recipe_map: Dictionary = {}  # Ключ-строка -> Recipe

func _ready():
	_build_recipe_map()

func _build_recipe_map():
	_recipe_map.clear()
	for recipe in recipes:
		var key = _make_key(recipe.base.id, recipe.cream.id, recipe.topping.id)
		# На случай дубликатов — перезапишется последним (можно проверять)
		_recipe_map[key] = recipe

func get_result(base_id: StringName, cream_id: StringName, topping_id: StringName) -> DessertResult:
	var key = _make_key(base_id, cream_id, topping_id)
	if _recipe_map.has(key):
		return _recipe_map[key].result
	push_warning("Рецепт не найден: ", key)
	return null

func _make_key(b: StringName, c: StringName, t: StringName) -> String:
	return str(b) + "|" + str(c) + "|" + str(t)
