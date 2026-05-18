extends Node

# Константы с именами шин — чтобы не ошибиться в строках
const BUS_MASTER := "Master"
const BUS_MUSIC  := "Music"
const BUS_SFX    := "SFX"
const BUS_UI     := "UI"
const BUS_COULDRON := "COULDRON"

# Плееры, которые живут постоянно
var _music_player: AudioStreamPlayer
var _ui_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _named_players: Dictionary = {} 




func _ready() -> void:
	_create_music_player()
	_create_ui_player()


# --- Музыка ---
func play_music(stream: AudioStream) -> void:
	if _music_player.stream == stream and _music_player.playing:
		return  # Этот трек уже играет
	
	_music_player.stream = stream
	_music_player.play()


func stop_music() -> void:
	_music_player.stop()


# --- UI-звуки (кнопки, переключатели) ---

func play_ui(stream: AudioStream) -> void:
	_ui_player.stream = stream
	_ui_player.play()


# --- Звуковые эффекты (могут накладываться) ---

func play_sfx(stream: AudioStream) -> void:
	# Ищем свободный плеер в пуле
	var free_player := _find_free_sfx_player()
	if free_player == null:
		free_player = _create_sfx_player()
	
	free_player.stream = stream
	free_player.play()
	


func _find_free_sfx_player() -> AudioStreamPlayer:
	for player in _sfx_players:
		if not player.playing:
			return player
	return null


func _create_sfx_player() -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.bus = BUS_SFX
	player.finished.connect(_on_sfx_finished.bind(player))
	add_child(player)
	_sfx_players.append(player)
	return player


func _on_sfx_finished(player: AudioStreamPlayer) -> void:
	# Просто освобождаем плеер для переиспользования, не удаляем
	player.stream = null

func _create_music_player() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = BUS_MUSIC
	add_child(_music_player)


func _create_ui_player() -> void:
	_ui_player = AudioStreamPlayer.new()
	_ui_player.bus = BUS_UI
	add_child(_ui_player)


func _set_bus_volume(bus_name: String, linear_value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("AudioManager: шина '%s' не найдена" % bus_name)
		return
	# Преобразуем линейное значение в децибелы
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))




# --- Именованные SFX (только один звук на имя) ---

func register_named_player(name: String) -> void:
	#"""Создаёт плеер, к которому можно обращаться по имени."""
	if _named_players.has(name):
		return  # Уже зарегистрирован
	
	var player := AudioStreamPlayer.new()
	player.bus = BUS_SFX
	add_child(player)
	_named_players[name] = player


func play_named(name: String, stream: AudioStream) -> void:
	#"""Проигрывает звук на именованном плеере. Предыдущий звук останавливается."""
	if not _named_players.has(name):
		push_error("AudioManager: именованный плеер '%s' не зарегистрирован" % name)
		return
	
	var player: AudioStreamPlayer = _named_players[name]
	player.stream = stream
	player.play()


func stop_named(name: String) -> void:
	#"""Останавливает именованный плеер."""
	if _named_players.has(name):
		_named_players[name].stop()
