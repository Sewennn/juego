extends Node2D
var speed = 300
var direction = Vector2.ZERO
const jugador = preload("res://Actores/Jugador.tscn")
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var ray_cast_2d = $RayCast2D


func _ready():
	await get_tree().create_timer(6.0).timeout
	queue_free()

func _process(delta):
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta
func set_direction(to_player: Vector2):
	direction = to_player.normalized()

func _physics_process(delta):
	if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() == player:
			player.kill()
