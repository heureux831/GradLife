extends InteractableObject

func _ready():
	# Set custom prompt
	prompt = "Press E to say Hello"
	super._ready()
	print("TestInteractable ready!")

func _on_interact(interactor: Node):
	"""Override to print Hello when interacted with"""
	print("Hello!")
	GlobalSignals.show_notification("Hello from test object!", 2.0)

func _on_hover_enter():
	"""Make the object more visible when hovered"""
	var color_rect = $Sprite2D/ColorRect
	if color_rect:
		color_rect.color = Color(1, 0.8, 0.4, 1)  # Brighter color

func _on_hover_exit():
	"""Restore original color"""
	var color_rect = $Sprite2D/ColorRect
	if color_rect:
		color_rect.color = Color(0.8, 0.5, 0.2, 1)  # Original color
