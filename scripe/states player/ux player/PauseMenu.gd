extends State

var menu_scene := preload("res://scene/UI/pause_menu.tscn")

func enter() -> void:
    main_menu()
    pass

func exit() -> void:
    pass

func main_menu() -> void:
    var menu = menu_scene.instantiate()

    player.get_tree().current_scene.add_child(menu)
    
    player.ubah_state("idle")
