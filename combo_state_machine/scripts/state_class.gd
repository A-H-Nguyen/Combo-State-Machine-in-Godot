extends Sprite

#these 2 variables should never be changed:

onready var active_sprite = load("res://Assets/state_active.png")
onready var idle_sprite = load("res://Assets/state_idle.png")
#Unfortunately, Godot gets upset if you try to store these in constant variables
#So just don't change them!

var active = false

export var state_duration = 0.75 #state duration is in number of seconds, which is number of frames divided by 60

func _ready():
	texture = idle_sprite #since the states are idle by default, the texture will initially be the idle_sprite

func _process(_delta):
	if(active):
		$TextureProgress.value = 100 - ($state_time.time_left / (state_duration / 100)) #It just works (tricky math)

func set_idle():
	active = false
	$TextureProgress.value = 0
	texture = idle_sprite

func set_active():
	active = true
	texture = active_sprite
	$state_time.start(state_duration)

func _on_state_time_timeout():
	set_idle()
