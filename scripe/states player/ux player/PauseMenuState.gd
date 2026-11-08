extends Control

var menu_scene := preload("res://scene/UI/pause_menu.tscn")

func enter() -> void: main_menu()
func exit() -> void:
	pass

func main_menu() -> void:
	var menu = menu_scene.instantiate()
	get_tree().current_scene.add_child(menu)
