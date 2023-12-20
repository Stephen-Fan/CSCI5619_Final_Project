extends RigidBody3D


var is_goblin_activated = false

var player_body
var goblin_health_bar_mesh
var goblin_health_bar_scene
var character_board_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	player_body = get_node("/root/Main/XROrigin3D")
	goblin_health_bar_mesh = get_node("/root/Main/OuterLand2/Goblin/GoblinHealth")
	goblin_health_bar_scene = get_node("/root/Main/OuterLand2/Goblin/GoblinHealth/SubViewportContainer/SubViewport/Control/GoblinHealthBar")
	character_board_scene = get_node("/root/Main/XROrigin3D/XRCamera3D/Character")
	randomize()

# Generate a random number
func get_random_number(a: int, b: int):
	return randi_range(a, b)


# Recreate the demons
func _goblin_recreate():

	# Generate a monster with randomized location
	self.visible = true
	goblin_health_bar_mesh.visible = false

	var rand_num_x = get_random_number(-40, 40)
	var rand_num_z = get_random_number(30, -40)
	self.transform.origin = Vector3(rand_num_x, 0, rand_num_z)
		
	# Hide the go back portal
	player_body.go_back_2.visible = false
	player_body.go_back_2.collision_layer = 0b00000001

	# Refill monster's HP
	goblin_health_bar_scene.health = 100

	# Reset health bar mesh color to green
	var material_bar = goblin_health_bar_mesh.material_override
	material_bar.albedo_color = Color(0, 1, 0)


# Delete the current goblin and hide it's all information
func _goblin_delete():
	character_board_scene.local_exp += 30
	is_goblin_activated = false
	self.visible = false
	self.global_transform.origin += Vector3(0,-10,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# when the monster is activated, it starts to rotate
	if is_goblin_activated:

		rotate_y(25.0 * delta)
