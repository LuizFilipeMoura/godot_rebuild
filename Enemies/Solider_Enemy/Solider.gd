extends KinematicBody2D

onready var patrol: PathFollow2D = get_parent() 
export  (String, "Patrol", "Idle", "Shooter") var soliderType  = "Idle"

var motion = Vector2()
export var direction = 1
var isDead = false;
export var life = 2
export var damage = 2
var speed = 150
const JUMP_HEIGHT = -245

onready var sprite = get_node("Sprite")
onready var animationPlayer = get_node("AnimationPlayer")
# Called when the node enters the scene tree for the first time.


func _ready():
	pass

func _physics_process(delta):
	if(soliderType == 'Patrol'):
		yield(get_tree().create_timer(.5), "timeout")
		animationPlayer.play("Solider_Walk")
		patrol(delta)
		
func _process(delta):
	#motion.y += GRAVITY
	move_and_collide(Vector2(0,10))


var changingDirection = false
func patrol(delta):
	var initialDirection = direction
	if(patrol.unit_offset == 1 || patrol.unit_offset == 0):
		direction = -direction
		animationPlayer.play("Solider_Idle")
		yield(get_tree().create_timer(.5), 'timeout')
		
	if(initialDirection != direction):
		if(direction>0):
			sprite.flip_h = false
		else:
			sprite.flip_h = true



		
	patrol.offset += delta * speed * direction
	


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



func die():
	isDead = true
	self.queue_free()

