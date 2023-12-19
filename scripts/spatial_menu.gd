extends Node

var sword
var leftController
var rightController
var main
var introTitle
var yes
var no
var nono
var back
var nextPage
var weaponTitle
var weapon1
var weapon2
var weapon3

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_node("/root/Main")
	sword = get_node("/root/Main/Tables/PickableSword")
	leftController = get_node("/root/Main/XROrigin3D/LeftController")
	rightController = get_node("/root/Main/XROrigin3D/RightController")
	introTitle = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/IntroTitle")
	yes = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/Yes")
	no = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/No")
	nono = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/NOno")
	nextPage = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/Next")
	weaponTitle = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/Title")
	weapon1 = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/WeaponButton1")
	weapon2 = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/WeaponButton2")
	weapon3 = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/WeaponButton3")
	back = get_node("/root/Main/SpatialMenu/PlaneMesh/SubViewport/CanvasLayer/Back")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# if rightController.is_button_pressed("ax_button") && leftController.is_button_pressed("ax_button"):
	# 	sword.visible = false
	pass

func _on_weapon_button_1_pressed():
	print("Sword Selected")
	sword.visible = true

func _on_weapon_button_2_pressed():
	print("Gun Selected")


func _on_weapon_button_3_pressed():
	print("Bow Selected")


func _on_back_pressed():
	nextPage.visible = true
	introTitle.visible = true
	yes.visible = true
	no.visible = true
	back.visible = false
	weaponTitle.visible = false
	weapon1.visible = false
	weapon2.visible = false
	weapon3.visible = false

func _on_next_pressed():
	# print("Next pressed")
	introTitle.visible = false
	yes.visible = false
	no.visible = false
	nono.visible = false
	nextPage.visible = false
	back.visible = true
	weaponTitle.visible = true
	weapon1.visible = true
	weapon2.visible = true
	weapon3.visible = true

func _on_yes_pressed():
	nextPage.visible = true


func _on_no_pressed():
	nono.visible = true
