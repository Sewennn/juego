extends Node
var active_enemies =[]

func _ready():
	var enemies = get_tree().get_nodes_in_group("Enemigos")
	for enemy in enemies:
		active_enemies.append(enemy)
func enemy_died(enemy):
	active_enemies.erase(enemy)
	check_spawn_boss()
func check_spawn_boss():
	if active_enemies.size() == 0:
		spawn_boss()
func spawn_boss():
	var MARIE = preload("res://Actores/marie.tscn")
	var boss = MARIE.instantiate()
	get_tree().root.add.child(boss)
	boss.global_position = Vector2(711,145)
