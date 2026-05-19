extends AnimatedSprite2D

# Загружаем звуки заранее
const SFX_COLD   = preload("res://audio/audio_assets/sfx/спокойное кипение.mp3")
const SFX_MEDIUM = preload("res://audio/audio_assets/sfx/среднее кипение.mp3")
const SFX_HOT    = preload("res://audio/audio_assets/sfx/сильное кипение.mp3")

const NAMED_PLAYER := "cauldron"


func _ready():
	# Регистрируем плеер (безопасно вызывать много раз)
	#ЛЕХА ТУТ ЗВУК КОТЛА ВСЕХ ТРЕХ===================================================
	AudioManager.register_named_player(NAMED_PLAYER, -13.0)
	
	# При старте игры включаем средний огонь по умолчанию
	play("medium")
	AudioManager.play_named(NAMED_PLAYER, SFX_MEDIUM)


func change_fire_mode(base_name: String):
	match base_name:
		"cornet_base":
			play("cold")
			AudioManager.play_named(NAMED_PLAYER, SFX_COLD)
		
		"cocktail_base":
			play("medium")
			AudioManager.play_named(NAMED_PLAYER, SFX_MEDIUM)
		
		"waffle_base", "muffin_base":
			play("hot")
			AudioManager.play_named(NAMED_PLAYER, SFX_HOT)
