class_name Eveloz
extends CharacterBody2D

@onready var ray_cast_2d = $RayCast2D
@export var move_speed = 300

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
var dead = false

@export var max_health = 2
var current_health = max_health

func take_damage(damage):
	current_health -= damage
	if current_health <= 0:
		die()

func die():
	if dead:
		return
	dead = true
	set_physics_process(false)
	$Estado/Vivo.hide()
	$Estado/Explosion.show()
	$Estado/Explosion.play("Explosion")
	await($Estado/Explosion.animation_finished)
	queue_free()




func _physics_process(delta):
	if dead:
		return
	
	var dir_to_player = global_position.direction_to(player.global_position)
	velocity = dir_to_player * move_speed
	move_and_slide()
	
	global_rotation = dir_to_player.angle() + PI/2.0
	
	if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() == player:
		player.kill()

func kill():
	if dead:
		return
	dead = true
	$DeathSound.play()
	$Estado/Muerto.show()
	$Estado/Vivo.hide()
	$CollisionShape2D.disabled = true
	z_index = -1
