extends Node2D

# Main scene controller
# Handles game initialization and scene management

@onready var player = $YSort/Player
@onready var room = $Dorm
@onready var test_object = $YSort/TestInteractable
@onready var interaction_manager = $InteractionManager
@onready var status_label = $CanvasLayer/StatusLabel

func _ready():
	# Initialize the game
	_initialize_game()

	# Connect signals
	_connect_signals()

	# Position player at spawn point
	_position_player()

	# Connect interactable areas
	_setup_interaction()

	print("GradLife initialized successfully!")
	print("Player position: ", player.position if player else "NOT FOUND")
	print("Test object position: ", test_object.position if test_object else "NOT FOUND")

func _initialize_game():
	"""Initialize game systems"""
	# TimeSystem is already running via autoload
	# PlayerStats is already initialized
	# Show welcome message
	GlobalSignals.show_notification("Welcome to GradLife!", 3.0)

func _connect_signals():
	"""Connect to global signals"""
	GlobalSignals.scene_change_requested.connect(_on_scene_change_requested)

func _position_player():
	"""Position player at spawn point"""
	if player:
		player.position = Vector2(640, 360)  # Center of the screen

func _setup_interaction():
	"""Set up interaction detection"""
	# Connect Player's interaction area to detect interactables
	if player and test_object:
		# This will be expanded with proper area detection
		pass

func _on_scene_change_requested(scene_path: String):
	"""Handle scene change requests"""
	# TODO: Implement scene transitions
	print("Scene change requested to: ", scene_path)

func _process(_delta):
	_update_status()

func _unhandled_input(event):
	"""Handle input events"""
	# Handle interact key press
	if event.is_action_pressed("interact"):
		GlobalSignals.interact_key_pressed.emit()

	# Debug: Press F1 to show stats
	if event.is_action_pressed("ui_cancel") and OS.is_debug_build():
		_show_debug_stats()

func _update_status():
	"""Update the status label with current game state"""
	if not status_label:
		return

	var status_text = ""
	status_text += "Day " + str(TimeSystem.get_day()) + " - " + TimeSystem.get_time_string() + "\n"
	status_text += "Player: (" + str(int(player.position.x)) + ", " + str(int(player.position.y)) + ")\n"
	status_text += "Energy: " + str(int(PlayerStats.energy)) + "/100\n"
	status_text += "Sanity: " + str(int(PlayerStats.sanity)) + "/100\n"

	status_label.text = status_text

func _show_debug_stats():
	"""Show debug information in console"""
	print("\n=== DEBUG STATS ===")
	print("Day: ", TimeSystem.get_day())
	print("Time: ", TimeSystem.get_time_string())
	print("Energy: ", PlayerStats.energy, "/ 100")
	print("Sanity: ", PlayerStats.sanity, "/ 100")
	print("Thesis Progress: ", PlayerStats.thesis_progress, "%")
	print("Knowledge: ", PlayerStats.knowledge)
	print("===================\n")
