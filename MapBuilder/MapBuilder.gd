extends Spatial


# Declare member variables here. Examples:
onready var player = $Player
onready var camera = $Player/Camera
onready var input_ui = CombatInputUI.new()
onready var map = $Map
onready var hud = $MapBuilderHUD


func _unhandled_input(event):
    # all mouse/multitouch.key UI is done through the input_ui node
    input_ui.handle_input(event, self)


# Called when the node enters the scene tree for the first time.
func _ready():
    camera.follow_combatant(player)
    map.click_delegate = self


func on_map_click(coords, normal):
    """map.click_delegate method
        TODO: think about whether or not all this stuff should go through input_ui, possibly extended/refactored ui class?
        Create a new voxel in this map at the specified coords!
    """    
    var voxel = map.add_voxel(coords + normal, hud.voxel_type)

    



