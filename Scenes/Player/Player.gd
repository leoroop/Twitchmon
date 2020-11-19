extends KinematicBody2D

const MAX_SPEED = 90
const ACCELERATION = 30
const FRICTION = 30

var count = 0
var move = 0
var moved_right = false
var talking = false

var velocity = Vector2.ZERO

var animationPlayer = null
var animationTree = null
var animationState = null
var talkingarea = null
var connor = null

func _ready():	
	animationPlayer = $AnimationPlayer
	animationTree = $AnimationTree
	animationState = animationTree.get("parameters/playback")
	talkingarea = $Area2D
	connor = get_parent().get_node("Connor").get_node("CollisionShape2D")
	
	talkingarea.connect("area_entered", self, "_on_player_approached")
	talkingarea.connect("area_exited", self, "_on_player_left")

func _on_player_approached(area):
	talking = true

func _on_player_left(area):
	talking = false

func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	
	if count > 60 and not talking:
		if moved_right and move < 60:
			input_vector.x = -1
			move += 1
		elif move < 60:
			input_vector.x = 1
			move += 1
		else:
			input_vector.x = 0
			if move == 60:
				if moved_right:
					moved_right = false
				else:
					moved_right = true
				move = 0
				count = 0
				
	
	count += 1
	# input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

	velocity = move_and_slide(velocity)
