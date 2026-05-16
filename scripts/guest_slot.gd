# GuestSlot.gd
class_name GuestSlot
extends Control

var queue_manager: QueueManager
var ordered_dessert: DessertResult
var guest_data: GuestData

@onready var portrait: TextureRect = $Portrait
@onready var order_icon: TextureRect = $OrderIcon
@onready var order_name: Label = $OrderName
@onready var guest_name: Label = $GuestName

func setup(guest: GuestData, dessert: DessertResult):
	guest_data = guest
	ordered_dessert = dessert
	portrait.texture = guest.texture
	order_icon.texture = dessert.texture
	order_name.text = dessert.display_name
	guest_name.text = guest.display_name

# Этот метод вызывается, когда на GuestSlot перетаскивают DessertItem
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.has("dessert_item")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var item: DessertItem = data["dessert_item"]
	
	# Проверяем, тот ли десерт
	var correct = ordered_dessert == item.dessert_result
	
	# Сообщаем менеджеру
	queue_manager._on_guest_served(self, item.dessert_result)
	
	# Удаляем DessertItem с подноса
	if item.get_parent():
		item.get_parent().remove_child(item)
	item.queue_free()
