@tool
extends PanelContainer


const DISCLOSURE_LIST := preload("res://addons/rcalc_gd/src/rcalc_disclosure_list.tscn")
const LICENSE_INFO := preload("res://addons/rcalc_gd/src/rcalc_license_info.tscn")

@export var labels: Array[LabelSettings]

var engine: RCalcEngine
var empty_style := StyleBoxEmpty.new()
var dpi_scale := 1.0

@onready var margin_container: MarginContainer = %MarginContainer as MarginContainer
@onready var help_vbox: VBoxContainer = %HelpVBox as VBoxContainer
@onready var vbox_container: VBoxContainer = %VBoxContainer as VBoxContainer
@onready var hbox_container: HBoxContainer = %HBoxContainer as HBoxContainer
@onready var rcalc_label: Label = %RCalcLabel as Label
@onready var version_label: Label = %VersionLabel as Label
@onready var version_hash_label: Label = %VersionHashLabel as Label
@onready var program_info: Label = %ProgramInfo as Label


func _ready() -> void:
	if not is_instance_valid(engine):
		return
	
	if EditorInterface.has_method("get_editor_scale"):
		dpi_scale = EditorInterface.get_editor_scale()
	else:
		dpi_scale = DisplayServer.screen_get_scale()
	
	rcalc_label.label_settings = labels[2]
	version_label.label_settings = labels[0]
	version_hash_label.label_settings = labels[0]
	program_info.label_settings = labels[0]
	
	help_vbox.add_theme_constant_override("separation", 24 * dpi_scale)
	vbox_container.add_theme_constant_override("separation", 24 * dpi_scale)
	
	margin_container.add_theme_constant_override("margin_bottom", 16 * dpi_scale)
	margin_container.add_theme_constant_override("margin_top", 16 * dpi_scale)
	margin_container.add_theme_constant_override("margin_left", 16 * dpi_scale)
	margin_container.add_theme_constant_override("margin_right", 16 * dpi_scale)
	
	hbox_container.add_theme_constant_override("separation", 8 * dpi_scale)
	
	(get_theme_stylebox("panel") as StyleBoxFlat).bg_color = (get_theme_stylebox("normal", "LineEdit") as StyleBoxFlat).bg_color
	
	version_label.text = "v%s" % RCalcEngine.get_version_string()
	version_hash_label.text = "(%s)" % RCalcEngine.get_version_hash().substr(0, 6)
	version_hash_label.tooltip_text = "Click to copy: %s" % RCalcEngine.get_version_hash()
	program_info.text = RCalcEngine.get_program_info()
	
	for section in RCalcHelpSection.get_help_sections():
		help_vbox.add_child(make_help_section(section))
	
	help_vbox.add_child(HSeparator.new())
	
	var commands_vbox := VBoxContainer.new()
	commands_vbox.add_theme_constant_override("separation", 8 * dpi_scale)
	commands_vbox.add_child(make_label("Commands", labels[2]))
	for command in engine.get_help_commands():
		commands_vbox.add_child(make_help_command(command))
	
	help_vbox.add_child(commands_vbox)
	help_vbox.add_child(HSeparator.new())
	
	for category in RCalcHelpOperatorCategory.get_help_operator_categories():
		help_vbox.add_child(make_help_op_category(category))
		help_vbox.add_child(HSeparator.new())
	
	var units_vbox := VBoxContainer.new()
	units_vbox.add_theme_constant_override("separation", 8 * dpi_scale)
	units_vbox.add_child(make_label("Unit Families", labels[2]))
	
	for family in RCalcHelpUnitFamily.get_help_unit_families():
		units_vbox.add_child(make_help_family(family))
	
	help_vbox.add_child(units_vbox)
	help_vbox.add_child(HSeparator.new())
	
	help_vbox.add_child(make_label("Licenses", labels[2]))
	
	var licenses := LICENSE_INFO.instantiate()
	licenses.set_label(labels[0])
	help_vbox.add_child(licenses)


func set_labels(new_labels: Array[LabelSettings]) -> void:
	labels = new_labels


func make_help_section(section: RCalcHelpSection) -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12 * dpi_scale)
	
	vbox.add_child(make_label(section.get_header(), labels[1], true))
	vbox.add_child(make_label(section.get_text(), labels[0], true))
	
	return vbox


func make_help_command(command: RCalcHelpCommand) -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 0)
	
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 8 * dpi_scale)
	hbox.add_child(make_label(command.get_name(), labels[0], false, Color(0.412, 0.655, 1.0, 1.0)))
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var aliases := command.get_aliases()
	if aliases.size() == 1:
		hbox.add_child(make_label("alias: \\%s" % aliases[0], labels[0], false, Color(0.8, 0.8, 0.8, 1.0)))
	elif aliases.size() > 1:
		hbox.add_child(make_label("aliases: [%s]" % ", ".join(aliases.map(func (a) -> String: return "\\%s" % a)), labels[0], false, Color(0.8, 0.8, 0.8, 1.0)))
	
	vbox.add_child(hbox)
	vbox.add_child(make_label(command.get_description()))
	
	return vbox


func make_help_op_category(category: RCalcHelpOperatorCategory) -> VBoxContainer:
	var category_vbox := VBoxContainer.new()
	category_vbox.add_theme_constant_override("separation", 8 * dpi_scale)
	
	if category.get_name().is_empty():
		category_vbox.add_child(make_label("Operators", labels[2]))
	else:
		category_vbox.add_child(make_label("%s Operators" % category.get_name(), labels[2]))
	
	for op in category.get_operators():
		category_vbox.add_child(make_help_op(op))
	
	return category_vbox


func make_help_op(op: RCalcHelpOperator) -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2 * dpi_scale)
	
	vbox.add_child(make_label(op.get_name(), labels[0], false, Color(0.439, 1.0, 0.388, 1.0)))
	vbox.add_child(make_label(op.get_description(), labels[0], true))
	
	if op.get_param_count() > 0:
		var args_list: VBoxContainer = DISCLOSURE_LIST.instantiate()
		args_list.label_text = "Accepts %d %s" % [op.get_param_count(), "argument" if op.get_param_count() == 1 else "arguments"]
		args_list.font_size = labels[0].font_size
		
		var argVBox := VBoxContainer.new()
		for typeset: Array[String] in op.get_allowed_types():
			if argVBox.get_child_count() == 0:
				argVBox.add_child(make_label(", ".join(typeset)))
			else:
				argVBox.add_child(make_label("or %s" % ", ".join(typeset)))
		
		args_list.add_content(argVBox)
		
		vbox.add_child(args_list)
	
	if op.has_examples():
		var examples_list: VBoxContainer = DISCLOSURE_LIST.instantiate()
		examples_list.label_text = "Examples"
		examples_list.get_content = make_op_examples.bind(op)
		examples_list.font_size = labels[0].font_size
		
		vbox.add_child(examples_list)
	
	return vbox

func make_op_examples(op: RCalcHelpOperator) -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	for example in op.get_examples():
		vbox.add_child(build_stack_item_view(example))
	
	return vbox


func make_help_family(family: RCalcHelpUnitFamily) -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2 * dpi_scale)
	
	vbox.add_child(make_label(family.get_name(), labels[0], false, Color(1.0, 0.909, 0.388, 1.0)))
	vbox.add_child(make_label("Base type: %s" % family.get_base_type(), labels[0], true))
	
	var units_list: VBoxContainer = DISCLOSURE_LIST.instantiate()
	units_list.label_text = "Units"
	units_list.font_size = labels[0].font_size
	
	var units_vbox := VBoxContainer.new()
	
	for unit in family.get_units():
		var hbox := HBoxContainer.new()
		
		hbox.add_child(make_label("-", labels[0], false, Color(0.8, 0.8, 0.8, 1.0)))
		hbox.add_child(make_label(unit.get_name()))
		hbox.add_child(make_label("(Usage: %s)" % unit.get_usage(), labels[0], false, Color(0.8, 0.8, 0.8, 1.0)))
		
		units_vbox.add_child(hbox)
	
	units_list.add_content(units_vbox)
	vbox.add_child(units_list)
	
	return vbox


func build_stack_item_view(item: RCalcStackItem) -> RCalcNewlineFlowContainer:
	var container := RCalcNewlineFlowContainer.new()
	container.add_to_group("RCalcStackItemView")
	
	container.add_theme_constant_override("h_separation", 0)
	container.h_separation = 0
	
	for input: String in item.inputs:
		container.add_child(build_stack_item_label(input))
	
	container.add_child(build_stack_item_label(" -> "))
	container.add_child(build_stack_item_label(item.output))
	
	return container


func build_stack_item_label(value: String) -> Label:
	var label := Label.new()
	label.label_settings = labels[0]
	label.add_theme_stylebox_override("normal", empty_style)
	label.text = value
	return label


func make_label(text: String, label_settings: LabelSettings = labels[0], autowrap: bool = false, color: Color = Color.WHITE) -> Label:
	var label := Label.new()
	
	label.text = text
	if autowrap:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.custom_minimum_size = Vector2(1, 1)
	label.label_settings = label_settings
	label.modulate = color
	label.add_theme_stylebox_override("normal", empty_style)
	
	return label


func _on_version_hash_label_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	var mouse_event := event as InputEventMouseButton
	
	if not mouse_event.pressed:
		return
	
	if mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	DisplayServer.clipboard_set(RCalcEngine.get_version_hash())
