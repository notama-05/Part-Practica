extends AnimatedSprite2D

@onready var me = $"."
# Called when the node enters the scene tree for the first time.
func play_jump():
	global_position.y -= 15
	me.play("jump_animation")

func play_landing():
	global_position.y -= 15
	me.play("landing_animation")
	
func _on_animation_finished():
	me.queue_free()
