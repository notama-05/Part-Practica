extends Node2D

@onready var sierra = preload("res://Assets/Scenes/sierra.tscn")
@onready var spawnpoints = [$Spawn1, $Spawn2, $Spawn3, $Spawn4, $Spawn5]
@onready var prog_bar = $Container/ProgressBar
@onready var label = $Container/Label
@onready var song = $SongPlayer

var temp_init = 5
var num_sierras_init = 1
var total_time = 60.0
var timer_init = 4.0
var timer_res = 0.1
var final_timer
var count = 0
var actual_time: float
var coins = 0


func calc_of_num_sierras():
	if count == 0:
		create_sierra()
		count += 1
		return

	var random = randi_range(0, 99)
	var probabilidades: Array

	if count <= 5:
		probabilidades = [[30, 1], [90, 2], [100, 3]]
	elif count <= 12:
		probabilidades = [[20, 1], [70, 2], [100, 3]]
	elif count <= 25:
		probabilidades = [[10, 1], [35, 2], [75, 3], [100, 4]]
	else:
		probabilidades = [[5, 1], [30, 2], [55, 3], [100, 4]]

	for rango in probabilidades:
		if random < rango[0]:
			for i in rango[1]:
				create_sierra()
			break

	count += 1

func create_sierra():
	var new_sierra = sierra.instantiate()
	get_tree().current_scene.add_child.call_deferred(new_sierra)
	new_sierra.position = spawnpoints[randi_range(0,4)].position
	new_sierra.vel_count = count
	final_timer = timer_init - (timer_res*count)

func _ready():
	if Global.MusicVolume != 0:
		song.volume_db = lerp(-2.0, 23.0, (Global.MusicVolume/100.0))
	else:
		song.stop()
	final_timer = timer_init
	actual_time = total_time
	prog_bar.min_value = 0
	prog_bar.max_value = total_time
	prog_bar.value = total_time
	calc_of_num_sierras()

func _physics_process(delta):
	var text_coins = str(coins)
	label.text = text_coins
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	actual_time -= delta
	final_timer -= delta
	prog_bar.value = actual_time
	if actual_time <= 0:
		get_tree().reload_current_scene()
	if final_timer <= 0:
		calc_of_num_sierras()

func _on_destruye_sierras_area_entered(area):
	if area.name == "Sierra":
		area.queue_free()
