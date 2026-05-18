extends TextureRect # или TextureRect

func _ready():
	# 1. Намертво скрываем стандартный системный курсор
	# Теперь ОС не будет рисовать свою маленькую мышь
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	# 2. Привязываем позицию нашего спрайта к координатам мыши на игровом холсте
	# Функция get_local_mouse_position() берет координаты ВНУТРИ разрешения 430x270,
	# поэтому этот спрайт растянется ровно во столько же раз, во сколько и вся игра!
	global_position = get_viewport().get_mouse_position()
