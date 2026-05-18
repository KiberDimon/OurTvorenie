# Tray.gd (или скрипт твоего контейнера-подноса)
class_name Tray
extends Control

var _float_tween: Tween = null
var _original_position: Vector2
var _is_floating: bool = false

func _ready():
	_original_position = position

func _process(delta: float) -> void:
	if _is_floating == false:
		visible = false
	else:
		visible = true

func start_floating():
	if _is_floating:
		return
	_is_floating = true
	
	# Лёгкий подъём
	var rise_tween = create_tween()
	rise_tween.set_ease(Tween.EASE_OUT)
	rise_tween.tween_property(self, "position:y", _original_position.y - 15, 0.3)
	
	# После подъёма — бесконечное покачивание
	rise_tween.tween_callback(_begin_levitation)

func _begin_levitation():
	_float_tween = create_tween().set_loops()
	_float_tween.set_ease(Tween.EASE_IN_OUT)
	_float_tween.set_trans(Tween.TRANS_SINE)
	_float_tween.tween_property(self, "position:y", position.y - 8, 0.7)
	_float_tween.tween_property(self, "position:y", position.y + 8, 0.7)

func stop_floating():
	if not _is_floating:
		return
	_is_floating = false
	
	if _float_tween:
		_float_tween.kill()
		_float_tween = null
	
	# Плавный возврат на место
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", _original_position.y, 0.3)

func add_dessert(item: DessertItem):
	# Запускаем эффект!
	start_floating()

func remove_dessert(item: DessertItem):
	remove_child(item)

	
	# Если поднос опустел — убираем левитацию
	if get_child_count() == 0:
		stop_floating()
