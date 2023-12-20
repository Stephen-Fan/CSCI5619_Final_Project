extends ProgressBar


var health = 100
var progress = 0

var laser
var sword_hit_enemy
var laser_hit_enemy
var player_body
var goblin
var goblin_health_bar_mesh

var area_clear
var done
var submit
var mission_board
var mission_board_delete
var mode
var spatial_menu_scene


# Called when the node enters the scene tree for the first time.
func _ready():

	laser = get_node("/root/Main/XROrigin3D/RightController/LaserPointer")
	sword_hit_enemy = get_node("/root/Main/SwordHitEnemy")
	laser_hit_enemy = get_node("/root/Main/LaserHitEnemy")
	player_body = get_node("/root/Main/XROrigin3D")
	goblin = get_node("/root/Main/OuterLand2/Goblin")
	goblin_health_bar_mesh = get_node("/root/Main/OuterLand2/Goblin/GoblinHealth")
	area_clear = get_node("/root/Main/XROrigin3D/XRCamera3D/Death/MeshInstance3D/SubViewport/CanvasLayer/AreaClear")
	done = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Done")
	submit = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Submit")
	mission_board = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard")
	mission_board_delete = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Delete")
	mode = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard")
	spatial_menu_scene = get_node("/root/Main/SpatialMenu")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.value = health

# Reset the progress
func _reset_progress():
	progress = 0

# When the user completes the mission, this area is clear
func _area_clear_prompt():
	area_clear.visible = true
	await get_tree().create_timer(3).timeout
	area_clear.visible = false

# When the user defeats a monster or dies, update the progress on the board
func _update_mission_progress_on_board(num):
	# update the mission board
	done.text = str(progress)

	# if the user completes the mission, the submit button will appear
	if progress == num and num != 0:
		submit.visible = true

# Using sword to hit monsters
func _on_area_3d_body_entered(body:Node3D):
	if body.name == "Goblin":

		# If the enemy's health becomes 0, delete it.
		if health == 0:
			player_body.player_monster_collision = false
			player_body.damage_increment = 1.0
			goblin._goblin_delete()

			# If the user selects the mission, start to record the progress
			if mode.difficulty_mode == 2:
				progress += 1
				_update_mission_progress_on_board(mission_board.rand_num)
			
				# If the user completes the mission, stop generating monsters and clear the area. Otherwise, keep generating monsters
				if progress == mission_board.rand_num:
					mission_board_delete.visible = false
					_area_clear_prompt()
					_reset_progress()
				else:
					goblin._goblin_recreate()

			# Otherwise, keep generating monsters
			else:
				goblin._goblin_recreate()
			
		# Enable sound effect when hitting the enemy
		sword_hit_enemy.playing = true
		
		# Initailly, the health bar is invisible. It will be invoked after the player hits the enemy at the first time.
		if goblin_health_bar_mesh.visible == false:
			goblin_health_bar_mesh.visible = true
			goblin.is_goblin_activated = true

		# Derease monster's health when the user hits the monster
		else:
			health -= 10
			if health <= 0:
				health = 0
		
		# if health = 60, the health bar color becomes yellow
		if health == 60:
			var material_bar = goblin_health_bar_mesh.material_override
			material_bar.albedo_color = Color(1, 1, 0)
		
		# if health = 30, the health bar color becomes red
		if health== 30:
			var material_bar = goblin_health_bar_mesh.material_override
			material_bar.albedo_color = Color(1, 0, 0)
			
		# if health = 0, the health bar color becomes white
		if health == 0:
			var material_bar = goblin_health_bar_mesh.material_override
			material_bar.albedo_color = Color(1, 1, 1)

# Using laser beam to hit monsters
func _on_beam_body_entered(body:Node3D):
	if body.name == "Goblin":

		# If the enemy's health becomes 0, delete it.
		if health == 0:
			player_body.player_monster_collision = false
			player_body.damage_increment = 1.0
			goblin._goblin_delete()

			# If the user selects the mission, start to record the progress
			if mode.difficulty_mode == 2:
				progress += 1
				_update_mission_progress_on_board(mission_board.rand_num)
			
				# If the user completes the mission, stop generating monsters and clear the area. Otherwise, keep generating monsters
				if progress == mission_board.rand_num:
					mission_board_delete.visible = false
					_area_clear_prompt()
					_reset_progress()
				else:
					goblin._goblin_recreate()

			# Otherwise, keep generating monsters
			else:
				goblin._goblin_recreate()
			

		if laser.visible == true and spatial_menu_scene.is_laser_activated:
			# Enable sound effect when hitting the enemy
			laser_hit_enemy.playing = true
			
			# Initailly, the health bar is invisible. It will be invoked after the player hits the enemy at the first time.
			if goblin_health_bar_mesh.visible == false:
				goblin_health_bar_mesh.visible = true
				goblin.is_goblin_activated = true

			# Derease monster's health when the user hits the monster
			else:
				
				health -= health*0.1
				if health <= 0:
					health = 0
			
			# if health = 60, the health bar color becomes yellow
			if health == 60:
				var material_bar = goblin_health_bar_mesh.material_override
				material_bar.albedo_color = Color(1, 1, 0)
			
			# if health = 30, the health bar color becomes red
			if health== 30:
				var material_bar = goblin_health_bar_mesh.material_override
				material_bar.albedo_color = Color(1, 0, 0)
				
			# if health = 0, the health bar color becomes white
			if health == 0:
				var material_bar = goblin_health_bar_mesh.material_override
				material_bar.albedo_color = Color(1, 1, 1)
