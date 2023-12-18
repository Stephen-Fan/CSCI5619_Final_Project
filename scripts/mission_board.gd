extends Area3D

var leftController

# Called when the node enters the scene tree for the first time.
func _ready():
	leftController = get_node("/root/Main/XROrigin3D/LeftController")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if leftController.is_button_pressed("by_button"):
		self.visible = true
	else:
		self.visible = false
