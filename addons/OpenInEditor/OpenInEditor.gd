@tool
class_name OpenInEditor extends EditorPlugin

const POPUP_MENU_ID          := 5164
const NODE_PATH_CONTEXT_MENU := "@PopupMenu@5811"

var file_system_dock_context_menu: PopupMenu

func _enter_tree() -> void:

	var file_system_dock := EditorInterface.get_file_system_dock();

	if !is_instance_valid(file_system_dock_context_menu):

		file_system_dock_context_menu = file_system_dock.get_node(NODE_PATH_CONTEXT_MENU)

		if !is_instance_valid(file_system_dock_context_menu):
			return

	file_system_dock_context_menu.about_to_popup.connect(popup_menu_about_to_pop_up)
	file_system_dock_context_menu.id_pressed.connect(popup_menu_id_pressed)


func _exit_tree() -> void:

	if is_instance_valid(file_system_dock_context_menu):

		file_system_dock_context_menu.about_to_popup.disconnect(popup_menu_about_to_pop_up)
		file_system_dock_context_menu.id_pressed.disconnect(popup_menu_id_pressed)

	file_system_dock_context_menu = null


func popup_menu_about_to_pop_up() -> void:

	var registered_item_index := file_system_dock_context_menu.get_item_index(POPUP_MENU_ID)

	if registered_item_index != -1:
		file_system_dock_context_menu.remove_item(registered_item_index)

	var editor_theme := EditorInterface.get_editor_theme()
	var open_in_icon := editor_theme.get_icon("CodeEdit", "EditorIcons")

	file_system_dock_context_menu.add_icon_item(
		open_in_icon,
		"Open in external editor",
		POPUP_MENU_ID
	)


func popup_menu_id_pressed(id: int) -> void:

	if id != POPUP_MENU_ID:
		return

	var external_editor_path: String = EditorInterface\
		.get_editor_settings()\
		.get_setting("text_editor/external/exec_path")

	if external_editor_path == null:
		print(
			"[OpenInEditor] Please ensure setting text_editor/external/exec_path \
			is set to the path of your editor in Editor settings."
		)
		return

	var selected_paths: PackedStringArray = EditorInterface.get_selected_paths()

	if selected_paths.is_empty():
		return

	for path_i in range(selected_paths.size()):
		selected_paths[path_i] = ProjectSettings.globalize_path(selected_paths[path_i])

	OS.execute(external_editor_path, selected_paths)
