extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func load_json_file(file_path: String) -> Variant:
	# 1. Check if the file exists
	if not FileAccess.file_exists(file_path):
		print("ERROR: JSON file not found at path: ", file_path)
		return null

	# 2. Get the entire file content as a single string
	var json_as_text: String = FileAccess.get_file_as_string(file_path)

	# 3. Parse the JSON string
	# JSON.parse_string() is a static method that returns the parsed data
	# (a Dictionary, Array, etc., or null on failure).
	var parsed_data: Variant = JSON.parse_string(json_as_text)

	# 4. Check for parsing errors and return the data
	if parsed_data == null:
		# If it fails, the JSON string might be invalid.
		# For more detailed error reporting, you would use the JSON.parse() instance method.
		print("ERROR: Failed to parse JSON data from file: ", file_path)
		return null
	return parsed_data

static func get_dialogue_files(path:String)->Array:
	var dir = DirAccess.open(path)
	var file_list:Array=[]
	if dir:
		var files: PackedStringArray = dir.get_files()
		for f in files:
			file_list.append(f)
		print(file_list)
		return file_list
	else:
		print("An error occurred when trying to access the path: ", path)
		return []
