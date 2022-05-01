extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
var ACCELERATION = 2
var MAX_SPEED = 300
var motion = Vector2()
var isReadyToMove = false
var isMovingto = "right"
var lookingTime = 0.5
var isDead = false;
var life = 2
var damage = 2
var speed = 300
var isPilot = false
signal hurtTank
const JUMP_HEIGHT = -245

onready var patrol = get_parent()

export  (String, "Patrol", "Idle", "Shooter") var soliderType  = "Idle"


onready var sprite = get_node("Sprite")
onready var animationPlayer = get_node("AnimationPlayer")
# Called when the node enters the scene tree for the first time.


func _ready():
	pass

func _physics_process(delta):
	patrol(delta)
	
	if !isDead && !is_on_floor() && !isPilot:
		move_and_collide(Vector2(0, 10))
		
func _process(delta):
	#motion.y += GRAVITY
	move_and_collide(Vector2(0,10))
	
	if !isReadyToMove && !isDead:
		animationPlayer.play("Solider_Idle")
		
	if !isReadyToMove:
		motion.x = lerp(motion.x, 0, 0.4)
		
	if(isReadyToMove && !isDead):
		
		if(motion.x > 6):
			sprite.flip_h = false
			animationPlayer.play("Solider_Walk")
		elif (motion.x < -6):
			sprite.flip_h = true
			animationPlayer.play("Solider_Walk")
			
	motion = move_and_slide(motion, UP)


func patrol(delta):
	patrol.offset += delta * speed


func knockback(amount, positionX):
	motion.y = JUMP_HEIGHT*amount
	if positionX > self.position.x:
		sprite.flip_h = false
	if positionX < self.position.x:
		sprite.flip_h = true
	if (sprite.flip_h):
		motion.x = 100
	else:
		motion.x = -100

func stop():
	isReadyToMove = false

func  _on_Timer_timeout():
	if !isDead:
		isReadyToMove = true
	


func die():

	isDead = true
	self.queue_free()

func _on_TurningPointR_body_entered(body):
	if(body.is_in_group("Enemy")):
		stop()
		$Timer.start(lookingTime)
		isMovingto = "left"


func _on_TurningPointL_body_entered(body):
	if(body.is_in_group("Enemy")):
		stop()
		$Timer.start(lookingTime)
		isMovingto = "right"
