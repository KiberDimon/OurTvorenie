class_name Ingredient
extends Resource

enum Category { BASE, CREAM, TOPPING }

@export var id: StringName           # Уникальный ключ, например "muffin_base"
@export var display_name: String
@export var category: Category
@export var texture: Texture2D       # Иконка для перетаскивания
