extends KinematicBody2D


# Declare member variables here. Examples:
var velocidade = 100;
var aceleracao = Vector2();
var pulo = -350;
var gravidade = 15;
var ta_no_chao = false;
var chao = Vector2(0, -1)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("walk_right") && !Input.is_action_pressed("walk_left"):
		aceleracao.x = velocidade;
	elif Input.is_action_pressed("walk_left")&& !Input.is_action_pressed("walk_right"):
		aceleracao.x = -velocidade;
	else:
		aceleracao.x = 0;
	if Input.is_action_pressed("jump") && ta_no_chao:
		aceleracao.y = pulo;
	if Input.is_action_pressed("attack"):
		$AnimationPlayer.play("Attack");
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("RESET")
	if is_on_floor():
		ta_no_chao = true;
	else:
		ta_no_chao = false;
	aceleracao.y += gravidade;
	aceleracao = move_and_slide(aceleracao, chao);
	pass;


func _on_AttackArea_area_entered(area):

	pass # Replace with function body.
