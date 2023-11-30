extends AudioStreamPlayer

var jump1 = preload("res://assets/sounds/sfx/jump.wav")
var jump2 = preload("res://assets/sounds/sfx/Jump2.wav")
var jump3 = preload("res://assets/sounds/sfx/Jump3.wav")

var cut1 = preload("res://assets/sounds/sfx/cut.wav")
var cut2 = preload("res://assets/sounds/sfx/cut2.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("cutRope")):
		playCut()
	
func playCut():
	var cut = randi()%2
	match cut:
		0:
			stream = cut1
		1:
			stream = cut2
	play()
	
func playJump():
	var jump = randi()%3
	match jump:
		0:
			stream = jump1
		1:
			stream = jump2
		2:
			stream = jump3
				
	play()
		
