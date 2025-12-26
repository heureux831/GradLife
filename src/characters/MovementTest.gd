extends Node2D

# Simple test script to verify Player movement
# Attach this to Main.tscn for debugging

@onready var player = $YSort/Player

func _process(_delta):
	# Print player position every 0.5 seconds
	if Engine.get_process_frames() % 30 == 0:  # Every ~0.5 seconds at 60fps
		if player:
			var velocity = player.velocity
			print("Player pos: ", player.position, " Velocity: ", velocity)
