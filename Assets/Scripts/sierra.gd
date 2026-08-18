extends CharacterBody2D

@onready var sprite = $Sprite2D
const standard_vel = 300
var vel_range = 20
var final_vel
const min_angle = deg_to_rad(30)
const max_angle = deg_to_rad(150) 
var final_angle
var convfact = (2*PI)/360
var vel_count = 1
var rand_rot = randf_range(0.05, 0.1)
var rot_dir = rand_rot
var rot_cuant = rand_rot
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.frame = Global.sierra_skin
	final_vel = randi_range(standard_vel, standard_vel+(vel_range*vel_count))
	final_angle = randf_range(min_angle, max_angle)

func _on_sierra_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name == "Area1" or area.name == "Area2":
		final_angle = 180*convfact-final_angle
		if rot_dir > 0:
			rot_dir = -rot_cuant
		elif rot_dir < 0:
			rot_dir = rot_cuant
	if area.name == "Area3":
		final_angle -= 2*final_angle

func _physics_process(delta):
	sprite.rotation += rot_dir
	velocity.x = final_vel*cos(final_angle)
	velocity.y = final_vel*sin(final_angle)
	move_and_slide()
