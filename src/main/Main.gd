extends Node2D

# Main scene controller
# Handles game initialization and scene management

@onready var player = $YSort/Player
@onready var room = $Dorm
@onready var test_object = $YSort/TestInteractable
@onready var interaction_manager = $InteractionManager

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

func _unhandled_input(event):
	"""Handle input events"""
	# Handle interact key press
	if event.is_action_pressed("interact"):
		GlobalSignals.interact_key_pressed.emit()

	# Debug: Press F1 to show stats
	if event.is_action_pressed("ui_cancel") and OS.is_debug_build():
		_show_debug_stats()

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
