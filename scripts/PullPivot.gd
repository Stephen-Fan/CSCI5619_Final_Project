extends Node3D

var left_hand
var right_hand
# var pivot_original_position
var bow

var is_pivot_activated = false
var is_grip_click = false
var is_trigger_click = false
var is_holding_bow = false

# Called when the node enters the scene tree for the first time.
func _ready():
	left_hand = get_node("/root/Main/XROrigin3D/LeftController")
	right_hand = get_node("/root/Main/XROrigin3D/RightController")
	bow = get_node("/root/Main/Tables/PickableBow")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# if is_pivot_activated and is_grip_click:
	# 	pivot_original_position = self.global_position



	# elif is_pivot_activated and is_grip_click and is_trigger_click:
	# 	var right_hand_position = right_hand.global_transform.origin
	# 	# var pivot_position = global_transform.origin
	# 	self.global_position = right_hand_position
	# elif is_pivot_activated and !is_grip_click and !is_trigger_click:
	# 	self.global_position = pivot_original_position

	# if bow.is_picked_up():
	# 	print("yes")
	
	# if is_holding_bow:
	# 	var pivot_original_position = self.transform.origin
	
	pass



func _on_area_3d_body_entered(body):
	print("Pivot Collides with: ", body.name)

	if body.name == "PullPivot":
		is_pivot_activated = true


func _on_right_controller_button_pressed(button_name):
	# print(button_name, " is pressed")
	if button_name == "grip_click":
		is_grip_click = true
	elif button_name == "trigger_click":
		is_trigger_click = true

func _on_right_controller_button_released(button_name):
	# print(button_name, " is released")
	if button_name == "grip_click":
		is_grip_click = false
	elif button_name == "trigger_click":
		is_trigger_click = false
