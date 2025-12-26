extends Node

# Global event signals for decoupled communication

# Dialogue system signals
signal dialog_requested(dialog_id: String)
signal dialog_started
signal dialog_ended
signal dialog_choice_selected(choice_id: String)

# Scene management signals
signal scene_change_requested(scene_path: String)
signal scene_changed(scene_name: String)

# Minigame signals
signal minigame_started(minigame_type: String)
signal minigame_ended(success: bool, score: int)
signal minigame_paused
signal minigame_resumed

# UI signals
signal ui_show_requested(ui_path: String)
signal ui_hide_requested(ui_path: String)
signal ui_hidden(ui_path: String)
signal menu_toggled(menu_name: String, is_open: bool)

# Player interaction signals
signal interact_key_pressed
signal interaction_started(interactable: Node)
signal interaction_ended

# Notification signals
signal notification_showed(message: String, duration: float)
signal notification_hidden

# Quest/task signals
signal quest_started(quest_id: String)
signal quest_completed(quest_id: String)
signal quest_failed(quest_id: String)

# System signals
signal game_paused
signal game_resumed
signal game_saved
signal game_loaded

# NPC signals
signal npc_approached(npc_id: String)
signal npc_interaction_started(npc_id: String)
signal npc_interaction_ended(npc_id: String)

# Helper functions to emit signals easily

func request_dialog(dialog_id: String):
	emit_signal("dialog_requested", dialog_id)

func start_dialog():
	emit_signal("dialog_started")

func end_dialog():
	emit_signal("dialog_ended")

func request_scene_change(scene_path: String):
	emit_signal("scene_change_requested", scene_path)

func start_minigame(minigame_type: String):
	emit_signal("minigame_started", minigame_type)

func end_minigame(success: bool, score: int = 0):
	emit_signal("minigame_ended", success, score)

func show_ui(ui_path: String):
	emit_signal("ui_show_requested", ui_path)

func hide_ui(ui_path: String):
	emit_signal("ui_hide_requested", ui_path)

func toggle_menu(menu_name: String, is_open: bool):
	emit_signal("menu_toggled", menu_name, is_open)

func show_notification(message: String, duration: float = 3.0):
	emit_signal("notification_showed", message, duration)

func pause_game():
	emit_signal("game_paused")

func resume_game():
	emit_signal("game_resumed")

func save_game():
	emit_signal("game_saved")

func load_game():
	emit_signal("game_loaded")
