extends KinematicBody2D


# Declare member variables here. Examples:
var velocidade = 275;
var aceleracao = Vector2();
var pulo = -350;
var gravidade = 15;
var chao = Vector2(0, -1)

onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	if(aceleracao.x > 0):
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	if Input.is_action_pressed("walk_right") && !Input.is_action_pressed("walk_left"):
		aceleracao.x = velocidade;
	elif Input.is_action_pressed("walk_left")&& !Input.is_action_pressed("walk_right"):
		aceleracao.x = -velocidade;
	else:
		aceleracao.x = 0;
		
	if Input.is_action_pressed("jump") && is_on_floor():
		aceleracao.y = pulo;
		
	if Input.is_action_pressed("attack"):
		$AnimationPlayer.play("Attack");
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("RESET")

	aceleracao.y += gravidade;
	aceleracao = move_and_slide(aceleracao, chao);
	pass;


func _on_AttackArea_area_entered(area):
	pass # Replace with function body.


func _on_Area2D_body_entered(area):
	die()
	pass # Replace with function body.


func die():
	aceleracao = Vector2(0, 0)
	position.x = 0
	position.y = 0

