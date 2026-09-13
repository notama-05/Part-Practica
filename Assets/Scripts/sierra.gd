extends CharacterBody2D

@onready var animation_player = preload("res://Assets/Scenes/animation_player.tscn")
@onready var sprite = $Sprite2D
const standard_vel = 300
var vel_range = 20
var final_vel : float
const min_angle = deg_to_rad(30)
const max_angle = deg_to_rad(150) 
var final_angle
var convfact = (2*PI)/360
var vel_count = 1
var rand_rot = randf_range(0.05, 0.1)
var rot_dir = rand_rot
var rot_cuant = rand_rot
var original
# Called when the node enters the scene tree for the first time.
func _ready():
	final_angle = randf_range(min_angle, max_angle)
	if get_tree().current_scene.name != "Init_menu":
		sprite.frame = Global.sierra_skin
		sprite.scale.x = 1.2
		sprite.scale.y = 1.2
		final_vel = randi_range(standard_vel, standard_vel+(vel_range*vel_count))
		original = false
	else:
		original = true
		sprite.frame = randi_range(0,8)
		sprite.scale.x = 1
		sprite.scale.y = 1
		final_vel = 250.0


func animation(cual):
	var new_animation = animation_player.instantiate()
	get_parent().add_child(new_animation)
	new_animation.global_position = global_position
	if cual == "iz":
		new_animation.play_sierra("iz")
	elif cual == "der":
		new_animation.play_sierra("der")
	elif cual == "suelo":
		new_animation.play_sierra("suelo")


func _on_sierra_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name == "Area1" or area.name == "Area2":
		final_angle = 180*convfact-final_angle
		if rot_dir > 0:
			rot_dir = -rot_cuant
		elif rot_dir < 0:
			rot_dir = rot_cuant
		if area.name == "Area1":
			animation("iz")
		elif area.name == "Area2":
			animation("der")
	if area.name == "Area3":
		final_angle -= 2*final_angle
		animation("suelo")

func _physics_process(delta):
	if original and get_tree().current_scene != null and get_tree().current_scene.name != "Init_menu":
		queue_free()
	sprite.rotation += rot_dir
	velocity.x = final_vel*cos(final_angle)
	velocity.y = final_vel*sin(final_angle)
	move_and_slide()
