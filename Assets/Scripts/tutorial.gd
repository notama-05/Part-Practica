extends Node2D

@onready var letrero = $Letrero
@onready var player = $Player
@onready var SpriteSierra = $SpriteSierra
@onready var SpriteMoneda = $SpriteMoneda
@onready var boton_continuar = $NextButton
@onready var sierra = preload("res://Assets/Scenes/sierra.tscn")
var paso = 0

var textos = ["pulsa espacio para saltar", 
"salta en el aire para ejecutar un doble salto", 
"esto es una sierra ahora cuando baje salta por encima de ella", 
"como has visto la sierra suelta monedas como esta, eso te ganará tiempo para sobrevivir, ahora es momento de saltar a la acción" 
]

func _ready():
	SpriteSierra.visible = false
	SpriteMoneda.visible = false
	letrero.text = textos[0]
	boton_continuar.visible = false
	player.muerte_tutorial.connect(_muerte_tutorial)

func _muerte_tutorial():
	player.queue_free()
	letrero.text = "has muerto por tocar la sierra, no pasa nada, presiona la R"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump1") and paso == 0:
		paso = 1
		letrero.text = textos[paso]
	if Input.is_action_just_pressed("jump1") and not player.is_on_floor() and player.extrajump == 0 and paso == 1:
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
