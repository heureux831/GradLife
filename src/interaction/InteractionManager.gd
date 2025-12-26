extends Node

# Manages player interactions with objects
# Detects nearby interactables and handles interaction logic

var player: Player = null
var nearby_interactables: Array = []
var current_interactable: InteractableObject = null

func _ready():
	# Get player reference from the scene tree
	player = get_tree().get_first_node_in_group("player")
	if not player:
		# Try to find player by path if not in group
		player = get_tree().get_root().get_node_or_null("Main/YSort/Player")

	# Add player to group
	if player:
		player.add_to_group("player")
		print("Player found and added to group")

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
