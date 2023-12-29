extends CharacterBody3D
var SPEED = 4.0
var  CROUCHSPEED = 2
var JUMP_VELOCITY = 4.5
var direction := Vector3()
var crouched : bool
var flashLightIsOut : bool
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var sensitivity = 3
@onready var ray_cast_3d = $RayCast3D
@onready var ui = $UI
@onready var flash_light_sound = $sound/FlashLightSound
@onready var footstep_player = $sound/FootstepPlayer
@onready var animation_player = $AnimationPlayer
@onready var enemy = $"../enemy"
@onready var paper_sound = $paper_sound
@onready var cam_ray_cast = $Camera3D/CamRayCast
signal game_lose

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta):
	interaction_step()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speed = SPEED
	if Input.is_action_pressed("Crouch"):
		speed = CROUCHSPEED
		if !crouched:
			$AnimationPlayer.play("Crouch")
			#them mot am thanh
			crouched = true
	else:
		if crouched and !ray_cast_3d.is_colliding():
				var space_state = get_world_3d().direct_space_state
				$AnimationPlayer.play("UnCrouch")
				crouched = false
	if Input.is_action_just_pressed("Flashlight"):
		if flashLightIsOut:
			$AnimationPlayer.play("FlashlightHide")
		else:
			$AnimationPlayer.play("FlashlightShow")
		flash_light_sound.play()
		flashLightIsOut = !flashLightIsOut
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if !$sound/FootstepPlayer.is_playing():
			$sound/FootstepPlayer.play()
	else:
		if $sound/FootstepPlayer.is_playing():
			$sound/FootstepPlayer.stop()
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()

func _input(event):
	if(event is InputEventMouseMotion):
		rotation.y -= event.relative.x / 1000 * sensitivity
		$Camera3D.rotation.x -= event.relative.y / 1000 * sensitivity
		rotation.x = clamp(rotation.x, PI/-2 , PI/2)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -2, 2)
		
func interaction_step():
	var raycast_collider = cam_ray_cast.get_collider()
	
	if raycast_collider and raycast_collider is Interactable:
		
		ui.set_interaction_text_visible(true)
		ui.set_interaction_lable_text(raycast_collider.interaction_prompt_text)
		
		if Input.is_action_just_pressed("Interact"):
			raycast_collider.interacted_with()
			paper_sound.play()
	else:
		ui.set_interaction_text_visible(false)

# Hàm phát ra tín hiệu game_lose
func _on_collision(body: PhysicsBody3D):
	if body.name == "enemy":
		emit_signal("game_lose")

func _on_area_3d_area_entered(area):
	if area.is_in_group("enemy"):
		print("colli with enemy")
		$UI/LabelLose.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		SPEED = 0
		CROUCHSPEED = 0
		JUMP_VELOCITY = 0
