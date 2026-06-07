extends CharacterBody2D

#variables i constantes varias
const speed = 250.0
const jump_velocity = -1000.0
const extra_jump_velocity = -900.0
const buffer_time = 0.2
const jump_cut_multiplier = 6.0
const gravity = 2000
var jump_buffer_timer = 0.0
var extrajump = 0

func _physics_process(delta):
	# guardar el intento de salto en el buffer
	if Input.is_action_just_pressed("jump1"):
		jump_buffer_timer = buffer_time

	# reducir el buffer con el tiempo
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	# 
	if not is_on_floor():
#ejecución del doble salto
		if extrajump == 1 and Input.is_action_just_pressed("jump1") and not is_on_floor(): 
			velocity.y = extra_jump_velocity
			extrajump = 0 
#comprovaciones para saber como aplicar la caida, 
#en el caso de pasar a ser un juego de movil quitaria la opcion de ir hacia abajo para no ocupar tanto espacio en la pantalla
		if Input.is_action_pressed("down1"): 
			velocity.y += gravity * delta * 0.5
		elif velocity.y < 0 and not Input.is_action_pressed("jump1"):
			velocity.y += gravity * delta * jump_cut_multiplier
		else:
			velocity.y += gravity * delta
	else: #si esta tocando el suelo...
		#recarga del doble salto
		extrajump = 1
		# si hay salto en el buffer, ejecutarlo al tocar el suelo
		if jump_buffer_timer > 0:
			velocity.y = jump_velocity
			jump_buffer_timer = 0
		#salto
		if Input.is_action_just_pressed("jump1"):
			velocity.y = jump_velocity

	# movimiento horizontal
	var direction = Input.get_axis("left1", "right1")
	velocity.x = direction * speed
	move_and_slide()
