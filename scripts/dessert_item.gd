class_name DessertItem
extends Control

signal selected(dessert_item: DessertItem)

@export var dessert_result: DessertResult:
	set(value):
		dessert_result = value
		update_display()

@onready var icon: TextureRect = $Icon
@onready var name_label: Label = $NameLabel

func _ready():
	update_display()

func update_display():
	if dessert_result and icon:
		icon.texture = dessert_result.texture
	if dessert_result and name_label:
		name_label.text = dessert_result.display_name
	print(dessert_result)


func setup(result: DessertResult):
	dessert_result = result
	update_display()

# Drag and Drop
func _get_drag_data(at_position: Vector2) -> Variant:
	if not dessert_result:
		return null
	
	var preview = TextureRect.new()
	preview.texture = dessert_result.texture
	#preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#preview.custom_minimum_size = Vector2(80, 80)
	set_drag_preview(preview)
	
	# Возвращаем словарь с самим объектом DessertItem, 
	# чтобы гость мог удалить его с подноса после получения
	return { "dessert_item": self, "dessert_result": dessert_result }

# Опционально: подсветка при наведении мыши (необязательно, но удобно)
func _on_mouse_entered():
	modulate = Color(1.2, 1.2, 1.2, 1.0)
	
func _on_mouse_exited():
	modulate = Color.WHITE
