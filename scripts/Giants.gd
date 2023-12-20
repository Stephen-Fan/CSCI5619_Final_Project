extends StaticBody3D

var player_camera
var player_body
var giants_health_bar_scene
var giants_health_bar_mesh

var is_giants_activated = false
# var to_activate_monster

var speed = 5.0
var moving_direction = -1
# var locations = [Vector3(-1,0,20), Vector3(12,0,25), Vector3(12,0,-12), Vector3(-16,0,0), Vector3(-16,0,40)]


# Called when the node enters the scene tree for the first time.
func _ready():
	giants_health_bar_mesh = get_node("/root/Main/OuterLand3/Giants/GiantsHealthBar")
	player_camera = get_node("/root/Main/XROrigin3D/XRCamera3D")
	player_body = get_node("/root/Main/XROrigin3D")
	giants_health_bar_scene = get_node("/root/Main/OuterLand3/Giants/GiantsHealthBar/SubViewportContainer/SubViewport/Control/GiantsHealthBar")
	# to_activate_monster = get_node("/root/Main/OuterLand1/Demon")
	randomize()


# Generate a random number
func get_random_number(a: int, b: int):
	return randi_range(a, b)


# Recreate the demons
func _giants_recreate():

	# Generate a monster with randomized location
	self.visible = true
	giants_health_bar_mesh.visible = false

	var rand_num_x = get_random_number(-40, 40)
	var rand_num_z = get_random_number(30, -40)
	self.transform.origin = Vector3(rand_num_x, 3, rand_num_z)
		
	# Hide the go back portal
	player_body.go_back_3.visible = false
	player_body.go_back_3.collision_layer = 0b00000001

	# Refill monster's HP
	giants_health_bar_scene.health = 100

	# Reset health bar mesh color to green
	var material_bar = giants_health_bar_mesh.material_override
	material_bar.albedo_color = Color(0, 1, 0)


# Delete the current demon and hide it's all information
func _giants_delete():
	is_giants_activated = false
	self.visible = false
	self.global_transform.origin += Vector3(0,-30,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# when the monster is activated, it starts to move
	if is_giants_activated:
		
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

		

