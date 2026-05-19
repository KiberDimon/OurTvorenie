extends Button

var _spider_high_y: float
var _spider_low_y: float
var spider_high: bool = false  # true = паук наверху (кнопка поднята)

func _ready() -> void:
	# Позиция "опущена" (нормальная)
	_spider_high_y = position.y
	
	# Позиция "поднята" — на 50 пикселей выше
	_spider_low_y = _spider_high_y + 50
	
	# Начинаем в опущенном состоянии
	position.y = _spider_high_y

func spider_up(duration: float = 0.3):
	if spider_high:
		return
	spider_high = true
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/паук уехал.mp3"))
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", _spider_low_y, duration)

func spider_down(duration: float = 0.3):
	if not spider_high:
		return
	spider_high = false
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/паук приехал.mp3"))
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", _spider_high_y, duration)
