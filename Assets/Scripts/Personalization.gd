extends Node2D

@onready var sierra_sprite = $VBoxContainer/HBoxContainer/Sprite2D
@onready var skin_name = $VBoxContainer/Skin_name
@onready var song = $AudioStreamPlayer2D

var sierra_skin
var skin_names = ["English shield",
"Medieval Shield", "Catalan Shield", "Donut", "Pizza", 
"Orange", "Football", "Pointy sawblade", "Rounded sawblade", "Yen"]
# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.MusicVolume != 0:
		song.volume_db = lerp(-15.0, 10.0, (Global.MusicVolume/100.0))
	else:
		song.stop()
	sierra_skin = Global.sierra_skin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sierra_sprite.frame = sierra_skin
	skin_name.text = skin_names[sierra_skin]

func _on_past_pressed():
	if sierra_skin == 0:
		sierra_skin = 9
	else:
		sierra_skin -= 1

func _on_next_pressed():
	if sierra_skin == 9:
		sierra_skin = 0
	else:
		sierra_skin += 1

func _on_accept_pressed():
	Global.sierra_skin = sierra_skin
	Global.save_data()
	Global.paso = 2
	get_tree().change_scene_to_file("res://Assets/Scenes/init_menu.tscn")
