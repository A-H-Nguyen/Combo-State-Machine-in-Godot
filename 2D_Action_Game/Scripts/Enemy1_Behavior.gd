extends KinematicBody2D

enum {IDLE, ATTACK, STUNNED} # enemy states
var current_state = IDLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_state == IDLE:
		$EnemSprite.play("idle")
		$Hitbox/CollisionShape2D.disabled = true
	elif current_state == ATTACK:
		$EnemSprite.play("attack")
		
		if $EnemSprite.get_frame() >= 2 && $EnemSprite.get_frame() <= 5:
			$Hitbox/CollisionShape2D.disabled = false
		else:
			$Hitbox/CollisionShape2D.disabled = true
	elif current_state == STUNNED:
		$EnemSprite.play("stunned")
		$Hitbox/CollisionShape2D.disabled = false



func _on_Detector_area_entered(area):
	current_state = ATTACK


func _on_Detector_area_exited(area):
	current_state = IDLE


func _on_Hitbox_area_entered(area):
	if current_state != STUNNED:
		current_state = STUNNED
	else:
		queue_free()

