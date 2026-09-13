extends Node2D

@onready var sierra = preload("res://Assets/Scenes/sierra.tscn")
@onready var spawnpoints = [$Spawn1, $Spawn2, $Spawn3, $Spawn4, $Spawn5]
@onready var prog_bar = $Container/ProgressBar
@onready var label = $Container/Label
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
	var random = randi_range(0,100)
	if count == 0:
		create_sierra()
		count += 1
	elif count <= 5:
		if random < 30:
			create_sierra()
		elif random < 90:
			for i in 2:
				create_sierra()
		else:
			for i in 3:
				create_sierra()
		count += 1
	elif count <= 12:
		if random < 20:
			create_sierra()
		elif random < 70:
			for i in 2:
				create_sierra()
		else:
			for i in 3:
				create_sierra()
		count += 1
	elif count <= 25:
		if random < 10:
			create_sierra()
		elif random < 35:
			for i in 2:
				create_sierra()
		elif random < 75:
			for i in 3:
				create_sierra()
		else:
			for i in 4:
				create_sierra()
		count += 1
	else:
		if random < 5:
			create_sierra()
		elif random < 30:
			for i in 2:
				create_sierra()
		elif random < 55:
			for i in 3:
				create_sierra()
		else:
			for i in 4:
				create_sierra()
		count += 1

func create_sierra():
	var new_sierra = sierra.instantiate()
	get_tree().current_scene.add_child.call_deferred(new_sierra)
	new_sierra.position = spawnpoints[randi_range(0,4)].position
	new_sierra.vel_count = count
	final_timer = timer_init - (timer_res*count)

func _ready():
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
