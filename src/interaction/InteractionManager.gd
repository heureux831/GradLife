extends Node

# Manages player interactions with objects
# Detects nearby interactables and handles interaction logic

@onready var player = get_tree().get_first_node_in_group("player")
var nearby_interactables: Array = []
var current_interactable: InteractableObject = null

func _ready():
	# Add player to group if not already added
	if player and not player.is_in_group("player"):
		player.add_to_group("player")

func _process(_delta):
	_update_nearby_interactables()

func _update_nearby_interactables():
	"""Update the list of nearby interactable objects"""
	if not player:
		return

	# Get player's interaction area
	var interaction_area = player.get_node_or_null("InteractionArea")
	if not interaction_area:
		return

	# Get overlapping areas
	var overlapping_areas = interaction_area.get_overlapping_areas()

	# Filter for interactables
	nearby_interactables.clear()
	for area in overlapping_areas:
		if area is InteractableObject:
			nearby_interactables.append(area)

	# Set current interactable (closest one)
	if nearby_interactables.size() > 0:
		current_interactable = nearby_interactables[0]
		player.set_interactable(current_interactable)
	else:
		if current_interactable:
			player.clear_interactable()
			current_interactable = null

func try_interact():
	"""Attempt to interact with current interactable"""
	if current_interactable and current_interactable.can_interact:
		current_interactable.interact(player)
		return true
	return false
