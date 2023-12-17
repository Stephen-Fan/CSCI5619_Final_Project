extends StaticBody3D

var player_camera
var player_body
var demon_health_bar_scene
var demon_health_bar_mesh
var is_demon_activated = false
# var to_activate_monster

var speed = 2.0
var moving_direction = -1
# var locations = [Vector3(-1,0,20), Vector3(12,0,25), Vector3(12,0,-12), Vector3(-16,0,0), Vector3(-16,0,40)]


# Called when the node enters the scene tree for the first time.
func _ready():
	demon_health_bar_mesh = get_node("/root/Main/OuterLand1/Demon/MeshInstance3D")
	player_camera = get_node("/root/Main/XROrigin3D/XRCamera3D")
	player_body = get_node("/root/Main/XROrigin3D")
	demon_health_bar_scene = get_node("/root/Main/OuterLand1/Demon/MeshInstance3D/HealthBar/SubViewport/Control/DemonHealthBar")
	# to_activate_monster = get_node("/root/Main/OuterLand1/Demon")
	randomize()


# Generate a random number from 1-5
func get_random_number(a: int, b: int):
	return randi_range(a, b)


# Recreate the demons
func _demon_recreate():

	self.visible = true
	demon_health_bar_mesh.visible = false

	var rand_num_x = get_random_number(-40, 40)
	var rand_num_z = get_random_number(30, -40)
	# print(rand_num_x, ",0,", rand_num_z)
	self.transform.origin = Vector3(rand_num_x, 0, rand_num_z)
		
	# Hide the go back portal
	player_body.go_back_1.visible = false
	player_body.go_back_1.collision_layer = 0b00000001

	# Refill monster's HP
	demon_health_bar_scene.health = 100

	# Reset health bar mesh color to green
	var material_bar = demon_health_bar_mesh.material_override
	material_bar.albedo_color = Color(0, 1, 0)


# Delete the current demon and hide it's all information
func _demon_delete():
	# to_activate_monster.is_monster_activated = false
	is_demon_activated = false
	self.visible = false
	self.global_transform.origin += Vector3(0,-10,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# when the monster is activated, it starts to move
	if is_demon_activated:
		
		# get the position of the monster and the player
		var camera_position = player_camera.global_transform.origin
		var monster_position = global_transform.origin
		
		# Calculate the direction to the camera
		var direction = (camera_position - monster_position).normalized()
	
		# Adjust the direction for models facing along the +Z axis
		direction = -direction

		# let the monster always facing the camera
		look_at(monster_position + direction, Vector3.UP)

		# Reset rotations on the X and Z axes to prevent the object from tilting forward or backward.
		rotation.x = 0
		rotation.z = 0

		# # let the monster moves toward the player
		self.position.x += moving_direction * direction.x * speed * delta
		self.position.z += moving_direction * direction.z * speed * delta

		

