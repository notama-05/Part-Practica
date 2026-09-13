extends CharacterBody2D

#variables y constantes varias
@onready var coin = preload("res://Assets/Scenes/coin.tscn")
@onready var animation_player = preload("res://Assets/Scenes/animation_player.tscn")
@onready var main = get_parent()
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
const speed = 335.0
const jump_velocity = -1000.0
const extra_jump_velocity = -900.0
const buffer_time = 0.2
const jump_cut_multiplier = 5.0
const gravity = 2000
var jump_buffer_timer = 0.0
var extrajump = 0
var count_sierra = 0
var sierras_pendientes =[]
var fly_started
var landing_particle
signal muerte_tutorial

func animation(cual):
	var new_animation = animation_player.instantiate()
	get_parent().add_child(new_animation)
	new_animation.global_position = global_position
	if cual == "jump":
		new_animation.play_jump()
	elif cual == "doublejump":
		new_animation.play_doublejump()
	elif cual == "landing":
		new_animation.play_landing()
	elif cual == "startrunL":
		new_animation.play_startrun("l")
	elif cual == "startrunD":
		new_animation.play_startrun("d")

			
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

	if is_on_floor():#si esta tocando el suelo...
		#particulas de caida
		if landing_particle:
			landing_particle = false
			animation("landing")
			
		#recarga del doble salto
		extrajump = 1
		fly_started = false
		# si hay salto en el buffer, ejecutarlo al tocar el suelo
		if jump_buffer_timer > 0:
			velocity.y = jump_velocity
			jump_buffer_timer = 0
		#salto
		if Input.is_action_just_pressed("jump1"):
			velocity.y = jump_velocity
			#animación del personaje
			anim.play("jump")
			#animación de las particulas
			animation("jump")
			
			
	else: #si no esta tocando el suelo
		landing_particle = true
		if not fly_started:
			if velocity.y > -400:
				fly_started = true
				anim.play("fly")
			else:
				anim.play("aerial")

#ejecución del doble salto
		if extrajump == 1 and Input.is_action_just_pressed("jump1") and not is_on_floor(): 
			velocity.y = extra_jump_velocity
			extrajump = 0 
			anim.play("jump")
			fly_started = false
			animation("doublejump")

#en el caso de pasar a ser un juego de movil quitaria la opcion de ir hacia abajo para no ocupar tanto espacio en la pantalla
		if Input.is_action_pressed("down1"): 
			velocity.y += gravity * delta * 0.5
		elif velocity.y < 0 and not Input.is_action_pressed("jump1"):
			velocity.y += gravity * delta * jump_cut_multiplier
		else:
			velocity.y += gravity * delta

	# movimiento horizontal
	var direction = Input.get_axis("left1", "right1")
	velocity.x = direction * speed
	
	if Input.is_action_just_pressed("left1") and is_on_floor():
		animation("startrunL")
	if Input.is_action_just_pressed("right1") and is_on_floor():
		animation("startrunD")
	#animación correr y animación idle
	if velocity.x == 0 and is_on_floor():
		anim.play("idle")
	elif velocity.x != 0 and is_on_floor():
		anim.play("run")
		if velocity.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

	move_and_slide()


func _on_death_area_area_entered(area):
	print(area.name)
	if get_tree().current_scene.name != "Tutorial":
		if area.name == "Sierra":
			Global.actual_score = main.coins
			get_tree().change_scene_to_file("res://Assets/Scenes/game_over.tscn")
		elif area.name == "Coin":
			area.get_parent().queue_free()
			main.actual_time += 1
			main.coins += 1
	else:#cuando esta en el tutorial las mecanicas han de doblarse un poco
		if area.name == "Sierra":
			muerte_tutorial.emit()
		elif area.name == "Coin":
			area.get_parent().queue_free()


func _on_below_area_area_entered(area):
	if not is_on_floor() and area.name == "Sierra":
		count_sierra += 1 
		area.get_parent().modulate = Color(1, 0, 0, 1)
		if area.get_parent() not in sierras_pendientes:
			sierras_pendientes.append(area.get_parent())

