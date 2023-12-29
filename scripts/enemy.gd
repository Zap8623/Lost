extends CharacterBody3D

enum States{
	patrol,
	chasing,
	hunting,
	waiting
}


@export var chaseSpeed = 3
@export var patrolSpeed = 2
var currentState : States
var navigationAgent : NavigationAgent3D
@export var waypoints : Array
var waypointIndex : int
var patrolTimer : Timer

var playerInEarshotFar : bool
var playerInEarshotClose : bool
var playerInSightFar : bool
var playerInSightClose : bool
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	currentState = States.patrol
	navigationAgent = $NavigationAgent3D
	patrolTimer = $PatrolTimer
	player = get_tree().get_nodes_in_group("Player")[0]
	waypoints = get_tree().get_nodes_in_group("EnemyWaypoint")
	navigationAgent.set_target_position(waypoints[0].global_position)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match currentState:
		States.patrol:
			if(navigationAgent.is_navigation_finished()):
				currentState = States.waiting
				patrolTimer.start()
				return
			MoveTowardsPoint(delta,patrolSpeed)
			pass
		States.chasing:
			if(navigationAgent.is_navigation_finished()):
				patrolTimer.start()
				currentState = States.waiting
			navigationAgent.set_target_position(player.global_position)
			MoveTowardsPoint(delta,chaseSpeed)
			pass
		States.hunting:
			if(navigationAgent.is_navigation_finished()):
				patrolTimer.start()
				currentState = States.waiting
			navigationAgent.set_target_position(player.global_position)
			MoveTowardsPoint(delta,patrolSpeed)
			pass
		States.waiting:
			pass
	pass

func MoveTowardsPoint(delta, speed):
	var targetPos = navigationAgent.get_next_path_position()
	var direction = global_position.direction_to(targetPos)
	faceDirection(targetPos)
	velocity = direction * speed
	move_and_slide()
	if(playerInEarshotFar):
		CheckForPlayer()

func CheckForPlayer():
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create($Head.global_position, player.get_node("Camera3D").global_position , 1, [self]))
	if result.size() > 0:
		if(result["collider"].is_in_group("Player")):
			if(playerInEarshotClose):
				if(result["collider"].crouched == false):
					currentState = States.chasing
				
			if(playerInEarshotFar):
				if(result["collider"].crouched == false):
					currentState = States.hunting
					navigationAgent.set_target_position(player.global_position)
				
			if(playerInSightClose):
					currentState = States.chasing
				
			if(playerInSightFar):
				if(result["collider"].crouched == false):
					currentState = States.hunting
					navigationAgent.set_target_position(player.global_position)
	pass

func faceDirection(direction : Vector3): 
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)

func _on_patrol_timer_timeout():
	currentState = States.patrol 
	waypointIndex += 1
	if waypointIndex > waypoints.size() - 1:
		waypointIndex = 0
	navigationAgent.set_target_position(waypoints[waypointIndex].global_position)
	pass # Replace with function body.


func _on_hearing_far_body_entered(body):
	if body.is_in_group("Player"):
		playerInEarshotFar = true
		print("Player is far in earshot")
	pass # Replace with function body.


func _on_hearing_far_body_exited(body):
	if body.is_in_group("Player"):
		playerInEarshotFar = false
		print("Player has left far earshot")
	pass # Replace with function body.


func _on_hearing_close_body_entered(body):
	if body.is_in_group("Player"):
		playerInEarshotClose = true
		print("Player is close in earshot")
	pass # Replace with function body.


func _on_hearing_close_body_exited(body):
	if body.is_in_group("Player"):
		playerInEarshotClose = false
		print("Player has left close earshot")
	pass # Replace with function body.


func _on_sight_far_body_entered(body):
	if body.is_in_group("Player"):
		playerInSightFar = true
		print("Player has enter far sight")
	pass # Replace with function body.


func _on_sight_far_body_exited(body):
	if body.is_in_group("Player"):
		playerInSightFar = false
		print("Player has left far sight")
	pass # Replace with function body.


func _on_sight_close_body_entered(body):
	if body.is_in_group("Player"):
		playerInSightClose = true
		print("Player has enter close sight")
	pass # Replace with function body.


func _on_sight_close_body_exited(body):
	if body.is_in_group("Player"):
		playerInSightClose = false
		print("Player has left close sight")
	pass # Replace with function body.
