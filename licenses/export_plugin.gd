extends EditorExportPlugin

const Licenses := preload("licenses.gd")

func _get_name() -> String:
    return "kenyoni_licenses_exporter"

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
    var res = Licenses.load(Licenses.get_license_data_filepath())
    if res.err_msg != "":
        push_error("Failed to export license files: " + res.err_msg)
        return
    self._add_file(Licenses.get_license_data_filepath())
    for component in res.components:
        for license in component.licenses:
            if license.file != "":
                self._add_file(license.file)

func _add_file(file_path: String) -> void:
    var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
    if file == null:
        push_error("Could not open file ("+String.num_int64(FileAccess.get_open_error())+"): " + file_path)
        return
    var content: PackedByteArray = file.get_buffer(file.get_length())
    file = null
    self.add_file(file_path, content, false)
