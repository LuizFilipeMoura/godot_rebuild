extends KinematicBody2D

onready var patrolPath: PathFollow2D = get_parent() 
export  (String, "Patrol", "Idle", "Shooter") var soliderType  = "Idle"

var Player = null

var motion = Vector2()
export var direction = 1
var isDead = false;
export var life = 2
export var damage = 2
var speed = 50
const JUMP_HEIGHT = -245

var isShooting = false
var canPatrol = true

onready var sprite = get_node("Sprite")
onready var animationPlayer = get_node("AnimationPlayer")
onready var BULLET_SCENE = preload("res://Skills/Bullet/Bullet.tscn")
# Called when the node enters the scene tree for the first time.


func _ready():
	Player = get_parent().get_parent().get_node("Player")
	pass

func _physics_process(delta):
	if(soliderType == 'Patrol' && canPatrol):
		yield(get_tree().create_timer(.5), "timeout")
		if(canPatrol):
			animationPlayer.play("Solider_Walk")
			print('aqui?', canPatrol)
			patrol(delta)
		
func _process(delta):
	#motion.y += GRAVITY
	move_and_collide(Vector2(0,10))


var changingDirection = false
func patrol(delta):
	var initialDirection = direction
	if(patrolPath.unit_offset == 1 || patrolPath.unit_offset == 0):
		direction = -direction
		animationPlayer.play("Solider_Idle")
		yield(get_tree().create_timer(.5), 'timeout')
		
	if(initialDirection != direction):
		if(direction>0):
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	patrolPath.offset += delta * speed * direction
	


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

func shoot():
	var bullet = BULLET_SCENE.instance()
	bullet.position = Vector2($Gun.get_global_position().x, $Gun.get_global_position().y)
	bullet.scale = Vector2(0.8, 0.6)
	bullet.Player = Player
	bullet.speed = 2.5
	bullet.damage = 2
	bullet.shakeAmout = [0.5, 5, 2]
	get_parent().add_child(bullet)
	pass


func die():
	isDead = true
	self.queue_free()


func _on_PlayerDetector_body_entered(body):
	animationPlayer.stop()
	if(body.is_in_group("Player")):
		animationPlayer.play("Solider_Shooting")
		isShooting = true
		canPatrol = false
		print()
	pass # Replace with function body.


func _on_PlayerDetector_body_exited(body):
	if(body.is_in_group("Player")):
		isShooting = false
		canPatrol = true
	pass # Replace with function body.
