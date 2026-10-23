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
