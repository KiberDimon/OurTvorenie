extends Node

# Константы с именами шин — чтобы не ошибиться в строках
const BUS_MASTER := "Master"
const BUS_MUSIC  := "Music"
const BUS_SFX    := "SFX"
const BUS_UI     := "UI"

# Плееры, которые живут постоянно
var _music_player: AudioStreamPlayer
var _ui_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []

# Настройки громкости по умолчанию (0.0 — тихо, 1.0 — максимум)
var music_volume: float = 0.8
var sfx_volume:   float = 1.0
var ui_volume:    float = 1.0


func _ready() -> void:
	_create_music_player()
	_create_ui_player()
	_apply_all_volumes()
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
# --- Громкость ---

func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	_set_bus_volume(BUS_MUSIC, music_volume)


func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 1.0)
	_set_bus_volume(BUS_SFX, sfx_volume)


func set_ui_volume(value: float) -> void:
	ui_volume = clampf(value, 0.0, 1.0)
	_set_bus_volume(BUS_UI, ui_volume)


func _set_bus_volume(bus_name: String, linear_value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("AudioManager: шина '%s' не найдена" % bus_name)
		return
	# Преобразуем линейное значение в децибелы
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))


func _apply_all_volumes() -> void:
	_set_bus_volume(BUS_MUSIC, music_volume)
	_set_bus_volume(BUS_SFX, sfx_volume)
	_set_bus_volume(BUS_UI, ui_volume)
