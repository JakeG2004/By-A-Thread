extends Node2D

@export var dialogue : String

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.show_example_dialogue_balloon(load(dialogue))

		
