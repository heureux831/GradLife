extends Node

signal time_tick(hour: int, minute: int)
signal hour_changed(hour: int)
signal day_started(day: int)
signal day_ended(day: int)

# Core time variables
var current_day: int = 1
var current_hour: int = 8  # Start at 8:00 AM
var current_minute: int = 0
var game_speed: float = 1.0

# Time conversion: 1 real second = 1 game minute
var _time_tick_timer: float = 1.0

func _ready():
	# Start the time progression
	_start_time_ticking()

func _process(delta):
	# Handle time progression if game is running
	if game_speed > 0:
		_time_tick_timer -= delta * game_speed

		if _time_tick_timer <= 0:
			advance_minute()
			_time_tick_timer = 1.0

func advance_minute():
	"""Advance time by one minute"""
	current_minute += 1

	if current_minute >= 60:
		current_minute = 0
		advance_hour()

	emit_signal("time_tick", current_hour, current_minute)

func advance_hour():
	"""Advance time by one hour"""
	var previous_hour = current_hour
	current_hour += 1

	if current_hour >= 24:
		current_hour = 0
		end_day()

	emit_signal("hour_changed", current_hour)

	if previous_hour != current_hour:
		emit_signal("hour_changed", current_hour)

func end_day():
	"""End the current day and start a new one"""
	emit_signal("day_ended", current_day)
	current_day += 1
	emit_signal("day_started", current_day)

func start_new_day():
	"""Manually start a new day (reset to 8:00 AM)"""
	emit_signal("day_ended", current_day)
	current_day += 1
	current_hour = 8
	current_minute = 0
	emit_signal("day_started", current_day)
	emit_signal("time_tick", current_hour, current_minute)

func skip_to_next_day():
	"""Skip to the next day at 8:00 AM"""
	start_new_day()

func get_time_string() -> String:
	"""Get formatted time string (HH:MM)"""
	return str(current_hour).pad_zeros(2) + ":" + str(current_minute).pad_zeros(2)

func get_day_string() -> String:
	"""Get formatted day string"""
	return "Day " + str(current_day)

func _start_time_ticking():
	"""Initialize the time ticking system"""
	emit_signal("time_tick", current_hour, current_minute)

func set_game_speed(speed: float):
	"""Set the game speed multiplier"""
	game_speed = max(0.0, speed)

func pause_time():
	"""Pause time progression"""
	game_speed = 0.0

func resume_time():
	"""Resume time progression"""
	game_speed = 1.0

func get_hour() -> int:
	return current_hour

func get_minute() -> int:
	return current_minute

func get_day() -> int:
	return current_day
