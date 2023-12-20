extends Area3D

var leftController
var mission_title
var mission_board_done
var easy_mode
var medium_mode
var hard_mode
var mission_description_easy
var mission_description_medium
var mission_description_hard
var done
var slash
var goal
var submit
var mission_clear
var continue_button
var delete_button
var portal_activated

var go_back_1
var go_back_2
var go_back_3

var demon_health_bar_scene
var goblin_health_bar_scene
var giants_health_bar_scene

var difficulty_mode = 0
var rand_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	leftController = get_node("/root/Main/XROrigin3D/LeftController")
	mission_title = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/MissionTitle")
	mission_board_done = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Done")
	easy_mode = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Easy")
	medium_mode = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Medium")
	hard_mode = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Hard")
	mission_description_easy = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/MissionDescription_1")
	mission_description_medium = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/MissionDescription_2")
	mission_description_hard = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/MissionDescription_3")
	done = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Done")
	slash = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Slash")
	goal = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Goal")
	submit = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Submit")
	mission_clear = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/MissionClear")
	continue_button = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Continue")
	delete_button = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Delete")
	portal_activated = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/PortalActivated")

	go_back_1 = get_node("/root/Main/OuterLand1/GoBack_1")
	go_back_2 = get_node("/root/Main/OuterLand2/GoBack_2")
	go_back_3 = get_node("/root/Main/OuterLand3/GoBack_3")

	demon_health_bar_scene = get_node("/root/Main/OuterLand1/Demon/MeshInstance3D/HealthBar/SubViewport/Control/DemonHealthBar")
	goblin_health_bar_scene = get_node("/root/Main/OuterLand2/Goblin/GoblinHealth/SubViewportContainer/SubViewport/Control/GoblinHealthBar")
	giants_health_bar_scene = get_node("/root/Main/OuterLand3/Giants/GiantsHealthBar/SubViewportContainer/SubViewport/Control/GiantsHealthBar")

	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if leftController.is_button_pressed("by_button"):
		self.visible = true
	else:
		self.visible = false


# Generate a random number
func get_random_number(a: int, b: int):
	return randi_range(a, b)

# When the user selects the esay mode mission, randomly generate the mission and update the mission board.
func _on_easy_pressed():
	# Select easy mode
	difficulty_mode = 1
	easy_mode.visible = false
	medium_mode.visible = false
	hard_mode.visible = false

	# Randomly generate mission
	rand_num = get_random_number(1,20)
	mission_description_easy.text = "Defeat " + str(rand_num) + " Demons"
	goal.text = str(rand_num)

	# Update the mission board
	mission_description_easy.visible = true
	done.visible = true
	slash.visible = true
	goal.visible = true
	delete_button.visible = true

# When the user selects the medium mode mission, randomly generate the mission and update the mission board.
func _on_medium_pressed():
	# Select easy mode
	difficulty_mode = 2
	easy_mode.visible = false
	medium_mode.visible = false
	hard_mode.visible = false

	# Randomly generate mission
	rand_num = get_random_number(1,15)
	mission_description_medium.text = "Defeat " + str(rand_num) + " Goblins"
	goal.text = str(rand_num)

	# Update the mission board
	mission_description_medium.visible = true
	done.visible = true
	slash.visible = true
	goal.visible = true
	delete_button.visible = true

# When the user selects the hard mode mission, randomly generate the mission and update the mission board.
func _on_hard_pressed():
	# Select easy mode
	difficulty_mode = 3
	easy_mode.visible = false
	medium_mode.visible = false
	hard_mode.visible = false

	# Randomly generate mission
	rand_num = get_random_number(1,10)
	mission_description_hard.text = "Defeat " + str(rand_num) + " Giants"
	goal.text = str(rand_num)

	# Update the mission board
	mission_description_hard.visible = true
	done.visible = true
	slash.visible = true
	goal.visible = true
	delete_button.visible = true

# When the user submit the completed mission, update the mission board and prompt the user that mission is clear
func _on_submit_pressed():
	mission_title.visible = false

	if difficulty_mode == 1:
		mission_description_easy.visible = false
	elif difficulty_mode == 2:
		mission_description_medium.visible = false
	elif difficulty_mode == 3:
		mission_description_hard.visible = false

	done.visible = false
	slash.visible = false
	goal.visible = false
	delete_button.visible = false
	submit.visible = false
	mission_clear.visible = true

	await get_tree().create_timer(3).timeout
	mission_clear.visible = false
	portal_activated.visible = true

	continue_button.visible = true

# When the user click the continue button, it allows the user to active go-back portal
func _on_continue_pressed():
	portal_activated.visible = false
	submit.visible = false
	continue_button.visible = false
	
	if difficulty_mode == 1:
		go_back_1.visible = true
	elif difficulty_mode == 2:
		go_back_2.visible = true
	elif difficulty_mode == 3:
		go_back_3.visible = true

	mission_title.visible = true
	easy_mode.visible = true
	medium_mode.visible = true
	hard_mode.visible = true
	done.text = "0"

# When the user delete the current mission, it allows the user to select the difficulty of the mission again. When the mission is deleted, progress will be lost.
func _on_delete_pressed():
	mission_description_easy.visible = false
	mission_description_medium.visible = false
	mission_description_hard.visible = false
	done.visible = false
	slash.visible = false
	goal.visible = false
	delete_button.visible = false
	
	continue_button.visible = false
	easy_mode.visible = true
	medium_mode.visible = true
	hard_mode.visible = true

	# Clear the progress
	if difficulty_mode == 1:
		demon_health_bar_scene.progress = 0
		demon_health_bar_scene._update_mission_progress_on_board(0)
		difficulty_mode = 0
	elif difficulty_mode == 2:
		goblin_health_bar_scene.progress = 0
		goblin_health_bar_scene._update_mission_progress_on_board(0)
		difficulty_mode = 0
	elif difficulty_mode == 3:
		giants_health_bar_scene.progress = 0
		giants_health_bar_scene._update_mission_progress_on_board(0)
		difficulty_mode = 0
