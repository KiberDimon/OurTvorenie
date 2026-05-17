# QueueManager.gd
class_name QueueManager
extends Control

@export var guest_pool: GuestPool
@export var slot_container: Control  # HBoxContainer
@export var max_slots: int = 3
@export var appear_duration: float = 0.8
@export var disappear_duration: float = 0.8

signal guest_served(correct: bool, payment: int)

var _slots: Array[GuestSlot] = []
var _is_animating: bool = false  # блокирует создание новых гостей во время анимации

func _ready():
	_spawn_initial_guests()

func _spawn_initial_guests():
	for i in range(max_slots):
		var slot = _create_slot()
		slot.appear(0.8)  # первый гость появляется мгновенно
		slot._on_appearance_finished()  # мгновенное завершение, без анимации

func _create_slot() -> GuestSlot:
	var slot = preload("res://scenes/guest_slot.tscn").instantiate()
	slot_container.add_child(slot)
	_slots.append(slot)
	slot.queue_manager = self
	slot.appearance_finished.connect(_on_slot_appeared.bind(slot))
	slot.disappearance_finished.connect(_on_slot_disappeared.bind(slot))
	
	var guest_data = guest_pool.get_random_guest()
	var dessert = guest_pool.get_random_dessert()
	slot.setup(guest_data, dessert)
	
	return slot

func _fill_new_slot():
	if _slots.size() >= max_slots:
		return
	var slot = _create_slot()
	slot.appear(appear_duration)

func _on_slot_appeared(slot: GuestSlot):
	# Можно добавить логику, например, звук появления
	pass

func _on_slot_disappeared(slot: GuestSlot):
	var index = _slots.find(slot)
	if index != -1:
		_slots.remove_at(index)
	
	# После исчезновения создаём нового гостя в конец очереди
	_fill_new_slot()
	_is_animating = false

func _on_guest_served(slot: GuestSlot, correct: bool):
	if _is_animating:
		return  # защита от двойного клика
	_is_animating = true
	
	var payment = slot.ordered_dessert.price if correct else 0
	guest_served.emit(correct, payment)
	
	# Запускаем анимацию ухода гостя
	slot.disappear(disappear_duration)

func show_all_orders():
	for slot in _slots:
		slot.show_order()

func hide_all_orders():
	for slot in _slots:
		slot.hide_order()
