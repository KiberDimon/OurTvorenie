# GuestSlot.gd
class_name GuestSlot
extends Control

signal appearance_finished
signal disappearance_finished

var queue_manager: QueueManager
var ordered_dessert: DessertResult
var guest_data: GuestData
var is_interactable: bool = false

@onready var portrait: TextureRect = $Portrait
@onready var order_icon: TextureRect = $OrderIcon
@onready var order_name: Label = $OrderName
@onready var guest_name: Label = $GuestName

func _ready():
	# Начальное состояние — прозрачный и неактивный
	modulate = Color(1, 1, 1, 0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func setup(guest: GuestData, dessert: DessertResult):
	guest_data = guest
	ordered_dessert = dessert
	
	portrait.texture = guest.texture
	order_icon.texture = dessert.texture
	order_name.text = dessert.display_name
	guest_name.text = guest.display_name

func appear(duration: float = 0.5):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate:a", 1.0, duration)
	tween.tween_callback(_on_appearance_finished)

func disappear(duration: float = 0.5):
	is_interactable = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate:a", 0.0, duration)
	tween.tween_callback(_on_disappearance_finished)

func _on_appearance_finished():
	is_interactable = true
	mouse_filter = Control.MOUSE_FILTER_STOP  # или MOUSE_FILTER_PASS, зависит от структуры
	appearance_finished.emit()

func _on_disappearance_finished():
	disappearance_finished.emit()
	queue_free()

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not is_interactable:
		return false
	return data.has("dessert_item")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if not is_interactable:
		return
	
	var item: DessertItem = data["dessert_item"]
	var correct = ordered_dessert == item.dessert_result
	
	# Удаляем DessertItem с подноса
	if item.get_parent():
		item.get_parent().remove_child(item)
	item.queue_free()
	
	# Запускаем анимацию ухода, QueueManager получит сигнал по завершении
	queue_manager._on_guest_served(self, correct)
