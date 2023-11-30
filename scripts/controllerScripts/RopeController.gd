#This script was a nightmare to figure out, so credit to lotts of places
#credit to https://www.youtube.com/watch?v=ZkDF3pmaIOo&t=213s for physics help
#credit to https://www.youtube.com/watch?v=FcnvwtyxLds for the appearence of the rope
#credit to ChatGPT for helping me convert above video to GDScript

extends Node2D

@export var ropeSegments : Array = []
@export var ropeSegLen : float = 2
@export var segmentLength : int = 35
@export var lineWidth : float = 10
@export var stiffness = 7

@export_node_path("Node") var P1: NodePath
@export_node_path("Node") var P2: NodePath

@export var MAX_DISTANCE = 500
@export var isCut = false

@onready var sceneManager = get_tree().get_root().get_node("World/sceneManager")
@onready var color

var lineRenderer : Line2D

var player1
var player2
var gravity

func _ready():	
	#get players as nodes
	player1 = get_node(P1)
	player2 = get_node(P2)
	gravity = player1.gravity
	
	color = sceneManager.color
	
	#set up line renderer
	lineRenderer = Line2D.new()
	lineRenderer.set_default_color(color)
	add_child(lineRenderer)

	#define start point
	var ropeStartPoint : Vector2 = Vector2(player1.position.x, player1.position.y - 50)

	#add rope segments according to var
	for i in range(segmentLength):
		ropeSegments.append(RopeSegment.new(ropeStartPoint))
		ropeStartPoint.y -= ropeSegLen

func _process(_delta):
	color = sceneManager.color
	lineRenderer.set_default_color(color)
	
	drawRope()
	
	var dp = (player1.position - player2.position).length()
	
	#Get input if rope has been cut
	if(Input.is_action_just_pressed("cutRope")):
		#if close enough, set isCut to !isCut	
		if(dp <= 500):
			isCut = !isCut
			lineRenderer.set_default_color(color)
			return
		#else, isCut = ttrue
		isCut = true
		
	#Draw ghost rope if close enough and rope is cut
	if(isCut && dp < 500):
		lineRenderer.set_default_color(Color(color, 0.5))
		
	if(isCut && dp > 500):
		#delete Rope from screen
		lineRenderer.points = []
		return
		
	

func _physics_process(_delta):
	if(!isCut):
		applyPhysics()
		
	if(Input.is_action_pressed("climb")):
		climbRope()
	simulate()

func simulate():
	#define gravity
	var forceGravity : Vector2 = Vector2(0, 100)

	#for each segment
	for i in range(1, segmentLength):
		#first segment = current segment
		var firstSegment : RopeSegment = ropeSegments[i]
		
		#find velocity AKA delta position
		var velocity : Vector2 = firstSegment.currentPos - firstSegment.oldPos
		
		#set old pos to current
		firstSegment.oldPos = firstSegment.currentPos
		
		#update current pos
		firstSegment.currentPos += velocity
		
		#get gravity
		firstSegment.currentPos += forceGravity * get_process_delta_time()
		
		#re-insert the modified segment
		ropeSegments[i] = firstSegment

	for i in range(stiffness):
		applyConstraint()

func applyConstraint():
	
	#get first segment
	var firstSegment : RopeSegment = ropeSegments[0]
	
	# Constraint to player position
	firstSegment.currentPos = Vector2(player1.position.x, player1.position.y - 50)
	ropeSegments[0] = firstSegment

	for i in range(segmentLength - 1):
		#find current and next segments
		var firstSeg : RopeSegment = ropeSegments[i]
		var secondSeg : RopeSegment = ropeSegments[i + 1]

		#calculate important vars
		var dist : float = (firstSeg.currentPos - secondSeg.currentPos).length()
		var error : float = abs(dist - ropeSegLen)
		var changeDir : Vector2 = Vector2()

		#if rope is stretched beyond desirable limit, make changedir track direction to correct stretch
		if dist > ropeSegLen:
			changeDir = (firstSeg.currentPos - secondSeg.currentPos).normalized()
		#same but for compression
		elif dist < ropeSegLen:
			changeDir = (secondSeg.currentPos - firstSeg.currentPos).normalized()

		#calculate approximation of how much to change to correct stretch / squash
		var changeAmount : Vector2 = changeDir * error
		#if its not the first segment
		if i != 0:
			#Correct current segment
			firstSeg.currentPos -= changeAmount * 0.5
			ropeSegments[i] = firstSeg
			#Correct next segment
			secondSeg.currentPos += changeAmount * 0.5
			ropeSegments[i + 1] = secondSeg
		else:
			#If it is the first, only adjust the second segment
			secondSeg.currentPos += changeAmount
			ropeSegments[i + 1] = secondSeg
			
		#Set last segment to attach to the player
		var lastSeg = ropeSegments[segmentLength - 1]
		lastSeg.currentPos = Vector2(player2.position.x, player2.position.y - 50)

func drawRope():
	lineRenderer.width = lineWidth

	#update rope positions to match rope segments
	var ropePositions : Array = []
	for i in range(segmentLength):
		ropePositions.append(ropeSegments[i].currentPos)

	#apply change
	lineRenderer.points = ropePositions

func applyPhysics():
	#Calculate requisite variables
	var dx = player1.position.x - player2.position.x
	var dy = player1.position.y - player2.position.y
	var distance = sqrt(dx*dx + dy*dy)
	var angle = atan2(dy, dx)
	var damping = 0.999
	var forceMult = 2	

	#Essentially, calculate force of tension, then resolve into x and y acceleration
	#its kind of black magic
	if distance >= MAX_DISTANCE:
		# Blue is anchored
		if player2.is_crouching:
			player1.velocity += forceMult * Vector2(-(gravity * dx) / distance, -gravity * sin(angle) * 1.1)
			player1.velocity *= damping
			return
		# Green is anchored
		if player1.is_crouching:
			player2.velocity -= forceMult * Vector2(-(gravity * dx) / distance, -gravity * sin(angle) * 1.1)
			player2.velocity *= damping
			return

		# Do the velocity
		player1.velocity += forceMult * Vector2(-(gravity * dx) / distance, -gravity * sin(angle) * 1.1)
		player2.velocity -= forceMult * Vector2(-(gravity * dx) / distance, -gravity * sin(angle) * 1.1)

		# Apply damping only to the swinging player
		player1.velocity *= damping
		player2.velocity *= damping

func climbRope():
	if(isCut):
		return
		
	#Calculate requisite variables
	var dx = player1.position.x - player2.position.x
	var dy = player1.position.y - player2.position.y
	var angle = atan2(dy, dx)
	#Climb Speed derived from a climb speed of 40 with 144 hz, now tied to physics update rather than framerate
	var maxClimbSpeed = 70
	
	if(player1.checkGround() && !player2.checkGround()):
		player2.velocity += Vector2(maxClimbSpeed * cos(angle), maxClimbSpeed * sin(angle))
		
	if(player2.checkGround() && !player1.checkGround()):
		player1.velocity -= Vector2(maxClimbSpeed * cos(angle), maxClimbSpeed * sin(angle))
#Class
class RopeSegment:
	var currentPos : Vector2
	var oldPos : Vector2

	func _init(pos):
		currentPos = pos
		oldPos = pos
