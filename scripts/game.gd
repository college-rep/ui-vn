extends Control

var button2_counter=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_button_pressed() -> void:
	if ($NightUI.visible):
		$NightUI.visible=false
		$VBoxContainer/Button.text="room OFF"
	else:
		$NightUI.visible=true
		$VBoxContainer/Button.text="room ON"



func _on_button_2_pressed() -> void:
	if ($ParkUI.visible):
		$ParkUI.visible=false
		$VBoxContainer/Button2.text="park OFF"
	else:
		$ParkUI.visible=true
		$VBoxContainer/Button2.text="park ON"

func _on_button_3_pressed() -> void:
	button2_counter+=1
	$VBoxContainer/Button3.text="counter at "+str(button2_counter)

func load_json_file(file_path: String) -> Variant:
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
