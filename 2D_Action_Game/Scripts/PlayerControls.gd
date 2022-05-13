extends KinematicBody2D

export (int) var speed = 1000
export (int) var jump_force = -800
export (int) var gravity = 600 

#these two variables will smooth the player's movement to make it feel more natural:
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO
var floor_vec = Vector2(0,-1) #this is where the floor is

enum {IDLE, ATK_1A, ATK_1B, ATK_1C, ATK_2A, ATK_2B, ATK_2C} #Represent the various player states

# listing the names of the animations:
var animations = ["Idle", "Attack1a", "Attack1b", "Attack1c", "Attack2a", "Attack2b", "Attack2c"]

var current_state = IDLE
var next_state = IDLE

var next_atk = null
#var anim_player = null
#
#func onready(): 
#	anim_player = get_node("PlayerSprite/AnimationPlayer") 

#this function records the player's movement inputs and moves them
func player_mvmnt(_delta):
	var dir = 0 #dir means "direction"
	if Input.is_action_pressed("move_right"):
		dir += 1
		$PlayerSprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		dir -= 1
		$PlayerSprite.flip_h = true
	
	if dir != 0:
		velocity.x = lerp(0, speed * dir, acceleration)
	else:
		#velocity.x = lerp(velocity.x, 0, friction)
		velocity.x = 0
	
	velocity = move_and_slide(velocity, floor_vec) #this line actually moves the player



#Both initiates attacks, and travels to the next attack
func attack(): 
	if(next_atk != null):
		current_state = next_atk
		next_atk = null
		$PlayerSprite/AnimationPlayer.play(animations[current_state])
#		$PlayerSprite.play(animations[current_state])
	else:
		current_state = IDLE
		next_atk = null



#Logic for determining next attack
func get_next_atk(atk_btn):
	match current_state:
		IDLE:
			if(atk_btn == 1):
				next_atk = ATK_1A
			elif(atk_btn == 2):
				next_atk = ATK_2A
		
		ATK_1A:
			if(atk_btn == 1):
				next_atk = ATK_1B
			elif(atk_btn == 2):
				next_atk = ATK_2B
		
		ATK_2A:
			if(atk_btn == 1):
				next_atk = ATK_1B
			elif(atk_btn == 2):
				next_atk = ATK_2B
		
		ATK_1B:
			if(atk_btn == 1):
				next_atk = ATK_1C
			elif(atk_btn == 2):
				next_atk = ATK_2A
		
		ATK_2B:
			if(atk_btn == 1):
				next_atk = ATK_1A
			elif(atk_btn == 2):
				next_atk = ATK_2C
	
		ATK_1C:
			next_atk = null
	
		ATK_2C:
			next_atk = null
	
#	attack()
#	$PlayerSprite/AnimationPlayer.play(animations[next_atk])


#Handles all the other inputs
func _unhandled_input(_event):
	if Input.is_action_pressed("ui_cancel"): #"Convenient Kill switch" -- pressing ESC will close the game
		get_tree().quit()
	
	if Input.is_action_just_pressed("Action1"):
		get_next_atk(1)
	
	if Input.is_action_just_pressed("Action2"):
		get_next_atk(2)




#
#
func _physics_process(delta): 
	attack()
	if(current_state == IDLE):
		player_mvmnt(delta)
#	$PlayerSprite/AnimationPlayer.play(animations[current_state])


func _on_AnimationPlayer_animation_finished(_anim_name):
	pass
#	if(next_atk != null):
#		current_state = next_atk
#		next_atk = null
#		$PlayerSprite/AnimationPlayer.play(animations[current_state])
##		$PlayerSprite.play(animations[current_state])
#	else:
#		current_state = IDLE
#		next_atk = null

