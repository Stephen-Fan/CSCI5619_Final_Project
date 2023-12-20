extends Area3D

var leftController
var locomotion_scene
var player_health_bar_scene
var player_level
var player_hp
var player_hp_max
var player_exp
var player_exp_max
var death_board_level_up
var player_attack
var level_up_sound

var local_exp = 0
var local_level = 1
var local_attack = 5

# Called when the node enters the scene tree for the first time.
func _ready():

	leftController = get_node("/root/Main/XROrigin3D/LeftController")
	player_health_bar_scene = get_node("/root/Main/XROrigin3D/XRCamera3D/PlayerHealthBar/HealthBar/SubViewport/Control/ProgressBar")
	player_level = get_node("/root/Main/XROrigin3D/XRCamera3D/Character/MeshInstance3D/SubViewport/CanvasLayer/LVNum")
	player_hp = get_node("/root/Main/XROrigin3D/XRCamera3D/Character/MeshInstance3D/SubViewport/CanvasLayer/HPLeft")
	player_hp_max = get_node("/root/Main/XROrigin3D/XRCamera3D/Character/MeshInstance3D/SubViewport/CanvasLayer/HPRight")
	player_exp = get_node("/root/Main/XROrigin3D/XRCamera3D/Character/MeshInstance3D/SubViewport/CanvasLayer/EXPLeft")
	player_exp_max = get_node("/root/Main/XROrigin3D/XRCamera3D/Character/MeshInstance3D/SubViewport/CanvasLayer/EXPRight")
	player_attack = get_node("/root/Main/XROrigin3D/XRCamera3D/Character/MeshInstance3D/SubViewport/CanvasLayer/AttackPower")
	death_board_level_up = get_node("/root/Main/XROrigin3D/XRCamera3D/Death/MeshInstance3D/SubViewport/CanvasLayer/LevelUp")
	locomotion_scene = get_node("/root/Main/XROrigin3D")
	level_up_sound = get_node("/root/Main/LevelUpSound")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# Show the character board
	if leftController.is_button_pressed("ax_button"):
		self.visible = true
	else:
		self.visible = false

	# Keep updating the HP
	player_hp.text = str(player_health_bar_scene.value)
	player_hp_max.text = str(player_health_bar_scene.max_value)
	
	# Keep updating EXP and attack power after Level up
	if int(player_exp.text) >= 100:
		_level_up_prompt()
		locomotion_scene.health = 100

		if local_exp > 100:
			var remaining = (local_exp - 100)
			local_exp = remaining
		else:
			local_exp = 0

		local_level += 1
		local_attack += 5
		level_up_sound.playing = true
		player_exp.text = str(local_exp)
		player_level.text = str(local_level)
		player_attack.text = str(local_attack)
	else:
		player_exp.text = str(local_exp)

# Show the level up prompt can sound effect
func _level_up_prompt():
	death_board_level_up.visible = true
	await get_tree().create_timer(3).timeout
	death_board_level_up.visible = false
