extends CharacterBody2D
const PLAYER_GROUP ="player"
@onready var ray_cast_2d = $RayCast2D
@onready var muzzle = $Muzzle
@onready var collision_shape = $CollisionShape2D  # Ajusta esto según el nodo de colisión de tu personaje
@export var move_speed = 320
@export var rotation_speed = 6.0  # Velocidad de rotación en radianes por segundo
var dead = false

func _ready():
	# Ajustar el punto de rotación al centro del triángulo
	add_to_group("player")
	global_position += Vector2(16, 16)  # Ajusta esto según las dimensiones de tu triángulo

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	if dead:
		return
	
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	
	# Solo rotar si el mouse no está sobre el personaje
	if not is_mouse_overlapping(mouse_position):
		var target_rotation = direction.angle()
		global_rotation = lerp_angle(global_rotation, target_rotation, rotation_speed * delta)
		muzzle.rotation = global_rotation  # Aseguramos que el Muzzle también rote correctamente
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	if dead:
		return
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_dir * move_speed
	move_and_slide()

func kill():
	if dead:
		return
	dead = true
	#$DeathSound.play()
	$Estado/Muerto.show()
	$Estado/Vivo.hide()
	$CanvasLayer/DeathScreen.show()
	z_index = -1

func restart():
	get_tree().reload_current_scene()

func shoot():
	var bala = preload("res://Actores/bala.tscn")
	var proyectil = bala.instantiate()
	proyectil.global_position = muzzle.global_position
	proyectil.rotation = global_rotation  # Alinea la rotación del proyectil con la del jugador
	proyectil.bullet_velocity = Vector2.RIGHT.rotated(proyectil.rotation) * proyectil.speed
	get_parent().add_child(proyectil)

func is_mouse_overlapping(mouse_position: Vector2) -> bool:
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		var extents = shape.extents
		var top_left = collision_shape.global_position - extents
		var bottom_right = collision_shape.global_position + extents
		return mouse_position.x > top_left.x and mouse_position.x < bottom_right.x and mouse_position.y > top_left.y and mouse_position.y < bottom_right.y
	return false
