extends Node3D

@export var move_speed := 5
@export var move_dead_zone := 0.2

# @export var smooth_turn_speed := 45
# @export var smooth_turn_dead_zone := 0.2
@export var snap_turn_speed:= 45.0
@export var snap_turn_threshold := 0.9

var input_vector = Vector2.ZERO
var snap_rotation_ready = true
var player_monster_collision = false

var portal1_1
var portal2_1
var portal2
var outer_land_1
var outer_land_2
var cd
var cd_2
var cd_back_1
var cd_back_2
var go_back_1
var go_back_2
var sword
var player_health_bar
var player_health_bar_mesh
var demon

var death_board
var death_board_lose
var death_board_back_info
var death_board_count_down
var health = 100

var count_down_menu_1
var count_down_menu_back_1
var count_down_menu_back_2
var count_down_menu_2

var demon_health_bar_scene

var is_monster_activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	portal1_1 = get_node("/root/Main/OuterLand1/Portal1_1")
	portal2_1 = get_node("/root/Main/OuterLand2/Portal2_1")
	portal2 = get_node("/root/Main/Portal2")
	outer_land_1 = get_node("/root/Main/OuterLand1")
	outer_land_2 = get_node("/root/Main/OuterLand2")

	cd = get_node("/root/Main/CountDown/Plane/SubViewport/CanvasLayer/CD")
	cd_2 = get_node("/root/Main/CountDown2/Plane/SubViewport/CanvasLayer/CD")
	cd_back_1 = get_node("/root/Main/OuterLand1/CountDown_1/Plane_1/SubViewport/CanvasLayer/CD_1")
	cd_back_2 = get_node("/root/Main/OuterLand2/CountDown_2_1/Plane_2/SubViewport/CanvasLayer/CD_2")
	count_down_menu_1 = get_node("/root/Main/CountDown")
	go_back_1 = get_node("/root/Main/OuterLand1/GoBack_1")
	go_back_2 = get_node("/root/Main/OuterLand2/GoBack_2")
	count_down_menu_back_1 = get_node("/root/Main/OuterLand1/CountDown_1")
	count_down_menu_back_2 = get_node("/root/Main/OuterLand2/CountDown_2_1")
	count_down_menu_2 = get_node("/root/Main/CountDown2")

	sword = get_node("/root/Main/Tables/PickableSword")

	player_health_bar = get_node("/root/Main/XROrigin3D/XRCamera3D/PlayerHealthBar/HealthBar/SubViewport/Control/ProgressBar")
	player_health_bar_mesh = get_node("/root/Main/XROrigin3D/XRCamera3D/PlayerHealthBar")

	demon = get_node("/root/Main/OuterLand1/Demon")
	demon_health_bar_scene = get_node("/root/Main/OuterLand1/Demon/MeshInstance3D/HealthBar/SubViewport/Control/DemonHealthBar")

	death_board = get_node("/root/Main/XROrigin3D/XRCamera3D/Death")
	death_board_lose = get_node("/root/Main/XROrigin3D/XRCamera3D/Death/MeshInstance3D/SubViewport/CanvasLayer/Lose")
	death_board_back_info = get_node("/root/Main/XROrigin3D/XRCamera3D/Death/MeshInstance3D/SubViewport/CanvasLayer/BackInfo")
	death_board_count_down = get_node("/root/Main/XROrigin3D/XRCamera3D/Death/MeshInstance3D/SubViewport/CanvasLayer/BackCD")
	# player_camera = get_node("/root/Main/XROrigin3D/XRCamera3D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	# Forward translation
	# if self.input_vector.y > self.move_dead_zone || self.input_vector.y < -self.move_dead_zone:
	# 	var movement_vector = Vector3(0, 0, -self.input_vector.y * self.move_speed * delta)
	# 	self.position += movement_vector.rotated(Vector3.UP, $XRCamera3D.global_rotation.y)

	# if snap_rotation_ready and (self.input_vector.x > snap_turn_threshold or self.input_vector.x < -snap_turn_threshold):
	# 	self.rotate(Vector3.UP, deg_to_rad(snap_turn_speed) * sign(self.input_vector.x) * -1)
	# 	snap_rotation_ready = false

	# # The thumbstick should go back to the center before it can snap turn again
	# elif abs(self.input_vector.x) < snap_turn_threshold:
	# 	snap_rotation_ready = true
	
	# if self.input_vector.x > self.smooth_turn_dead_zone || self.input_vector.x < -self.smooth_turn_dead_zone:
	# 	self.translate($XRCamera3D.position)
	# 	self.rotate_y(deg_to_rad(-self.input_vector.x * self.smooth_turn_speed * delta))
	# 	self.translate(-$XRCamera3D.position)


	# if the monster collides with the player, player's HP will be dereasing every second until they player defeats the monster
	if player_monster_collision:
		if demon.visible:
			await get_tree().create_timer(1).timeout
			health -= 0.01

	# keep updating player's HP
	player_health_bar.value = health

	# if player's HP becomes 0, then player dies
	if health == 0:
		_player_death_and_resurrection()


func _player_death_and_resurrection():
	# Delete the monster and show the resurrection information
	demon._demon_delete()
	player_health_bar_mesh.visible = false
	death_board.visible = true
	death_board_lose.visible = true
	await get_tree().create_timer(2).timeout
	death_board_lose.visible = false
	death_board_back_info.visible = true
	await get_tree().create_timer(3).timeout
	death_board_back_info.visible = false
	death_board_count_down.visible = true
	await get_tree().create_timer(1).timeout
	death_board_count_down.text = "2"
	await get_tree().create_timer(1).timeout
	death_board_count_down.text = "1"
	await get_tree().create_timer(1).timeout
	death_board_count_down.text = "0"
	await get_tree().create_timer(1).timeout

	# Resurrection
	player_monster_collision = false
	self.global_position = Vector3(0,0,0)
	outer_land_1.visible = false
	player_health_bar_mesh.visible = true
	health = 5

	# Reset death board info
	death_board.visible = false
	death_board_lose.visible = false
	death_board_back_info.visible = false
	death_board_count_down.visible = false
	death_board_count_down.text = "3"


	# Restore_health
	while health < 100:
		await get_tree().create_timer(0.1).timeout
		health += 1
		if health >= 100:
			health = 100

	# Re-create monsters when player leaves that land
	demon._demon_recreate()
	demon_health_bar_scene._reset_progress()
	
	

func _process_input(input_name: String, input_value: Vector2):
	if input_name == "primary":
		self.input_vector = input_value


func _on_area_3d_body_entered(body:Node3D):
	print("Collision with ", body.name)

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

		portal2.visible = true


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

		# # Re-create monsters when player leaves that land
		# demon._demon_recreate()

	elif body.name == "Demon":
		player_monster_collision = true

