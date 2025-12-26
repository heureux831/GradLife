extends Node

signal energy_changed(new_energy: float)
signal sanity_changed(new_sanity: float)
signal thesis_progress_changed(new_progress: float)
signal knowledge_changed(new_knowledge: float)
signal stats_depleted

# Player core stats
var energy: float = 100.0:
	set(value):
		energy = clamp(value, 0.0, 100.0)
		emit_signal("energy_changed", energy)
		if energy <= 0.0:
			trigger_energy_depletion()

var sanity: float = 100.0:
	set(value):
		sanity = clamp(value, 0.0, 100.0)
		emit_signal("sanity_changed", sanity)
		if sanity <= 0.0:
			trigger_sanity_depletion()

var thesis_progress: float = 0.0:
	set(value):
		thesis_progress = clamp(value, 0.0, 100.0)
		emit_signal("thesis_progress_changed", thesis_progress)
		if thesis_progress >= 100.0:
			trigger_victory()

var knowledge: float = 0.0:
	set(value):
		knowledge = max(0.0, value)
		emit_signal("knowledge_changed", knowledge)

# Additional stats
var money: float = 500.0
var advisor_relationship: float = 50.0

# Thresholds
const LOW_ENERGY_THRESHOLD = 20.0
const LOW_SANITY_THRESHOLD = 20.0

func _ready():
	# Initialize with starting values
	emit_signal("energy_changed", energy)
	emit_signal("sanity_changed", sanity)
	emit_signal("thesis_progress_changed", thesis_progress)
	emit_signal("knowledge_changed", knowledge)

func change_energy(amount: float):
	"""Change energy by a given amount"""
	energy += amount

func change_sanity(amount: float):
	"""Change sanity by a given amount"""
	sanity += amount

func change_thesis_progress(amount: float):
	"""Change thesis progress by a given amount"""
	thesis_progress += amount

func change_knowledge(amount: float):
	"""Change knowledge by a given amount"""
	knowledge += amount

func change_money(amount: float):
	"""Change money by a given amount"""
	money += amount

func change_advisor_relationship(amount: float):
	"""Change advisor relationship by a given amount"""
	advisor_relationship = clamp(advisor_relationship + amount, 0.0, 100.0)

func is_energy_low() -> bool:
	"""Check if energy is at a critical level"""
	return energy <= LOW_ENERGY_THRESHOLD

func is_sanity_low() -> bool:
	"""Check if sanity is at a critical level"""
	return sanity <= LOW_SANITY_THRESHOLD

func can_work() -> bool:
	"""Check if player can perform work (has enough energy and sanity)"""
	return energy > 0.0 and sanity > 0.0

func get_energy_percentage() -> float:
	"""Get energy as a percentage (0.0 to 1.0)"""
	return energy / 100.0

func get_sanity_percentage() -> float:
	"""Get sanity as a percentage (0.0 to 1.0)"""
	return sanity / 100.0

func get_thesis_percentage() -> float:
	"""Get thesis progress as a percentage (0.0 to 1.0)"""
	return thesis_progress / 100.0

func trigger_energy_depletion():
	"""Handle energy depletion (player faints)"""
	print("Player has fainted from exhaustion!")
	emit_signal("stats_depleted", "energy")

func trigger_sanity_depletion():
	"""Handle sanity depletion (breakdown)"""
	print("Player has suffered a mental breakdown!")
	emit_signal("stats_depleted", "sanity")

func trigger_victory():
	"""Handle thesis completion (victory condition)"""
	print("Congratulations! Thesis completed!")
	emit_signal("stats_depleted", "victory")

func check_game_over() -> bool:
	"""Check if the game should end"""
	return energy <= 0.0 or sanity <= 0.0 or thesis_progress >= 100.0

func reset_stats():
	"""Reset all stats to starting values"""
	energy = 100.0
	sanity = 100.0
	thesis_progress = 0.0
	knowledge = 0.0
	money = 500.0
	advisor_relationship = 50.0
