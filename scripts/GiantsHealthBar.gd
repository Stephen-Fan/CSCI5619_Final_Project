extends ProgressBar


# var health_array
var giants
var giants_health_bar_mesh
var sword_hit_enemy
var player_body
var mission_board_done
var area_clear
var done
var submit

var health = 100
var progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	sword_hit_enemy = get_node("/root/Main/SwordHitEnemy")
	player_body = get_node("/root/Main/XROrigin3D")
	giants = get_node("/root/Main/OuterLand3/Giants")
	giants_health_bar_mesh = get_node("/root/Main/OuterLand3/Giants/GiantsHealthBar")
	mission_board_done = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Done")
	area_clear = get_node("/root/Main/XROrigin3D/XRCamera3D/Death/MeshInstance3D/SubViewport/CanvasLayer/AreaClear")
	done = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Done")
	submit = get_node("/root/Main/XROrigin3D/XRCamera3D/MissionBoard/BoardMesh/SubViewport/CanvasLayer/Submit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.value = health

func _reset_progress():
	progress = 0

func _area_clear_prompt():
	area_clear.visible = true
	await get_tree().create_timer(3).timeout
	area_clear.visible = false

func _update_mission_progress_on_board():
	if progress == 1:
		done.text = "1"
	elif progress == 2:
		done.text = "2"
	elif progress == 3:
		done.text = "3"
	elif progress == 4:
		done.text = "4"
	elif progress == 5:
		done.text = "5"
		submit.visible = true


func _on_area_3d_body_entered(body:Node3D):
	# print("In bar script, Hit with :", body.name)
	if body.name == "Giants":

		# If the enemy's health becomes 0, delete it.
		if health == 0:
			player_body.player_monster_collision = false
			giants._giants_delete()
			progress += 1
			_update_mission_progress_on_board()
			
			if progress == 5:
				_area_clear_prompt()
				_reset_progress()
			else:
				giants._giants_recreate()
			
		# Enable sound effect when hitting the enemy
		sword_hit_enemy.playing = true
		
		# Initailly, the health bar is invisible. It will be invoked after the player hits the enemy at the first time.
		if giants_health_bar_mesh.visible == false:
			giants_health_bar_mesh.visible = true
			# demon_model_1.to_activate_monster.is_monster_activated = true
			giants.is_giants_activated = true
		else:
			health -= 5
			if health <= 0:
				health = 0
		
		# if health = 60, the health bar color becomes yellow
		if health == 60:
			var material_bar = giants_health_bar_mesh.material_override
			material_bar.albedo_color = Color(1, 1, 0)
		
		# if health = 30, the health bar color becomes red
		if health== 30:
			var material_bar = giants_health_bar_mesh.material_override
			material_bar.albedo_color = Color(1, 0, 0)
			
		# if health = 0, the health bar color becomes white
		if health == 0:
			var material_bar = giants_health_bar_mesh.material_override
			material_bar.albedo_color = Color(1, 1, 1)
