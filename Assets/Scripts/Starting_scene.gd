extends Node2D

@onready var sierra = preload("res://Assets/Scenes/sierra.tscn")

func create_sierras():
	while true:
		for marker in get_children():
			if marker is Marker2D:
				var newsierra = sierra.instantiate()
				get_parent().add_child(newsierra)
				newsierra.global_position = marker.global_position
		await get_tree().create_timer(0.4).timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	create_sierras()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("click"):
		get_tree().change_scene_to_file("res://Assets/Scenes/init_menu.tscn")

func _on_area_2d_area_entered(area):
	area.queue_free()	
