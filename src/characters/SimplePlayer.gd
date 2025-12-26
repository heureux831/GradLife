extends CharacterBody2D

# Simplified player for testing movement

@export var move_speed: float = 200.0

func _ready():
	print("SimplePlayer initialized!")

func _physics_process(delta):
	# Get input
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Normalize
	if input.length() > 1:
		input = input.normalized()

	# Set velocity directly
	velocity = input * move_speed

	# Debug
	if Engine.get_process_frames() % 60 == 0 and input.length() > 0:
		print("Moving! Input: ", input, " Velocity: ", velocity)

	# Move
	move_and_slide()
