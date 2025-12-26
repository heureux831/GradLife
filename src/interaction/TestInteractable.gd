extends InteractableObject

func _ready():
	# Set custom prompt
	prompt = "Press E to say Hello"
	super._ready()

func _on_interact(interactor: Node):
	"""Override to print Hello when interacted with"""
	print("Hello!")
	GlobalSignals.show_notification("Hello from test object!", 2.0)
