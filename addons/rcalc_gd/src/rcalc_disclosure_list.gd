@tool
extends VBoxContainer


var label_text: String
var get_content: Callable
var font_size: int

@onready var button: Button = %Button
@onready var hbox: HBoxContainer = %HBoxContainer


func _ready() -> void:
	button.text = label_text
	button.icon = get_theme_icon("folded", "CodeEdit")
	button.add_theme_font_size_override("font_size", font_size)
	
	var dpi_scale := 1.0
	if EditorInterface.has_method("get_editor_scale"):
		dpi_scale = EditorInterface.get_editor_scale()
	else:
		dpi_scale = DisplayServer.screen_get_scale()
	add_theme_constant_override("separation", 2 * dpi_scale)


func add_content(content: Control) -> void:
	await ready
	hbox.add_child(content)


func _on_button_pressed() -> void:
	if hbox.get_child_count() == 1:
		if get_content.is_valid():
			hbox.add_child(get_content.call())
	
	if hbox.get_child_count() == 1:
		return
	
	hbox.visible = !hbox.visible
	if hbox.visible:
		button.icon = get_theme_icon("can_fold", "CodeEdit")
	else:
		button.icon = get_theme_icon("folded", "CodeEdit")
