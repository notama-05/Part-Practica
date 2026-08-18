extends RigidBody2D

func _on_coin_area_entered(area):
	if area.name == "Area3":
		$AnimatedSprite2D.play("default")
		rotation = 0
