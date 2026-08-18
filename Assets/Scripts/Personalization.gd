extends Node2D

@onready var sierra_sprite = $Sprite2D
@onready var skin_name = $Skin_name
var sierra_skin
var skin_names = ["Escut Anglès",
"Escut Medieval", "Escut Català", "Donut", "Pizza", 
"Taronja", "Pilota de Fútbol", "Serra Puntiaguda", "Serra Rodoneta", "Yen"]
# Called when the node enters the scene tree for the first time.
func _ready():
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
	get_tree().change_scene_to_file("res://Assets/Scenes/init_menu.tscn")
