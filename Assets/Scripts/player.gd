extends CharacterBody2D


# VARIABLES Y CONSTANTES

@onready var coin = preload("res://Assets/Scenes/coin.tscn")
@onready var animation_player = preload("res://Assets/Scenes/animation_player.tscn")
@onready var jump_sound = preload("res://Assets/Music/Sound_effects/jump_sound.mp3")
@onready var coin_sound = preload("res://Assets/Music/Sound_effects/coin_sound.mp3")

@onready var main = get_parent()

@onready var music = $AudioStreamPlayer
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

const SPEED = 335.0
const JUMP_VELOCITY = -1000.0
const EXTRA_JUMP_VELOCITY = -900.0
const BUFFER_TIME = 0.2
const JUMP_CUT_MULTIPLIER = 5.0
const GRAVITY = 2000.0

var COIN_DB
var JUMP_DB

var jump_buffer_timer = 0.0
var extrajump = 0
var count_sierra = 0
var sierras_pendientes = []
var fly_started = false
var landing_particle = false
var sound_effect = true

signal muerte_tutorial

func _ready():
	if Global.EffectsVolume != 0:
		sound_effect = true
		COIN_DB = lerp(-30.0, -10.0, (Global.EffectsVolume/100.0))
		JUMP_DB = lerp(-32.0, -12.0, (Global.EffectsVolume/100.0))
	else:
		sound_effect = false

# ANIMACIONES

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


# CREAR MONEDAS

func create_coin(pos):
	var new_coin = coin.instantiate()
	get_tree().current_scene.add_child(new_coin)
	new_coin.position = sierras_pendientes[pos].position
	new_coin.linear_velocity.x = randf_range(-250, 250)
	new_coin.linear_velocity.y = randf_range(-250, 50)


# FÍSICA DEL JUGADOR

func _physics_process(delta):
	# CREAR MONEDAS AL ATERRIZAR
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


	# BUFFER DEL SALTO

	if Input.is_action_just_pressed("jump1"):
		jump_buffer_timer = BUFFER_TIME

	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta


	# JUGADOR EN EL SUELO

	if is_on_floor():
		# Partículas de caída
		if landing_particle:
			landing_particle = false
			animation("landing")

		# Recargar doble salto
		extrajump = 1
		fly_started = false

		# Ejecutar salto guardado en el buffer
		if jump_buffer_timer > 0:
			velocity.y = JUMP_VELOCITY
			jump_buffer_timer = 0
			if sound_effect:
				music.stream = jump_sound
				music.play()
				music.volume_db = JUMP_DB

		# Salto normal
		if Input.is_action_just_pressed("jump1"):
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
			animation("jump")
			if sound_effect:
				music.stream = jump_sound
				music.play()
				music.volume_db = JUMP_DB

	# JUGADOR EN EL AIRE
	else:
		landing_particle = true

		# Animaciones aéreas
		if not fly_started:
			if velocity.y > -400:
				fly_started = true
				anim.play("fly")
			else:
				anim.play("aerial")

		# DOBLE SALTO
		if (
			extrajump == 1
			and Input.is_action_just_pressed("jump1")
			and not is_on_floor()
		):
			velocity.y = EXTRA_JUMP_VELOCITY
			extrajump = 0
			anim.play("jump")
			fly_started = false
			animation("doublejump")
			if sound_effect:
				music.stream = jump_sound
				music.play()
				music.volume_db = JUMP_DB


		# GRAVEDAD Y CAÍDA
		# En un juego para móvil se podría eliminar esta opción
		# para ahorrar espacio en la pantalla con botones extra
		if Input.is_action_pressed("down1"):
			velocity.y += GRAVITY * delta * 0.5
		elif velocity.y < 0 and not Input.is_action_pressed("jump1"):
			velocity.y += GRAVITY * delta * JUMP_CUT_MULTIPLIER
		else:
			velocity.y += GRAVITY * delta

	# MOVIMIENTO HORIZONTAL
	var direction = Input.get_axis("left1", "right1")
	velocity.x = direction * SPEED

	# INICIO DE CARRERA
	if Input.is_action_just_pressed("left1") and is_on_floor():
		animation("startrunL")

	if Input.is_action_just_pressed("right1") and is_on_floor():
		animation("startrunD")

	# ANIMACIÓN DE CORRER / IDLE
	if velocity.x == 0 and is_on_floor():
		anim.play("idle")

	elif velocity.x != 0 and is_on_floor():
		anim.play("run")

		if velocity.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

	move_and_slide()

# ÁREA DE MUERTE / MONEDAS
func _on_death_area_area_entered(area):
	print(area.name)
	if get_tree().current_scene.name != "Tutorial":
		if area.name == "Sierra":
			Global.actual_score = main.coins
			get_tree().change_scene_to_file(
				"res://Assets/Scenes/game_over.tscn"
			)
		elif area.name == "Coin":
			area.get_parent().queue_free()
			main.actual_time += 1
			main.coins += 1
			if sound_effect:
				music.stream = coin_sound
				music.play()
				music.volume_db = COIN_DB

	else:
		# En el tutorial las mecánicas funcionan de forma diferente.
		if area.name == "Sierra":
			muerte_tutorial.emit()
		elif area.name == "Coin":
			area.get_parent().queue_free()
			if sound_effect:
				music.stream = coin_sound
				music.play()
				music.volume_db = COIN_DB

# SIERRAS QUE QUEDAN DEBAJO DEL JUGADOR
func _on_below_area_area_entered(area):
	if not is_on_floor() and area.name == "Sierra":
		count_sierra += 1
		area.get_parent().modulate = Color(1, 0, 0, 1)
		if area.get_parent() not in sierras_pendientes:
			sierras_pendientes.append(area.get_parent())
