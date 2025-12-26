extends Area2D

class_name InteractableObject

# Interaction properties
@export var prompt: String = "Press E to interact"
@export var can_interact: bool = true

# Visual feedback
var _is_hovered: bool = false
var _collision_shape: CollisionShape2D

signal interacted(interactor: Node)

func _ready():
	# Get collision shape
	_collision_shape = $CollisionShape2D

	# Connect to input events
	input_event.connect(_on_input_event)

	# Set up area monitoring
	monitoring = true
	monitorable = true

func interact(interactor: Node):
	"""Called when player interacts with this object"""
	if not can_interact:
		return

	emit_signal("interacted", interactor)
	_on_interact(interactor)

func _on_interact(interactor: Node):
	"""Override this method to implement custom interaction behavior"""
	print("Interacted with: ", name)

func _on_input_event(viewport, event, shape_idx):
	"""Handle mouse input events"""
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_on_clicked()

func _on_clicked():
	"""Handle object being clicked (for mouse interaction)"""
	# This is a fallback for mouse users
	# Keyboard interaction is handled in Player script
	pass

func _on_mouse_entered():
	"""Handle mouse entering the object area"""
	_is_hovered = true
	_on_hover_enter()

func _on_mouse_exited():
	"""Handle mouse exiting the object area"""
	_is_hovered = false
	_on_hover_exit()

func _on_hover_enter():
	"""Override this for custom hover enter behavior"""
	# Example: change color, show prompt, etc.
	pass

func _on_hover_exit():
	"""Override this for custom hover exit behavior"""
	# Example: reset color, hide prompt, etc.
	pass

func set_interactable(enabled: bool):
	"""Enable or disable interaction"""
	can_interact = enabled
	monitoring = enabled
	monitorable = enabled

func get_prompt() -> String:
	"""Get the interaction prompt"""
	return prompt
