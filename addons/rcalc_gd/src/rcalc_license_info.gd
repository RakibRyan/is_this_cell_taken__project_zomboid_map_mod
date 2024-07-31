@tool
extends MarginContainer

@export var label_settings: LabelSettings

@onready var label: Label = %Label as Label
@onready var margin_container: MarginContainer = %MarginContainer as MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	label.label_settings = label_settings
	
	var dpi_scale := 1.0
	if EditorInterface.has_method("get_editor_scale"):
		dpi_scale = EditorInterface.get_editor_scale()
	else:
		dpi_scale = DisplayServer.screen_get_scale()
	
	add_theme_constant_override("margin_bottom", 16 * dpi_scale)
	add_theme_constant_override("margin_top", 16 * dpi_scale)
	add_theme_constant_override("margin_left", 16 * dpi_scale)
	add_theme_constant_override("margin_right", 16 * dpi_scale)
	
	margin_container.add_theme_constant_override("margin_bottom", 16 * dpi_scale)
	margin_container.add_theme_constant_override("margin_top", 16 * dpi_scale)
	margin_container.add_theme_constant_override("margin_left", 16 * dpi_scale)
	margin_container.add_theme_constant_override("margin_right", 16 * dpi_scale)
	
	custom_minimum_size = size
	custom_minimum_size.y *= dpi_scale


func set_label(new_label: LabelSettings) -> void:
	label_settings = new_label
