extends CharacterBody2D

@export var speed = 400
@export var damage = 2
var bullet_velocity = Vector2.ZERO

func _ready():
	# Opcional: agrega una cola para la vida útil de la bala
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta):
	var collision = move_and_collide(bullet_velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage)
		$Node2D/AnimatedSprite2D.play("impacto")
		set_physics_process(false)
		await ($Node2D/AnimatedSprite2D.animation_finished)	
		
		queue_free()

func _on_CollisionShape2D_area_entered(area):
	# Si la bala entra en contacto con un área, destrúyela
	queue_free()
