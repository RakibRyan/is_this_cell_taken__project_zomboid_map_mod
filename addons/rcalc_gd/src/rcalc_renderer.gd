@tool
extends Control


const OUTPUT_LABEL := preload("res://addons/rcalc_gd/src/rcalc_output_label.tscn")
const HELP := preload("res://addons/rcalc_gd/src/rcalc_help.tscn")

@export var error_color: Color
@export var labels: Array[LabelSettings]

var engine := RCalcEngine.new()
var bottom := Control.new()
var history: Array[String] = []
var history_index: int = 0
var history_active: bool = false
var copy_menu := PopupMenu.new()
var copy_item: RCalcStackItem
var empty_style := StyleBoxEmpty.new()
var dpi_scale := 1.0

@onready var vbox_container: VBoxContainer = %VBoxContainer as VBoxContainer
@onready var background_panel: PanelContainer = %BackgroundPanel as PanelContainer
@onready var scroll_container: ScrollContainer = %ScrollContainer as ScrollContainer
@onready var margin_container: MarginContainer = %MarginContainer as MarginContainer
@onready var stack_item_list: VBoxContainer = %StackItemList as VBoxContainer
@onready var message: Label = %Message as Label
@onready var scratchpad: LineEdit = %Scratchpad as LineEdit
@onready var help_window: Window = %HelpWindow as Window


func _ready() -> void:
	engine.display_info.connect(_on_display_info)
	engine.display_error.connect(_on_display_error)
	
	engine.add_stack_item.connect(_on_add_stack_item)
	engine.remove_stack_item.connect(_on_remove_stack_item)
	engine.replace_stack_items.connect(_on_replace_stack_items)
	
	(background_panel.get_theme_stylebox("panel") as StyleBoxFlat).bg_color = (get_theme_stylebox("normal", "LineEdit") as StyleBoxFlat).bg_color
	
	stack_item_list.add_child(bottom, false, Node.INTERNAL_MODE_BACK)
	
	copy_menu.add_item("Copy to Clipboard", 0)
	copy_menu.index_pressed.connect(_on_copy_menu_clicked)
	add_child(copy_menu)
	
	message.label_settings = labels[0]
	scratchpad.add_theme_font_size_override("font_size", (labels[0].font_size + labels[1].font_size) / 2.0)
	
	engine.bind_commands([
		RCalcHelpCommand.bind("Copy", "Copies the top element from the stack to the clipboard.", [], _on_command_copy),
		RCalcHelpCommand.bind("ClearHist", "Clears the history buffer.", [], _on_command_clearhist),
		RCalcHelpCommand.bind("Help", "Displays a help window.", [], _on_command_help)
	])
	
	if EditorInterface.has_method("get_editor_theme"):
		var copyIcon := EditorInterface.get_editor_theme().get_icon("ActionCopy", "EditorIcons")
		copy_menu.set_item_icon(0, copyIcon)
	
	if EditorInterface.has_method("get_editor_scale"):
		dpi_scale = EditorInterface.get_editor_scale()
	else:
		dpi_scale = DisplayServer.screen_get_scale()
	
	stack_item_list.add_theme_constant_override("separation", 16 * dpi_scale)
	vbox_container.add_theme_constant_override("separation", 8 * dpi_scale)
	
	add_theme_constant_override("margin_bottom", 8 * dpi_scale)
	add_theme_constant_override("margin_top", 8 * dpi_scale)
	add_theme_constant_override("margin_left", 8 * dpi_scale)
	add_theme_constant_override("margin_right", 8 * dpi_scale)
	
	margin_container.add_theme_constant_override("margin_bottom", 8 * dpi_scale)
	margin_container.add_theme_constant_override("margin_top", 8 * dpi_scale)
	margin_container.add_theme_constant_override("margin_left", 16 * dpi_scale)
	margin_container.add_theme_constant_override("margin_right", 16 * dpi_scale)
	
	help_window.size *= dpi_scale


func set_labels(new_labels: Array[LabelSettings]) -> void:
	labels = new_labels


func _on_display_info(info: String) -> void:
	message.text = info
	message.modulate = Color.WHITE
	message.visible = true
	
	scroll_to_bottom()


func _on_display_error(error: String) -> void:
	message.text = error
	message.modulate = error_color
	message.visible = true
	
	scroll_to_bottom()


func _on_add_stack_item(item: RCalcStackItem) -> void:
	var built := build_stack_item_view(item)
	stack_item_list.add_child(built)


func _on_remove_stack_item() -> void:
	if stack_item_list.get_child_count() == 0:
		return
	
	var child := stack_item_list.get_child(stack_item_list.get_child_count() - 1)
	stack_item_list.remove_child(child)
	child.queue_free()


func _on_replace_stack_items(items: Array[RCalcStackItem]) -> void:
	get_tree().call_group("RCalcStackItemView", "queue_free")
	
	for item in items:
		_on_add_stack_item(item)


func _on_scratchpad_text_submitted(new_text: String) -> void:
	message.visible = false
	engine.cancel_suggestion()
	
	if scratchpad.text == "":
		engine.submit_text("\\dup")
		return
	
	history.append(new_text)
	history_active = false
	
	engine.submit_text(new_text)
	scratchpad.text = ""
	scroll_to_bottom()

func _on_scratchpad_text_changed(new_text: String) -> void:
	engine.cancel_suggestion()

func build_stack_item_view(item: RCalcStackItem) -> RCalcNewlineFlowContainer:
	var container := RCalcNewlineFlowContainer.new()
	container.add_to_group("RCalcStackItemView")
	
	container.add_theme_constant_override("h_separation", 0)
	container.h_separation = 0
	container.v_separation = 4 * dpi_scale
	
	for input: String in item.inputs:
		container.add_child(build_stack_item_label(input))
	
	var output := HBoxContainer.new()
	output.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	output.alignment = BoxContainer.ALIGNMENT_END
	
	var label := build_stack_item_label(item.output, OUTPUT_LABEL.instantiate() as Label)
	label.connect("right_clicked", _on_output_right_clicked.bind(item))
	output.add_child(label)
	container.add_child(output)
	
	return container


func build_stack_item_label(value: String, label: Label = null) -> Label:
	if not is_instance_valid(label):
		label = Label.new()
	label.label_settings = message.label_settings
	label.add_theme_stylebox_override("normal", empty_style)
	label.text = value
	return label


func scroll_to_bottom() -> void:
	await get_tree().process_frame
	if stack_item_list.get_child_count() == 0:
		return
	
	scroll_container.get_v_scroll_bar().value = scroll_container.get_v_scroll_bar().max_value


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	
	if not scratchpad.has_focus():
		return
	
	var keyEvent := event as InputEventKey
	
	if not keyEvent.pressed:
		return
	
	if keyEvent.echo:
		return
	
	var noMods := not (keyEvent.ctrl_pressed or keyEvent.alt_pressed or keyEvent.shift_pressed or keyEvent.meta_pressed)
	
	if noMods:
		if keyEvent.keycode == KEY_DELETE:
			get_window().set_input_as_handled()
			engine.submit_text("\\pop")
			scroll_to_bottom()
		elif keyEvent.keycode == KEY_PLUS or keyEvent.keycode == KEY_KP_ADD:
			get_window().set_input_as_handled()
			_submit_operator("add")
		elif keyEvent.keycode == KEY_MINUS or keyEvent.keycode == KEY_KP_SUBTRACT:
			get_window().set_input_as_handled()
			_submit_operator("sub")
		elif keyEvent.keycode == KEY_KP_MULTIPLY:
			get_window().set_input_as_handled()
			_submit_operator("mul")
		elif keyEvent.keycode == KEY_SLASH or keyEvent.keycode == KEY_KP_DIVIDE:
			get_window().set_input_as_handled()
			_submit_operator("div")
		elif keyEvent.keycode == KEY_UP:
			get_window().set_input_as_handled()
			var next_index: int
			
			if history_active:
				next_index = history_index + 1
				if next_index > history.size():
					return
			elif not history.is_empty():
				next_index = 1
			else:
				return
			
			scratchpad.text = history[history.size() - next_index]
			scratchpad.caret_column = scratchpad.text.length()
			history_index = next_index
			history_active = true
		elif keyEvent.keycode == KEY_DOWN:
			get_window().set_input_as_handled()
			var next_index: int
			var next_index_active := true
			
			if history_active:
				next_index = history_index - 1
				if next_index == 0:
					next_index_active = false
				if next_index > history.size():
					next_index_active = false
			else:
				return
			
			if next_index_active:
				scratchpad.text = history[history.size() - next_index]
				scratchpad.caret_column = scratchpad.text.length()
			
			history_index = next_index
			history_active = next_index_active
		elif keyEvent.keycode == KEY_TAB:
			get_window().set_input_as_handled()
			if keyEvent.shift_pressed:
				if not engine.suggestions_active():
					engine.init_suggestions(scratchpad.text)
				
				var prev := engine.get_previous_suggestion()
				if prev.is_empty():
					return
				
				scratchpad.text = prev
				scratchpad.caret_column = prev.length()
			else:
				if not engine.suggestions_active():
					engine.init_suggestions(scratchpad.text)
				
				var next := engine.get_next_suggestion()
				if next.is_empty():
					return
				
				scratchpad.text = next
				scratchpad.caret_column = next.length()
	elif keyEvent.ctrl_pressed:
		if keyEvent.keycode == KEY_C:
			get_window().set_input_as_handled()
			if stack_item_list.get_child_count() == 0:
				return
			
			var item := stack_item_list.get_child(stack_item_list.get_child_count() - 1) as RCalcNewlineFlowContainer
			var output := item.get_child(item.get_child_count() - 1) as HBoxContainer
			var label := output.get_child(0) as Label
			
			DisplayServer.clipboard_set(label.text)
		elif keyEvent.keycode == KEY_D:
			get_window().set_input_as_handled()
			engine.submit_text("\\dup")
			message.visible = false
			scroll_to_bottom()
	elif keyEvent.shift_pressed:
		if keyEvent.keycode == KEY_8:
			get_window().set_input_as_handled()
			_submit_operator("mul")


func _submit_operator(op: String) -> void:
	if not scratchpad.text.is_empty():
		engine.submit_text(scratchpad.text)
	
	scratchpad.text = ""
	message.visible = false
	engine.submit_text(op)
	scroll_to_bottom()


func _on_output_right_clicked(screen_position: Vector2, item: RCalcStackItem) -> void:
	copy_item = item
	copy_menu.reset_size()
	copy_menu.set_position(screen_position)
	copy_menu.popup()


func _on_copy_menu_clicked(_index: int) -> void:
	DisplayServer.clipboard_set(copy_item.output)


func _on_command_copy() -> void:
	if stack_item_list.get_child_count() == 0:
		return
	
	var stackItem: RCalcNewlineFlowContainer = stack_item_list.get_child(stack_item_list.get_child_count() - 1)
	var output: HBoxContainer = stackItem.get_child(stackItem.get_child_count() - 1)
	var label: Label = output.get_child(0)
	DisplayServer.clipboard_set(label.text)


func _on_command_clearhist() -> void:
	history.clear()
	history_active = false


func _on_command_help() -> void:
	var help := HELP.instantiate()
	help.engine = engine
	help.set_labels(labels)
	help_window.add_child(help)
	help_window.show()


func _on_help_window_close_requested() -> void:
	help_window.hide()
	for child in help_window.get_children():
		child.queue_free()

func activate() -> void:
	scratchpad.grab_focus()
