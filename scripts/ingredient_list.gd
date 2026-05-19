extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_eye_topping_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/ГЛАЗА.mp3"))


func _on_worm_topping_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/черви.mp3"))


func _on_fly_topping_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/муха.mp3"))


func _on_mud_cream_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/ложки.mp3"))


func _on_blood_cream_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/ложки.mp3"))


func _on_mold_cream_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/ложки.mp3"))


func _on_muffin_base_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/ХЛЕБ.mp3"))


func _on_cocktail_base_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/стакан.mp3"))


func _on_cornet_base_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/ХЛЕБ.mp3"))


func _on_waffle_base_mouse_entered() -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/ХЛЕБ.mp3"))


func _on_cauldron_ingredient_added(category: Ingredient.Category) -> void:
	AudioManager.play_ui(preload("res://audio/audio_assets/ui/бульк .mp3"))
