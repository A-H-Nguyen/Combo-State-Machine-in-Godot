extends Node2D # ***If I did my job correctly, you could just stick this script onto any Godot object you want!

#These enumerators represent the various states ***NOTE: They DO NOT actually STORE the states***
enum {STATE_A0, STATE_A1, STATE_A2, STATE_A3, STATE_B0, STATE_B1, STATE_B2}

#This array has all the names of the different animations:
var animations = ["state_a0", "state_a1", "state_a2", "state_a3", "state_b0", "state_b1", "state_b2"]

var current_state = null #need null values for when all states are idle
var next_state = null 

#The way this is structured allows you to call an animation based in the current state.
#For example, animations[0] = "state_a0", and STATE_A0 is a constant int equal to 0,
#so if current_state = STATE_A0, then animations[current_state] = "state_a0"

onready var states = $state_a.get_children() + $state_b.get_children() #storing all the different states as 1 array

func _unhandled_input(_event):
	if Input.is_action_pressed("ui_cancel"): #"Convenient Kill switch" -- pressing ESC will close the game
		get_tree().quit()
	
	if Input.is_action_just_pressed("action1"):
		match current_state:
			null:
				next_state = STATE_A0
				to_next_state() 
			STATE_A0:
				next_state = STATE_A1
			STATE_A1:
				next_state = STATE_A3
			STATE_A2:
				next_state = STATE_A3
	
	if Input.is_action_just_pressed("action2"):
		match current_state:
			null:
				next_state = STATE_B0
				to_next_state()
			STATE_A0:
				next_state = STATE_A2
			STATE_A2:
				next_state = STATE_B2
			STATE_B0:
				next_state = STATE_B1
			STATE_B1:
				next_state = STATE_B2

func to_next_state(): 
	if(next_state != null):
		current_state = next_state
		next_state = null
		states[current_state].set_active()
		$AnimatedSprite.play(animations[current_state])
	else:
		current_state = null
		next_state = null
		$AnimatedSprite.play("Idle")

func _on_AnimatedSprite_animation_finished():
	to_next_state()
