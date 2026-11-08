extends Control

var mati_scene = preload("res://scene/UI/mati.tscn")

func enter() -> void: mati_ui()
func exit() -> void: pass
func mati_ui() -> void:
	var menu = mati_scene.instantiate()
	get_tree().current_scene.add_child(menu)
