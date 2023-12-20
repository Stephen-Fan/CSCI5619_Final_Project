extends Node3D

@export var move_speed := 5
@export var move_dead_zone := 0.2

@export var smooth_turn_speed := 45
@export var smooth_turn_dead_zone := 0.2
@export var snap_turn_speed:= 45.0
@export var snap_turn_threshold := 0.9

var input_vector = Vector2.ZERO
var snap_rotation_ready = true
var player_monster_collision = false

# var fountain
var portal1_1
var portal2_1
var portal3_1
var portal2
var portal3
var outer_land_1
var outer_land_2
var outer_land_3
var cd
var cd_2
var cd_3
var cd_back_1
var cd_back_2
var cd_back_3
var go_back_1
var go_back_2
var go_back_3
var sword
var player_health_bar
var player_health_bar_mesh
var demon
var goblin
var giants

var death_board
var death_board_lose
var death_board_back_info
var done
# var death_board_count_down
var health = 100
var damage_increment = 1.0

var count_down_menu_1
var count_down_menu_back_1
var count_down_menu_back_2
var count_down_menu_back_3
var count_down_menu_2
var count_down_menu_3

var demon_health_bar_scene
var goblin_health_bar_scene
var giants_health_bar_scene

var is_monster_activated = false
var monster_code = 0	# demon: 1, goblin: 2, giants: 3

# Called when the node enters the scene tree for the first time.
func _ready():
	portal1_1 = get_node("/root/Main/OuterLand1/Portal1_1")
	portal2_1 = get_node("/root/Main/OuterLand2/Portal2_1")
	portal3_1 = get_node("/root/Main/OuterLand3/Portal3_1")
	portal2 = get_node("/root/Main/Portal2")
	portal3 = get_node("/root/Main/Portal3")
	outer_land_1 = get_node("/root/Main/OuterLand1")
	outer_land_2 = get_node("/root/Main/OuterLand2")
	outer_land_3 = get_node("/root/Main/OuterLand3")

	cd = get_node("/root/Main/CountDown/Plane/SubViewport/CanvasLayer/CD")
	cd_2 = get_node("/root/Main/CountDown2/Plane/SubViewport/CanvasLayer/CD")
	cd_3 = get_node("/root/Main/CountDown3/Plane/SubViewport/CanvasLayer/CD")
	cd_back_1 = get_node("/root/Main/OuterLand1/CountDown_1/Plane_1/SubViewport/CanvasLayer/CD_1")
	cd_back_2 = get_node("/root/Main/OuterLand2/CountDown_2_1/Plane_2/SubViewport/CanvasLayer/CD_2")
	cd_back_3 = get_node("/root/Main/OuterLand3/CountDown_3_1/Plane_3/SubViewport/CanvasLayer/CD_3")
	count_down_menu_1 = get_node("/root/Main/CountDown")
	go_back_1 = get_node("/root/Main/OuterLand1/GoBack_1")
	go_back_2 = get_node("/root/Main/OuterLand2/GoBack_2")
	go_back_3 = get_node("/root/Main/OuterLand3/GoBack_3")
	count_down_menu_back_1 = get_node("/root/Main/OuterLand1/CountDown_1")
	count_down_menu_back_2 = get_node("/root/Main/OuterLand2/CountDown_2_1")
	count_down_menu_back_3 = get_node("/root/Main/OuterLand3/CountDown_3_1")
	count_down_menu_2 = get_node("/root/Main/CountDown2")
	count_down_menu_3 = get_node("/root/Main/CountDown3")

	sword = get_node("/root/Main/Tables/PickableSword")

	player_health_bar = get_node("/root/Main/XROrigin3D/XRCamera3D/PlayerHealthBar/HealthBar/SubViewport/Control/ProgressBar")
	player_health_bar_mesh = get_node("/root/Main/XROrigin3D/XRCamera3D/PlayerHealthBar")

	demon = get_node("/root/Main/OuterLand1/Demon")
	demon_health_bar_scene = get_node("/root/Main/OuterLand1/Demon/MeshInstance3D/HealthBar/SubViewport/Control/DemonHealthBar")

	goblin = get_node("/root/Main/OuterLand2/Goblin")
	goblin_health_bar_scene = get_node("/root/Main/OuterLand2/Goblin/GoblinHealth/SubViewportContainer/SubViewport/Control/GoblinHealthBar")

	giants = get_node("/root/Main/OuterLand3/Giants")
	giants_health_bar_scene = get_node("/root/Main/OuterLand3/Giants/GiantsHealthBar/SubViewportContainer/SubViewport/Control/GiantsHealthBar")

	death_board = get_node("/root/Main/XROrigin3D/XRCamera3D/Death")
	death_board_lose = get_node("/root/Main/XROrigin3D/XRCamera3D/Death/MeshInstance3D/SubViewport/CanvasLayer/Lose")
	death_board_back_info = get_node("/root/Main/XROrigin3D/XRCamera3D/Death/MeshInstance3D/SubViewport/CanvasLayer/BackInfo")
	
	done = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Done")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# keep updating player's HP
	player_health_bar.value = health

# When the user is dead, delete the current monster.
func _delete_monster_when_player_dead():
	if monster_code == 1:
		demon._demon_delete()
	elif monster_code == 2:
		goblin._goblin_delete()
	elif monster_code == 3:
		giants._giants_delete()


func _player_death_and_resurrection():

	# Delete the monster and show the resurrection information
	_delete_monster_when_player_dead()
	done.text = "0"
	player_health_bar_mesh.visible = false
	death_board.visible = true
	death_board_lose.visible = true
	await get_tree().create_timer(2).timeout
	death_board_lose.visible = false
	death_board_back_info.visible = true
	await get_tree().create_timer(1).timeout
	death_board_back_info.text = "You will be sent back to the main base in 2 seconds."
	await get_tree().create_timer(1).timeout
	death_board_back_info.text = "You will be sent back to the main base in 1 seconds."
	await get_tree().create_timer(1).timeout
	death_board_back_info.text = "You will be sent back to the main base in 0 seconds."
	await get_tree().create_timer(1).timeout
	
	# Resurrection
	monster_code = 0
	self.global_position = Vector3(0,0,0)
	outer_land_1.visible = false
	outer_land_2.visible = false
	outer_land_3.visible = false
	player_health_bar_mesh.visible = true
	health = 5
	
	# Reset the death prompt board
	death_board_back_info.text = "You will be sent back to the main base in 3 seconds."
	death_board_back_info.visible = false

	# Restore_health
	while health < 100:
		await get_tree().create_timer(0.1).timeout
		health += 3

		if health >= 100:
			health = 100

	# Re-create monsters when player leaves that land
	demon._demon_recreate()
	demon_health_bar_scene._reset_progress()

	goblin._goblin_recreate()
	goblin_health_bar_scene._reset_progress()
	
	giants._giants_recreate()
	giants_health_bar_scene._reset_progress()


func _process_input(input_name: String, input_value: Vector2):
	if input_name == "primary":
		self.input_vector = input_value

# Generate a random number
func get_random_number(a: int, b: int):
	return randi_range(a, b)


func _on_area_3d_body_entered(body:Node3D):
	# print("Collision with ", body.name)

	# set up a count down when teleport to the battle filed
	if body.name == "Portal1":
		count_down_menu_1.visible = true

		cd.visible = true
		await get_tree().create_timer(1).timeout
		cd.text = "2"
		await get_tree().create_timer(1).timeout
		cd.text = "1"
		await get_tree().create_timer(1).timeout
		cd.text = "GO!"

		await get_tree().create_timer(1).timeout
		outer_land_1.visible = true
		self.global_position = portal1_1.global_transform.origin + Vector3(0,0,-3)

		count_down_menu_1.visible = false
		cd.visible = false
		cd.text = "3"
		go_back_1.collision_layer = 0b00000001

	# set up a count down when teleport to the battle filed
	elif body.name == "Portal2":
		count_down_menu_2.visible = true

		cd_2.visible = true
		await get_tree().create_timer(1).timeout
		cd_2.text = "2"
		await get_tree().create_timer(1).timeout
		cd_2.text = "1"
		await get_tree().create_timer(1).timeout
		cd_2.text = "GO!"

		await get_tree().create_timer(1).timeout
		outer_land_2.visible = true
		self.global_position = portal2_1.global_transform.origin + Vector3(0,0,-3)

		count_down_menu_2.visible = false
		cd_2.visible = false
		cd_2.text = "3"
		go_back_2.collision_layer = 0b00000001

	# set up a count down when teleport to the battle filed
	elif body.name == "Portal3":
		count_down_menu_3.visible = true

		cd_3.visible = true
		await get_tree().create_timer(1).timeout
		cd_3.text = "2"
		await get_tree().create_timer(1).timeout
		cd_3.text = "1"
		await get_tree().create_timer(1).timeout
		cd_3.text = "GO!"

		await get_tree().create_timer(1).timeout
		outer_land_3.visible = true
		self.global_position = portal3_1.global_transform.origin + Vector3(0,0,-3)

		count_down_menu_3.visible = false
		cd_3.visible = false
		cd_3.text = "3"
		go_back_3.collision_layer = 0b00000001

	# set up a count down when teleport back to the main base
	elif body.name == "GoBack_1":
		if go_back_1.visible:
			count_down_menu_back_1.visible = true

			cd_back_1.visible = true
			await get_tree().create_timer(1).timeout
			cd_back_1.text = "2"
			await get_tree().create_timer(1).timeout
			cd_back_1.text = "1"
			await get_tree().create_timer(1).timeout
			cd_back_1.text = "0"

			await get_tree().create_timer(1).timeout

			self.global_position = Vector3(0,0,0)
			cd_back_1.visible = false
			cd_back_1.text = "3"
			count_down_menu_back_1.visible = false
			outer_land_1.visible = false
				
			# Restore_health
			while health < 100:
				await get_tree().create_timer(0.1).timeout
				health += 1
				if health >= 100:
					health = 100

		# Re-create monsters when player leaves that land
		demon._demon_recreate()

		# When the outerland 1 is clear, unlock the outerland 2
		portal2.visible = true

	# set up a count down when teleport back to the main base
	elif body.name == "GoBack_2":
		if go_back_2.visible:
			count_down_menu_back_2.visible = true

			cd_back_2.visible = true
			await get_tree().create_timer(1).timeout
			cd_back_2.text = "2"
			await get_tree().create_timer(1).timeout
			cd_back_2.text = "1"
			await get_tree().create_timer(1).timeout
			cd_back_2.text = "0"

			await get_tree().create_timer(1).timeout

			self.global_position = Vector3(0,0,0)
			cd_back_2.visible = false
			cd_back_2.text = "3"
			count_down_menu_back_2.visible = false
			outer_land_2.visible = false
				
			# Restore_health
			while health < 100:
				await get_tree().create_timer(0.1).timeout
				health += 1
				if health >= 100:
					health = 100

		# Re-create monsters when player leaves that land
		goblin._goblin_recreate()

		# When the outerland 2 is clear, unlock the outerland 3
		portal3.visible = true

	# set up a count down when teleport back to the main base
	elif body.name == "GoBack_3":
		if go_back_3.visible:
			count_down_menu_back_3.visible = true

			cd_back_3.visible = true
			await get_tree().create_timer(1).timeout
			cd_back_3.text = "2"
			await get_tree().create_timer(1).timeout
			cd_back_3.text = "1"
			await get_tree().create_timer(1).timeout
			cd_back_3.text = "0"

			await get_tree().create_timer(1).timeout

			self.global_position = Vector3(0,0,0)
			cd_back_3.visible = false
			cd_back_3.text = "3"
			count_down_menu_back_3.visible = false
			outer_land_3.visible = false
				
			# Restore_health
			while health < 100:
				await get_tree().create_timer(0.1).timeout
				health += 1
				if health >= 100:
					health = 100

		# Re-create monsters when player leaves that land
		giants._giants_recreate()

	# When the user's body collides with the monster, decrease user's HP continously until the user defeats the mosnter
	elif body.name == "Demon":
		player_monster_collision = true
		monster_code = 1

		while player_monster_collision:
			await get_tree().create_timer(1).timeout
			health -= 1

			# If user's HP is <= 0, the user will die and rebirth
			if health <= 0:
				health = 0
				player_monster_collision = false
				_player_death_and_resurrection()

	# When the user's body collides with the monster, decrease user's HP continously until the user defeats the mosnter
	elif body.name == "Goblin":
		player_monster_collision = true
		monster_code = 2

		while player_monster_collision:
			await get_tree().create_timer(0.1).timeout
			damage_increment += 1
			health -= 0.01 * damage_increment

			# If user's HP is <= 0, the user will die and rebirth
			if health <= 0:
				health = 0
				damage_increment = 0
				player_monster_collision = false
				_player_death_and_resurrection()

	# When the user's body collides with the monster, decrease user's HP continously until the user defeats the mosnter			
	elif body.name == "Giants":
		player_monster_collision = true
		monster_code = 3

		while player_monster_collision:
			await get_tree().create_timer(1).timeout
			var rand = get_random_number(1, 30)
			health -= rand

			# If user's HP is <= 0, the user will die and rebirth
			if health <= 0:
				health = 0
				damage_increment = 0
				player_monster_collision = false
				_player_death_and_resurrection()			
