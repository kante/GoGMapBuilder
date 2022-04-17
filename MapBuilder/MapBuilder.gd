extends Spatial


# Declare member variables here. Examples:
onready var player = $Player
onready var camera = $Player/Camera
onready var input_ui = CombatInputUI.new()


func _unhandled_input(event):
    # all mouse/multitouch.key UI is done through the input_ui node
    input_ui.handle_input(event, self)


# Called when the node enters the scene tree for the first time.
func _ready():
    camera.follow_combatant(player)



