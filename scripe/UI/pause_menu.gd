extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not event.is_echo():
		lanjutkan()
		get_viewport().set_input_as_handled()

func lanjutkan() -> void:
	get_tree().paused = false
	get_parent().queue_free()

func _on_kembali_pressed() -> void:
	lanjutkan()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/UI/ui_loby.tscn")
