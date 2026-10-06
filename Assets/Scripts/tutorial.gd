extends Node2D

@onready var letrero = $Letrero
@onready var player = $Player
@onready var SpriteSierra = $SpriteSierra
@onready var SpriteMoneda = $SpriteMoneda
@onready var boton_continuar = $NextButton
@onready var song = $AudioStreamPlayer2D

@onready var sierra = preload("res://Assets/Scenes/sierra.tscn")

var paso = 0
var cuenta = 0

var textos = ["press space to jump", 
"jump while being on the air to make a double jump", 
"These kind of objects are dangerous, jump over them when they fall", 
"As you've seen, eliminating the objects gives you coins, they will grant you some extratime to survive.
Now it's the moment to jump into action!" 
]

func _ready():
	if Global.MusicVolume != 0:
		song.volume_db = lerp(-15.0, 10.0, (Global.MusicVolume/100.0))
	else:
		song.stop()
	SpriteSierra.visible = false
	SpriteSierra.frame = Global.sierra_skin
	SpriteMoneda.visible = false
	letrero.text = textos[0]
	boton_continuar.visible = false
	player.muerte_tutorial.connect(_muerte_tutorial)

func _muerte_tutorial():
	player.queue_free()
	letrero.text = "You've bump into one of the falling objects and died, it's okay, just press R"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player) and Input.is_action_just_pressed("jump1") and paso == 0:
		paso = 1
		letrero.text = textos[paso]
	if is_instance_valid(player) and Input.is_action_just_pressed("jump1") and not player.is_on_floor() and player.extrajump == 0 and paso == 1:
		paso = 2
		letrero.text = textos[paso]
		SpriteSierra.visible = true
		await get_tree().create_timer(3.0).timeout
		SpriteSierra.visible = false
		create_sierra()
	if is_instance_valid(player) and player.is_on_floor() and player.sierras_pendientes and paso == 2:
		paso = 3
		letrero.text = textos[paso]
		SpriteMoneda.visible = true
		SpriteMoneda.play("default")
		boton_continuar.visible = true
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func create_sierra():
	var new_sierra = sierra.instantiate()
	get_tree().current_scene.add_child(new_sierra)
	new_sierra.position.x = 277
	new_sierra.position.y = -78

func _on_skip_button_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/main.tscn")

func _on_next_button_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/main.tscn")

func _on_destruye_sierras_area_entered(area):
	if area.name == "Sierra" and player != null:
		letrero.text = "Don't worry, it will fall another one soon"
		cuenta += 1
		if cuenta == 3:
			letrero.text = "Not to be mean or anything, but the idea is that you jump over the falling objects"
		if cuenta >= 4:
			letrero.text = "CAN YOU PLEASE JUMP OVER THE FALLING OBJECT!?!?!"
		create_sierra()
		area.queue_free()
