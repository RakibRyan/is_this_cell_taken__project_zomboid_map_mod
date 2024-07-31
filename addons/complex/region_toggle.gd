@tool
extends EditorPlugin

func _enter_tree():
	var button = Button.new()
	button.text = "▶ Fold / Unfold Code 🗞📰"
	var base = EditorInterface.get_script_editor()
	base.get_child(0).get_child(0).add_child(button)
	button.move_to_front()
	button.pressed.connect(func():
		var editor = EditorInterface.get_script_editor().get_current_editor().get_base_editor()
		if editor is CodeEdit:
			match editor.get_folded_lines().size():
				0:
					editor.fold_all_lines()
					button.text = "▼ Unfold / Expand All Code 📰"
				_:
					editor.unfold_all_lines()
					button.text = "▲       Fold / Collapse All Code 🗞"
	)
