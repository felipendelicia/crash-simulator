extends Node2D

# Declare variables with paths to the UI elements
onready var circle1 = $circle1
onready var circle2 = $circle2
onready var mass1_input = $UI/VBoxContainer/inputs1/input_mass1
onready var velocity1_input = $UI/VBoxContainer/inputs1/input_velocity1
onready var mass2_input = $UI/VBoxContainer/inputs2/input_mass2
onready var velocity2_input = $UI/VBoxContainer/inputs2/input_velocity2
onready var friction_input = $UI/VBoxContainer/friction/input

# Declare variables with paths to the buttons
onready var play_button = $UI/VBoxContainer/buttons/play
onready var stop_button = $UI/VBoxContainer/buttons/stop

func _ready():
    # Connect button signals to respective methods
    play_button.connect("pressed", self, "_on_play_button_pressed")
    stop_button.connect("pressed", self, "_on_stop_button_pressed")
    
    # Initially, disable the stop button
    stop_button.disabled = true

    # Set references to the other circle for each circle
    circle1.other_circle = circle2.get_path()
    circle2.other_circle = circle1.get_path()

func _on_play_button_pressed():
    # Retrieve input values and convert them to the required types
    var mass1 = mass1_input.text.to_float()
    var velocity1 = Vector2(velocity1_input.text.to_float(), 0)
    var mass2 = mass2_input.text.to_float()
    var velocity2 = Vector2(velocity2_input.text.to_float(), 0)
    var friction = friction_input.text.to_float()
    
    # Start the simulation for both circles
    circle1.start_simulation(mass1, velocity1, friction)
    circle2.start_simulation(mass2, velocity2, friction)
    
    # Toggle button states
    play_button.disabled = true
    stop_button.disabled = false

func _on_stop_button_pressed():
    # Stop the simulation for both circles
    circle1.stop_simulation()
    circle2.stop_simulation()
    
    # Toggle button states
    play_button.disabled = false
    stop_button.disabled = true
