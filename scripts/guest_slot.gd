# GuestSlot.gd
class_name GuestSlot
extends Control

signal appearance_finished
signal disappearance_finished

var queue_manager: QueueManager
var ordered_dessert: DessertResult
var guest_data: GuestData
var is_interactable: bool = false
var order_visible: bool = false

@onready var order_card: Control = $OrderCard
@onready var order_icon: TextureRect = $OrderCard/OrderIcon
@onready var order_label: Label = $OrderCard/OrderLabel
@onready var guest_name: Label = $GuestName
@onready var portrait: TextureRect = $Portrait

var _order_visible_y: float
var _order_hidden_y: float


func _ready():
	modulate = Color(1, 1, 1, 0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Позиция "показано"
	_order_visible_y = order_card.position.y
	
	# Позиция "спрятано" — над верхним краем
	_order_hidden_y = -order_card.size.y - 35
	
	# Сразу прячем
	order_card.position.y = _order_hidden_y


func setup(guest: GuestData, dessert: DessertResult):
	guest_data = guest
	ordered_dessert = dessert
	portrait.texture = guest.texture
	order_icon.texture = dessert.texture
	order_label.text = dessert.display_name
	guest_name.text = guest.display_name
	order_icon.tooltip_text = dessert.display_name

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

func show_order(duration: float = 0.3):
	if order_visible:
		return
	order_visible = true
	
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(order_card, "position:y", _order_visible_y, duration)
	

func hide_order(duration: float = 0.3):
	if not order_visible:
		return
	order_visible = false
	
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(order_card, "position:y", _order_hidden_y, duration)
	

func _on_appearance_finished():
	is_interactable = true
	mouse_filter = Control.MOUSE_FILTER_STOP
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
	
	hide_order(0.2)
	
	var item: DessertItem = data["dessert_item"]
	if item.get_parent() and item.get_parent() is Tray:
		item.get_parent().remove_dessert(item)
	
	item.queue_free()
	
	var correct = ordered_dessert == item.dessert_result
	queue_manager._on_guest_served(self, correct)
