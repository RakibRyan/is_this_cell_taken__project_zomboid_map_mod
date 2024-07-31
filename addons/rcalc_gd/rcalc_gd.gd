@tool
extends EditorPlugin

const RENDERER := preload("res://addons/rcalc_gd/src/rcalc_renderer.tscn")

const LABELS := [
	preload("res://addons/rcalc_gd/assets/rcalc_label_small.tres"),
	preload("res://addons/rcalc_gd/assets/rcalc_label_medium.tres"),
	preload("res://addons/rcalc_gd/assets/rcalc_label_large.tres"),
]

var renderer: Control
var tabs: TabContainer


func _enter_tree() -> void:
	var dpi_scale := 1.0
	if EditorInterface.has_method("get_editor_scale"):
		dpi_scale = EditorInterface.get_editor_scale()
	else:
		dpi_scale = DisplayServer.screen_get_scale()
		
	var labels := LABELS.map(func (label: LabelSettings) -> LabelSettings:
		label = label.duplicate()
		label.font_size *= dpi_scale
		return label)
		
	var settings = EditorInterface.get_editor_settings()
	if !settings.has_setting("addons/rcalc/precision"):
		settings.set("addons/rcalc/precision", 8)
	settings.set_initial_value("addons/rcalc/precision", 8, false)
	settings.add_property_info({
		"name": "addons/rcalc/precision",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,17"
	})
	
	if !settings.has_setting("addons/rcalc/log_verbosity"):
		settings.set("addons/rcalc/log_verbosity", 2)
	settings.set_initial_value("addons/rcalc/log_verbosity", 2, false)
	settings.add_property_info({
		"name": "addons/rcalc/log_verbosity",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Verbose,Normal,Errors only"
	})
	
	update_settings()
	settings.settings_changed.connect(update_settings)
	
	renderer = RENDERER.instantiate()
	renderer.set_labels(Array(labels, TYPE_OBJECT, "LabelSettings", null))
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, renderer)
	
	tabs = renderer.get_parent() as TabContainer
	tabs.tab_changed.connect(_on_tabs_changed)


func _exit_tree() -> void:
	tabs.tab_changed.disconnect(_on_tabs_changed)
	remove_control_from_docks(renderer)
	renderer.queue_free()
	renderer = null


func _on_tabs_changed(index: int) -> void:
	if tabs.get_child(index) == renderer:
		renderer.activate()


func update_settings() -> void:
	var settings = EditorInterface.get_editor_settings()
	RCalcEngine.global_set_precision(settings.get_setting("addons/rcalc/precision") as int)
	RCalcEngine.global_set_verbosity(settings.get_setting("addons/rcalc/log_verbosity") as int)
