extends CharacterBody2D

#variables y constantes varias
@onready var coin = preload("res://Assets/Scenes/coin.tscn")
const speed = 325.0
const jump_velocity = -1000.0
const extra_jump_velocity = -900.0
const buffer_time = 0.2
const jump_cut_multiplier = 5.0
const gravity = 2000
var jump_buffer_timer = 0.0
var extrajump = 0
var count_sierra = 0
var sierras_pendientes =[]

func create_coin(pos):
	var new_coin = coin.instantiate()
	get_tree().current_scene.add_child(new_coin)
	new_coin.position = sierras_pendientes[pos].position
	new_coin.linear_velocity.x = randf_range(-250, 250)
	new_coin.linear_velocity.y = randf_range(-250, 50)

func _physics_process(delta):
	if is_on_floor() and sierras_pendientes:
		if len(sierras_pendientes) == 1:
			create_coin(0)
		elif len(sierras_pendientes) == 2:
			for t in 2:
				create_coin(0)
			create_coin(1)
		elif len(sierras_pendientes) == 3:
			for t in 5:
				if t < 2:
					create_coin(0)
				else:
					create_coin(1)
		elif len(sierras_pendientes) == 4:
			for t in 10:
				if t < 3:
					create_coin(0)
				elif t < 6:
					create_coin(1)
				elif t < 9:
					create_coin(2)
				else:
					create_coin(3)

		for n in sierras_pendientes:
			if is_instance_valid(n):
				n.queue_free()
		sierras_pendientes.clear()

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


func _on_death_area_area_entered(area):
	if area.name == "Sierra":
		queue_free()

func _on_below_area_area_entered(area):
	if not is_on_floor() and area.name == "Sierra":
		count_sierra += 1 
		area.get_parent().modulate = Color(1, 0, 0, 1)
		sierras_pendientes.append(area.get_parent())

func _on_death_area_body_entered(body):
	print(body.name)
	if body.is_in_group("Coin"):
		body.queue_free()
