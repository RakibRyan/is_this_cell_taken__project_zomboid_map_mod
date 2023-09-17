extends RefCounted

## used to mark readonly components, like auto generated components
## not serialized
var readonly: bool = false

class License:
    extends RefCounted

    var name: String
    var identifier: String
    ## Use either license_text or license_file
    var text: String
    ## Will be loaded at runtime if license_text is not filled.
    var file: String
    ## Web present of the license
    var web: String

    func get_property_list() -> Array:
        var properties: Array = super.get_property_list()
        for property in properties:
            if property["name"] == "text":
                property["hint"] = PROPERTY_HINT_MULTILINE_TEXT
            if property["name"] == "file":
                property["hint"] = PROPERTY_HINT_FILE
        return properties

    ## Either returns the license text or loads the text from file or a message that the text could not be loaded.
    func get_license_text() -> String:
        if self.text != "":
            return self.text

        var file: FileAccess = FileAccess.open(self.file, FileAccess.READ)
        if file == null:
            return "License text not available. (Could not load file)"
        var text: String = file.get_as_text()
        file = null
        return text

    func serialize() -> Dictionary:
        return {
            "name": self.name,
            "identifier": self.identifier,
            "text": self.text,
            "file": self.file,
            "web": self.web,
        }

    func deserialize(data: Dictionary):
        self.name = data.get("name", "")
        self.identifier = data.get("identifier", "")
        self.text = data.get("text", "")
        self.file = data.get("file", "")
        self.web = data.get("web", "")
        return self

## Identifier
var id: String
## Use to structure the licenses to top categories. E.g. Textures, Fonts, ...
var category: String

## Name of the software or component
var name: String
## Version of the software or component
var version: String
## Name of the copyrights
var copyright: PackedStringArray = []
## Contact to developer
var contact: String
## Additional description.
var description: String
## Web url to project page
var web: String
## Array of String, affected files or directories
var paths: PackedStringArray = []
var licenses: Array[License] = []

func get_property_list() -> Array:
    var properties: Array = super.get_property_list()
    for property in properties:
        if property["name"] == "paths":
            property["hint"] = PROPERTY_HINT_FILE
            # allow files too (inofficial)
            property["hint_text"] = "*"
        if property["name"] == "description":
            property["hint"] = PROPERTY_HINT_MULTILINE_TEXT
        if property["name"] == "licenses":
            property["constructor"] = License.new
    return properties

func serialize() -> Dictionary:
    var licenses: Array[Dictionary] = []
    for license in self.licenses:
        licenses.append(license.serialize())
    return {
        "id": self.id,
        "category": self.category,
        "name": self.name,
        "version": self.version,
        "copyright": self.copyright,
        "contact": self.contact,
        "description": self.description,
        "web": self.web,
        "paths": self.paths,
        "licenses": licenses,
    }

func deserialize(data: Dictionary):
    self.id = data.get("id", "")
    self.category = data.get("category", "")
    self.name = data.get("name", "")
    self.version = data.get("version", "")
    self.copyright = data.get("copyright", PackedStringArray())
    self.contact = data.get("contact", "")
    self.description = data.get("description", "")
    self.web = data.get("web", "")
    self.paths = data.get("paths", [])
    for license in data.get("licenses", []):
        self.licenses.append(License.new().deserialize(license))
    return self
