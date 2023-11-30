extends Node2D

@export var dialogue : String

var dialogueCalled = false

	
func _on_body_entered(body):

	if (body.is_in_group("player") && dialogueCalled == false):
		dialogueCalled = true
		DialogueManager.show_example_dialogue_balloon(load(dialogue))

		
