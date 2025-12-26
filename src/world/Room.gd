extends Node2D

# Room controller script
# Handles room-specific logic and scene management

@export var room_name: String = "Dorm"
@export var has_bed: bool = false
@export var has_computer: bool = false

func _ready():
	print("Entered room: ", room_name)
