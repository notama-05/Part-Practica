extends CharacterBody2D

const standard_vel = 450
var vel_range = 20
var final_vel
const min_angle = deg_to_rad(22.5)
const max_angle = deg_to_rad(157.5) 
var final_angle
var convfact = (2*PI)/360

# Called when the node enters the scene tree for the first time.
func _ready():
	final_vel = randi_range(standard_vel-vel_range, standard_vel+vel_range)
	final_angle = randf_range(min_angle, max_angle)

func _on_sierra_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name == "Area1" or area.name == "Area2":
		final_angle = 180*convfact-final_angle
	else:
		final_angle -= 2*final_angle

func _physics_process(delta):
	velocity.x = final_vel*cos(final_angle)
	velocity.y = final_vel*sin(final_angle)
	move_and_slide()
