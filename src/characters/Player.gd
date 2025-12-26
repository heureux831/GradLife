extends CharacterBody2D

class_name Player

# Movement settings
@export var move_speed: float = 200.0
@export var acceleration: float = 1000.0
@export var friction: float = 1000.0

# Animation
var _animation_player: AnimationPlayer
var _sprite: Sprite2D

# Interaction
var current_interactable: Node = null

# Movement direction tracking
var _last_direction: Vector2 = Vector2.DOWN

func _ready():
	# Get references to child nodes
	_animation_player = $AnimationPlayer
	_sprite = $Sprite2D

	# Connect to GlobalSignals
	GlobalSignals.interact_key_pressed.connect(_on_interact_key_pressed)

	# Set starting animation
	_play_animation("idle_down")

func _physics_process(delta):
	# Handle input
	_handle_input(delta)

	# Apply movement
	handle_movement(delta)

	# Move the character
	move_and_slide()

	# Update animation based on movement
	update_animation()

func _handle_input(delta):
	# Get input vector
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Normalize diagonal movement
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()

	# Store last non-zero direction
	if input_vector != Vector2.ZERO:
		_last_direction = input_vector

	# Store velocity for animation
	velocity = input_vector

func handle_movement(delta):
	# Apply acceleration or friction
	if velocity.length() > 0:
		velocity = velocity.move_toward(velocity * move_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func update_animation():
	# Determine animation based on velocity
	if velocity == Vector2.ZERO:
		# Idle animations
		if _last_direction == Vector2.UP:
			_play_animation("idle_up")
		elif _last_direction == Vector2.DOWN:
			_play_animation("idle_down")
		elif _last_direction == Vector2.LEFT:
			_play_animation("idle_left")
		elif _last_direction == Vector2.RIGHT:
			_play_animation("idle_right")
	else:
		# Walking animations
		if abs(velocity.x) > abs(velocity.y):
			# Horizontal movement
			if velocity.x > 0:
				_play_animation("walk_right")
				_sprite.flip_h = false
			elif velocity.x < 0:
				_play_animation("walk_left")
				_sprite.flip_h = true
		else:
			# Vertical movement
			if velocity.y > 0:
				_play_animation("walk_down")
			elif velocity.y < 0:
				_play_animation("walk_up")

func _play_animation(animation_name: String):
	# Play animation if it exists
	if _animation_player.has_animation(animation_name):
		if _animation_player.current_animation != animation_name:
			_animation_player.play(animation_name)

func _on_interact_key_pressed():
	# Try to interact with nearby objects
	if current_interactable and current_interactable.has_method("interact"):
		current_interactable.interact(self)

func set_interactable(interactable: Node):
	"""Set the current interactable object"""
	current_interactable = interactable

func clear_interactable():
	"""Clear the current interactable object"""
	current_interactable = null

func get_facing_direction() -> Vector2:
	"""Get the direction the player is facing"""
	return _last_direction
