extends AnimatedSprite2D

const conv_fact = ((2*PI)/360)

func play_jump():
	global_position.y -= 15
	play("jump_animation")

func play_doublejump():
	play("doublejump_animation")

func play_landing():
	global_position.y -= 15
	play("landing_animation")
	
func play_startrun(dir):
	print("animación")
	global_position.y -= 10
	if dir == "d":
		print("d")
		global_position.x -= 50
	else:
		print("i")
		flip_h = true
		global_position.x += 50
	play("startrun_animation")

func play_sierra(paret):
	scale.x = 0.9
	scale.y = 0.9
	if paret != "suelo":
		rotation = 90 * conv_fact
		if paret == "der":
			print("paret derecha")
			flip_v = true
			global_position.x -= 20
		else:
			print("paret izquierda")
			flip_v = false
			global_position.x += 20
	else:
		global_position.y -= 20
	play("sierra_animation")

func _on_animation_finished():
	scale.x = 1
	scale.y = 1
	flip_v = false
	rotation = 0
	print("acabado")
	queue_free()
