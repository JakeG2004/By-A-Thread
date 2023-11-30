extends AudioStreamPlayer

var wimdy = preload("res://assets/sounds/music/wimdy.wav")
var glooby = preload("res://assets/sounds/music/glooby.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	playSong()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(!playing):
		playSong()

func playSong():
	var song = randi()%2
	match song:
		0:
			stream = wimdy
			volume_db = -40
		1:
			stream = glooby
			volume_db = -30
	playing = true
