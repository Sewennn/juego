extends CharacterBody2D
#class_name marie
@onready var animated_sprite_2d = $AnimatedSprite2D
var bullet_scene = preload("res://Actores/bullet.tscn")
@onready var timer = $Timer
@onready var collision_shape_2d = $CollisionShape2D

const speed = 200
var is_alive:bool = true
var taking_damage: bool = false
var dir: Vector2
var attack_patterns = []
@export var max_health = 50
var current_health = max_health

func _ready():
	timer.start()
	attack_patterns = [spawn_shotgun_pattern,spawn_single_pattern,spawn_spiral_pattern]
	
func _process(delta):
	move(delta)
	move_and_slide()
	
func move(delta):
	if is_alive:
		velocity += dir * speed * delta
	elif !is_alive:
		velocity.x = 0
		queue_free()
func take_damage(damage):
	current_health -= damage
	if current_health <= 0:
		is_alive = false

func spawn_spiral_pattern():
	var angle = 0
	for i in range(20):
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		var to_player = get_direction_to_player()
		bullet.global_position = global_position
		bullet.rotation = angle
		angle += PI / 10

func spawn_shotgun_pattern():
	var num_bullets = 20
	var angle_offset = PI / 16 
	for i in range(num_bullets):
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		var to_player = get_direction_to_player()
		var angle = to_player.angle() + randf_range(-angle_offset, angle_offset)
		bullet.global_position = global_position
		bullet.rotation = angle

func spawn_single_pattern():
	var delay = 0.2
	for i in range(20):
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		var to_player = get_direction_to_player()
		var angle = to_player.angle()
		bullet.global_position = global_position
		bullet.rotation = angle
		await(get_tree().create_timer(delay).timeout)


func _on_timer_timeout():
	print("deberia disparar")
	var chosen_attack = choose(attack_patterns)
	animated_sprite_2d.play("attack")
	chosen_attack.call()

func choose(array):
	array.shuffle()
	return array.front()

func _on_movement_timeout():
	print("deberia moverse")
	$movement.wait_time = choose([1.0,1.5,2.0])
	if is_alive:
		dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN, Vector2(1, 1).normalized(), Vector2(1, -1).normalized(), Vector2(-1, 1).normalized(), Vector2(-1, -1).normalized()])
		animated_sprite_2d.play("idle")

func get_direction_to_player() -> Vector2:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		return player.global_position - global_position
	return Vector2.ZERO
