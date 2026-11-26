extends Control

const file_functions = preload("res://scripts/file_functions.gd")
const option_button_scene = preload("res://scenes/option_button.tscn")

var story_data: Dictionary = {}
var story_nodes: Dictionary = {}
var current_node_id: String = "S01"
var line_index: int = 0

var score_human: int = 0
var score_ia: int = 0
var history_stack: Array[Dictionary] = []

var characters: Dictionary = {}
var backgrounds: Dictionary = {}


func _ready() -> void:
	characters["character_a.png"] = load("res://images/character_a.png")
	characters["character_b.png"] = load("res://images/character_b.png")
	characters["character_phone_call.svg"] = load("res://images/character_phone_call.svg")

	var loaded = file_functions.load_json_file("res://dialogue/story.json")
	if typeof(loaded) == TYPE_DICTIONARY:
		story_data = loaded
		story_nodes = story_data.get("nodes", {})
		current_node_id = story_data.get("start_node", "S01")

	$VBoxContainer.visible = false
	_render_current()


func _process(_delta: float) -> void:
	pass


func _get_bg_texture(bg_name: String) -> Texture2D:
	if not backgrounds.has(bg_name):
		backgrounds[bg_name] = load("res://images/" + bg_name)
	return backgrounds[bg_name]


func _render_current() -> void:
	if not story_nodes.has(current_node_id):
		return

	var node: Dictionary = story_nodes[current_node_id]
	var lines: Array = node.get("lines", [])
	if lines.is_empty():
		return

	line_index = clampi(line_index, 0, lines.size() - 1)
	var line: Dictionary = lines[line_index]

	var bg_name: String = node.get("background", "bg_apartment.png")
	$ParkUI/TextureRect.texture = _get_bg_texture(bg_name)

	$ParkUI/RichTextLabel/RichTextLabel.text = str(line.get("speaker", ""))
	$ParkUI/RichTextLabel.text = str(line.get("text", ""))

	# Only Connie (character_a.png) and Alexa (character_b.png) are shown; Shae stays off-screen.
	var side_img = line.get("side_image", null)
	if side_img != null and characters.has(str(side_img)):
		$ParkUI/character_left.texture = characters[str(side_img)]
	else:
		$ParkUI/character_left.texture = null

	var choices: Array = node.get("choices", [])
	var show_choices := not choices.is_empty() and line_index == lines.size() - 1
	var is_end: bool = node.get("is_end", false) and line_index == lines.size() - 1

	_rebuild_choice_buttons(choices if show_choices else [])
	$VBoxContainer.visible = show_choices
	$ParkUI/RichTextLabel/HBoxContainer/NextButton.disabled = show_choices or is_end
	$ParkUI/RichTextLabel/HBoxContainer/BackButton.disabled = history_stack.is_empty()


func _rebuild_choice_buttons(choices: Array) -> void:
	for child in $VBoxContainer.get_children():
		child.queue_free()

	if choices.is_empty():
		return

	var many := choices.size() > 2
	$VBoxContainer.add_theme_constant_override("separation", 14 if many else 28)
	$VBoxContainer.offset_left = 960.0 if many else 1000.0
	$VBoxContainer.offset_right = 1800.0 if many else 1700.0
	$VBoxContainer.offset_top = -980.0 if many else -880.0
	$VBoxContainer.offset_bottom = -470.0 if many else -368.0

	for i in range(choices.size()):
		var btn: Button = option_button_scene.instantiate()
		btn.text = str(choices[i].get("text", ""))
		btn.custom_minimum_size = Vector2(820, 96) if many else Vector2(700, 150)
		btn.add_theme_font_size_override("font_size", 24 if many else 30)
		btn.pressed.connect(_on_choice_selected.bind(i))
		$VBoxContainer.add_child(btn)


func _push_history() -> void:
	history_stack.append({
		"node_id": current_node_id,
		"line_index": line_index,
		"score_human": score_human,
		"score_ia": score_ia,
	})


func _on_choice_selected(choice_idx: int) -> void:
	var node: Dictionary = story_nodes.get(current_node_id, {})
	var choices: Array = node.get("choices", [])
	if choice_idx < 0 or choice_idx >= choices.size():
		return

	_push_history()
	var choice: Dictionary = choices[choice_idx]
	score_human += int(choice.get("human_delta", 0))
	score_ia += int(choice.get("ia_delta", 0))
	current_node_id = str(choice.get("next", "END"))
	line_index = 0
	_render_current()


func _on_button_pressed() -> void:
	_on_choice_selected(0)


func _on_button_2_pressed() -> void:
	_on_choice_selected(1)


func _on_next_button_pressed() -> void:
	var node: Dictionary = story_nodes.get(current_node_id, {})
	var lines: Array = node.get("lines", [])
	if line_index < lines.size() - 1:
		_push_history()
		line_index += 1
		_render_current()
		return

	if not node.get("choices", []).is_empty() or node.get("is_end", false):
		return

	_push_history()
	if node.get("branch_on_score", false):
		current_node_id = str(node.get("next_human", "S12A")) if score_human >= 2 else str(node.get("next_ia", "S12B"))
	else:
		current_node_id = str(node.get("next", "END"))
	line_index = 0
	_render_current()


func _on_back_button_pressed() -> void:
	if history_stack.is_empty():
		return
	var prev: Dictionary = history_stack.pop_back()
	current_node_id = str(prev.get("node_id", "S01"))
	line_index = int(prev.get("line_index", 0))
	score_human = int(prev.get("score_human", 0))
	score_ia = int(prev.get("score_ia", 0))
	_render_current()


func _on_history_button_pressed() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_settings_button_pressed()


func _on_settings_button_pressed() -> void:
	$SettingsMenu.visible = not $SettingsMenu.visible
	_update_fullscreen_button_label()


func _on_resume_button_pressed() -> void:
	$SettingsMenu.visible = false


func _on_fullscreen_button_pressed() -> void:
	var current_mode := DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		var screen := DisplayServer.window_get_current_screen()
		var usable := DisplayServer.screen_get_usable_rect(screen)
		var win_size := Vector2i(1280, 720)
		DisplayServer.window_set_size(win_size)
		DisplayServer.window_set_position(usable.position + (usable.size - win_size) / 2)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_update_fullscreen_button_label()


func _on_minimize_button_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _update_fullscreen_button_label() -> void:
	var current_mode := DisplayServer.window_get_mode()
	var is_fs := current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	$SettingsMenu/CenterContainer/PanelContainer/VBoxContainer/FullscreenButton.text = "Fullscreen: On" if is_fs else "Fullscreen: Off"
