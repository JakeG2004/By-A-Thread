extends Area2D

var sceneManager
@export var Destination : String

# Called when the node enters the scene tree for the first time.
func _ready():
	sceneManager = get_tree().get_root().get_node("World/sceneManager")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		sceneManager.loadLevel(Destination)
