#Credit to https://www.youtube.com/watch?v=9u6edV5-EEI
extends CharacterBody2D

#Editable vars
@export var speed = 30
@export var gravity = 30
@export var max_gravity = 1000
@export var jump_force = 700
@export var friction = 5
@export var max_speed = 1000
@export var is_crouching = false
@export var gcRadius = 5

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

var grounded

var horizontal_acceleration

var groundRay = RayCast2D.new()

func _ready():
	velocity.x = 0
	add_child(groundRay)

func _physics_process(_delta):
	grounded = checkGround()
	
	#Handle gravity
	if(!grounded):
			velocity.y += gravity
			if(velocity.y > max_gravity):
				velocity.y = max_gravity
	
	#Jump logic
	if(Input.is_action_just_pressed("gjump") && grounded && !is_crouching):
		velocity.y = -jump_force
		get_node("soundPlayer").playJump()
		
	#Horizontal movement
	var horizontal_direction = Input.get_axis("gleft", "gright")
	horizontal_acceleration = (horizontal_direction * speed)
	
	#Set velocity
	velocity.x += (horizontal_acceleration)
	
	#Change sprite direction
	if(horizontal_direction != 0):
		sprite.flip_h = (horizontal_direction == -1)
		
	#Crouch
	if (Input.is_action_just_pressed("gcrouch") && grounded):
		crouch()
		
	#Lock on crouch
	if(is_crouching):
		horizontal_acceleration = 0
		velocity.x = 0
	
	#subtract friction
	if(velocity.x > 0):
		velocity.x -= friction
	if(velocity.x < 0):
		velocity.x += friction
		
	#cap speed
	if(velocity.x > max_speed):
		velocity.x = max_speed
	if(velocity.x < -max_speed):
		velocity.x = -max_speed
			
	#set animations
	update_animations()
		
	#move player
	move_and_slide()
	
func update_animations():
	
	#Set ground animations
	if(checkGround()):
		if(horizontal_acceleration == 0):
			if(is_crouching):
				ap.play("green_crouch")
			else:
				ap.play("green_idle")
		else:
			ap.play("green_run")
	#Jump animation
	else:
		ap.play("green_jump")
		
func crouch():
	if(is_crouching):
		is_crouching = false
		$CollisionShape2D.shape.extents = Vector2(20, 8)
		$CollisionShape2D.position = Vector2(0,-8)
		return
	is_crouching = true
	$CollisionShape2D.shape.extents = Vector2(20, 7)
	$CollisionShape2D.position = Vector2(0,-7)
	
func stop():
	velocity = Vector2(0, 0)
	horizontal_acceleration = 0
	
func checkGround():
	groundRay.force_raycast_update()
	var collision_point = groundRay.get_collision_point()
	
	if (groundRay.is_colliding() && (collision_point.y - position.y < gcRadius)):
		return true
	
	
	return is_on_floor()


func uncrouch():
	grounded = false
	is_crouching = false
