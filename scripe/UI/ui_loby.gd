extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("tombol_serang"):
		ganti_scene()

func _on_button_pressed() -> void:
	ganti_scene()

func ganti_scene() -> void:
	get_tree().change_scene_to_file("res://scene/ggn.tscn") 
	# ganti ke scene baru
