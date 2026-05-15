# GuestPool.gd
extends Node
class_name GuestPool
@export var all_guests: Array[GuestData] = []

func get_random_guest() -> GuestData:
	if all_guests.is_empty():
		return null
	return all_guests[randi() % all_guests.size()]

func get_random_dessert() -> DessertResult:
	# Берём случайный рецепт и возвращаем его результат
	var recipes = RecipeManager.recipes
	if recipes.is_empty():
		return null
	var random_recipe: Recipe = recipes[randi() % recipes.size()]
	return random_recipe.result
