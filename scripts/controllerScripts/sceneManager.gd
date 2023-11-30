extends Node2D

@onready var menu = preload("res://scenes/levels/menu.tscn")
@onready var house = preload("res://scenes/levels/house.tscn")
@onready var level1 = preload("res://scenes/levels/level1.tscn")
@onready var level2 = preload("res://scenes/levels/level2.tscn")
@onready var level3 = preload("res://scenes/levels/level3.tscn")
@onready var level4 = preload("res://scenes/levels/level4.tscn")
@onready var level5 = preload("res://scenes/levels/level5.tscn")
@onready var cabin = preload("res://scenes/levels/cabin.tscn")
@onready var credits = preload("res://scenes/levels/credits.tscn")

var color = "chocolate"

var currentScene

# Called when the node enters the scene tree for the first time.
func _ready():
	loadLevel("cabin")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("reset")):
		reload()
	
func reload():
	get_tree().call_group("player", "uncrouch")
	loadLevel(currentScene)
	
	
func loadLevel(levelName):
	currentScene = levelName

	# If no level exists, don't try to delete the current level
	if get_child_count() > 0:
		get_child(0).queue_free()

	# Create level, set its name (for future reference), then add it to the sceneManager node
	# Use call deferred to do it in next idle frame. It does something with avoiding conflict in the main thread
	match levelName:
		"quit":
			get_tree().quit()
			return
		"menu":
			call_deferred("add_child", menu.instantiate())
		"house":
			call_deferred("add_child", house.instantiate())
		"level1":
			call_deferred("add_child", level1.instantiate())
		"level2":
			call_deferred("add_child", level2.instantiate())
		"level3":
			call_deferred("add_child", level3.instantiate())
		"level4":
			call_deferred("add_child", level4.instantiate())
		"level5":
			call_deferred("add_child", level5.instantiate())
		"cabin":
			call_deferred("add_child", cabin.instantiate())
		"credits":
			call_deferred("add_child", credits.instantiate())
			
func setColor(newColor):
	color = newColor
	

