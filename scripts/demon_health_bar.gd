extends ProgressBar


# var health_array
var demon
var demon_health_bar_mesh
var sword_hit_enemy
var sword_hit_dead_enemy
var player_body
var go_back_1
var health = 100
var progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	sword_hit_enemy = get_node("/root/Main/SwordHitEnemy")
	sword_hit_dead_enemy = get_node("/root/Main/SwordHitDeadEnemy")
	player_body = get_node("/root/Main/XROrigin3D")
	go_back_1 = get_node("/root/Main/OuterLand1/GoBack_1")
	demon = get_node("/root/Main/OuterLand1/Demon")
	demon_health_bar_mesh = get_node("/root/Main/OuterLand1/Demon/MeshInstance3D")

	# health_array = [100, 100]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.value = health

func _reset_progress():
	progress = 0


func _on_area_3d_body_entered(body:Node3D):
	print("In bar script, Hit with :", body.name)
	if body.name == "Demon":

		# If the enemy's health becomes 0, delete it.
		if health == 0:
			player_body.player_monster_collision = false
			demon._demon_delete()
			progress += 1
			
			if progress == 5:
				go_back_1.visible = true
				_reset_progress()
			else:
				demon._demon_recreate()
			
		# Enable sound effect when hitting the enemy
		sword_hit_enemy.playing = true
		
		# Initailly, the health bar is invisible. It will be invoked after the player hits the enemy at the first time.
		if demon_health_bar_mesh.visible == false:
			demon_health_bar_mesh.visible = true
			# demon_model_1.to_activate_monster.is_monster_activated = true
			demon.is_demon_activated = true
		else:
			health -= 10
			if health <= 0:
				health = 0
		
		# if health = 60, the health bar color becomes yellow
		if health == 60:
			var material_bar = demon_health_bar_mesh.material_override
			material_bar.albedo_color = Color(1, 1, 0)
		
		# if health = 30, the health bar color becomes red
		if health== 30:
			var material_bar = demon_health_bar_mesh.material_override
			material_bar.albedo_color = Color(1, 0, 0)
			
		# if health = 0, the health bar color becomes white
		if health == 0:
			var material_bar = demon_health_bar_mesh.material_override
			material_bar.albedo_color = Color(1, 1, 1)

	# elif body.name == "Demon2":

	# 	# If the enemy's health becomes 0, delete it.
	# 	if health_array[1] == 0:
	# 		player_body.player_monster_collision = false
	# 		player_body.monster_array[1]._monster_delete(1)
	# 		go_back_1.visible = true
			
	# 	# Enable sound effect when hitting the enemy
	# 	sword_hit_enemy.playing = true
		
	# 	# Initailly, the health bar is invisible. It will be invoked after the player hits the enemy at the first time.
	# 	if player_body.monster_health_bar_mesh_array[1].visible == false:
	# 		player_body.monster_health_bar_mesh_array[1].visible = true
	# 		player_body.is_monster_activated = true
	# 	else:
	# 		health_array[1] -= 10
	# 		if health_array[1] <= 0:
	# 			health_array[1] = 0
		
	# 	# if health = 60, the health bar color becomes yellow
	# 	if health_array[1] == 60:
	# 		var material_bar = player_body.monster_health_bar_mesh_array[1].material_override
	# 		material_bar.albedo_color = Color(1, 1, 0)
		
	# 	# if health = 30, the health bar color becomes red
	# 	if health_array[1] == 30:
	# 		var material_bar = player_body.monster_health_bar_mesh_array[1].material_override
	# 		material_bar.albedo_color = Color(1, 0, 0)
			
	# 	# if health = 0, the health bar color becomes white
	# 	if health_array[1] == 0:
	# 		var material_bar = player_body.monster_health_bar_mesh_array[1].material_override
	# 		material_bar.albedo_color = Color(1, 1, 1)
