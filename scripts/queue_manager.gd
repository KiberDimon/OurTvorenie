# QueueManager.gd
class_name QueueManager
extends Control

@export var guest_pool: GuestPool 
@export var slot_container: Control
@export var guest_scene: PackedScene  # guest.tscn

var _slots: Array[GuestSlot] = []
var _max_slots: int = 3

signal guest_served(correct: bool, payment: int)

func _ready():
	_spawn_initial_guests()

func _spawn_initial_guests():
	for i in range(_max_slots):
		var slot = preload("res://scenes/guest_slot.tscn").instantiate()
		slot_container.add_child(slot)
		_slots.append(slot)
		slot.queue_manager = self
		_fill_slot(slot)

func _fill_slot(slot: GuestSlot):
	var guest_data = guest_pool.get_random_guest()
	var dessert = guest_pool.get_random_dessert()
	if guest_data and dessert:
		slot.setup(guest_data, dessert)

func _on_guest_served(slot: GuestSlot, served_dessert: DessertResult):
	var correct = slot.ordered_dessert == served_dessert
	var payment = served_dessert.price if correct else 0  # если добавишь цену в DessertResult
	
	guest_served.emit(correct, payment)
	
	# Удаляем обслуженный слот (гость уходит)
	var index = _slots.find(slot)
	if index != -1:
		slot.queue_free()
		_slots.remove_at(index)
	
	# Сдвигаем оставшиеся слоты визуально (если нужно)
	# HBoxContainer сделает это автоматически при удалении
	
	# Добавляем нового гостя в конец очереди
	var new_slot = preload("res://scenes/guest_slot.tscn").instantiate()
	slot_container.add_child(new_slot)
	_slots.append(new_slot)
	new_slot.queue_manager = self
	_fill_slot(new_slot)
