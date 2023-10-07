#Written:
#Date: 10/01/2023
#Author: Sven Ogorek


@tool
extends EditorPlugin

const POPUP_BUTTON_TEXT = "Select Screen"
const MENU_BUTTON_TOOLTIP = "Switch between Screens"

const SCREENS_LIST: Array = ["Same as Editor", "Previous Screen", "Next Screen", "Primary Screen", "Screen 1", "Screen 2"]
const SCREENS_IDS: Array = [-5, -4, -3, -2, 0, 1]

var _plugin_menu_btn = MenuButton.new()
var _plugins_menu = _plugin_menu_btn.get_popup()


func _enter_tree():
	_plugin_menu_btn.text = POPUP_BUTTON_TEXT
	_plugin_menu_btn.tooltip_text = MENU_BUTTON_TOOLTIP
	
	_populate_menu()
	
	_plugin_menu_btn.about_to_popup.connect(_refresh_plugins_menu_list)
	_plugins_menu.index_pressed.connect(_item_selected.bind(_plugins_menu))
	
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, _plugin_menu_btn)


func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, _plugin_menu_btn)

	if _plugin_menu_btn:
		_plugin_menu_btn.queue_free()


func _item_selected(item_index, menuObj):
	get_editor_interface().get_editor_settings().set_setting("run/window_placement/screen", SCREENS_IDS[item_index])


func _refresh_plugins_menu_list():
	_plugins_menu.clear()
	_populate_menu()


func _populate_menu():      
	var screen_selected = get_editor_interface().get_editor_settings().get_setting("run/window_placement/screen")
	var index = SCREENS_IDS.find(screen_selected,0)
		
	for item in SCREENS_LIST:
		_plugins_menu.add_radio_check_item(item)
		
	_plugins_menu.set_item_checked(index, true)
	
