#Credit to https://www.youtube.com/watch?v=Lf1_Zru0ToM&t=395s

extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset.x -= 40 * delta
