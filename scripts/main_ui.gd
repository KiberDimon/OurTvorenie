# MainUI.gd
extends Control

@onready var cauldron = $Cauldron
@onready var base_cards = $IngredientList/BaseCards
@onready var cream_cards = $IngredientList/CreamCards
@onready var topping_cards = $IngredientList/ToppingCards
@onready var tray: Control = $Tray 
@onready var queue_manager: QueueManager = $QueueManager
@onready var money_label: Label = $MoneyLabel
var money: int = 0

func _ready():
	# Соединяем сигналы
	cauldron.ingredient_added.connect(_on_ingredient_added)
	cauldron.dessert_ready.connect(_on_dessert_ready)
	cauldron.cleared.connect(_on_cauldron_cleared)
	queue_manager.guest_served.connect(_on_guest_served)
	# Заполняем карточки из RecipeManager
	_populate_cards()

func _populate_cards():
	for ingredient in RecipeManager.all_ingredients:
		var card = preload("res://scenes/ingredient_card.tscn").instantiate()
		card.ingredient = ingredient
		match ingredient.category:
			Ingredient.Category.BASE:
				base_cards.add_child(card)
			Ingredient.Category.CREAM:
				cream_cards.add_child(card)
			Ingredient.Category.TOPPING:
				topping_cards.add_child(card)

func _on_ingredient_added(category: Ingredient.Category):
	# Блокируем все карточки данной категории
	var container = _get_container_for(category)
	for card in container.get_children():
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.modulate = Color(0.5, 0.5, 0.5, 0.5)

func _on_dessert_ready(result: DessertResult):
	var dessert_scene = preload("res://scenes/dessert_item.tscn")
	var item: DessertItem = dessert_scene.instantiate()
	item.setup(result)
	tray.add_child(item)

func _on_cauldron_cleared():
	# Разблокируем все карточки для следующего приготовления
	for container in [base_cards, cream_cards, topping_cards]:
		for card in container.get_children():
			card.mouse_filter = Control.MOUSE_FILTER_STOP
			card.modulate = Color.WHITE


func _on_guest_served(correct: bool, payment: int):
	if correct:
		money += payment
		money_label.text = " %d" % money
		# Эффект: деньги летят в кассу
	else:
		# Эффект: гость уходит недовольный
		pass
		
func _get_container_for(category: Ingredient.Category) -> Control:
	match category:
		Ingredient.Category.BASE:
			return base_cards
		Ingredient.Category.CREAM:
			return cream_cards
		Ingredient.Category.TOPPING:
			return topping_cards
		_:
			push_error("Неизвестная категория: " + str(category))
			return null
