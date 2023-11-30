#Credit to https://www.youtube.com/watch?v=JEQR4ALlwVU
extends CanvasLayer

var paused

@onready var sceneManager = get_tree().get_root().get_node("World/sceneManager")
@onready var levelMenu = $CenterContainer/BoxContainer/levelContainer/MenuButton
# Called when the node enters the scene tree for the first time.
func _ready():
	levelMenu.get_popup().id_pressed.connect(_on_item_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		pause_menu()
		
func pause_menu():
	if paused:
		hide()
		Engine.time_scale = 1
	else:
		show()
		Engine.time_scale = 0
		
	paused = !paused
	
func _on_resume_pressed():
	pause_menu()


func _on_restart_level_pressed():
	pause_menu()
	sceneManager.reload()


func _on_menu_pressed():
	pause_menu()
	sceneManager.loadLevel("menu")


func _on_rope_color_color_changed(color):
	sceneManager.setColor(color)
	
func _on_item_pressed(id):
	pause_menu()
	sceneManager.loadLevel("level"+str(id+1))


func _on_credits_pressed():
	pause_menu()
	sceneManager.loadLevel("credits")
