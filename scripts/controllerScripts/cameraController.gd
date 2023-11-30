#Credit to https://www.youtube.com/watch?v=W7WsL3qaPqg

extends Camera2D

@export var move_speed = 30 # camera position lerp speed
@export var zoom_speed = 3.0  # camera zoom lerp speed
@export var min_zoom = 5.0  # camera won't zoom closer than this
@export var max_zoom = 0.5  # camera won't zoom farther than this
@export var margin = Vector2(400, 200)  # include some buffer area around targets
@export var yOffSet = 200

var targets = []

@export_node_path("Node") var P1: NodePath
@export_node_path("Node") var P2: NodePath

@onready var screen_size = get_viewport_rect().size

func _ready():
	targets.append(get_node(P1))
	targets.append(get_node(P2))

func _process(delta):
	if !targets:
		return

	# Keep the camera centered among all targets
	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	p.y -= yOffSet
	position = lerp(position, p, move_speed * delta)
	#position.y - yOffSet

	# Find the zoom that will contain all targets
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = 1 / clamp(r.size.x / screen_size.x, max_zoom, min_zoom)
	else:
		z = 1 / clamp(r.size.y / screen_size.y, max_zoom, min_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed * delta)
