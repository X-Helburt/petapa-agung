extends Control

func _ready() -> void: 
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		respawn()
	
	
func _on_respawn_pressed() -> void:
	respawn()
	
	pass # Replace with function body.


func _on_mainmenu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/UI/ui_loby.tscn")
	pass # Replace with function body.

func respawn() -> void:
	get_tree().paused = false
	get_parent().queue_free()
