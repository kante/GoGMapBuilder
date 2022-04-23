extends Control


var voxel_type = Voxel.STONE
onready var button_prototype = $HBoxContainer/VoxelSelectButton
onready var button_container = $HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
    
    for type in Voxel.properties:
        var properties = Voxel.properties[type]
        var new_button = button_prototype.duplicate()
        new_button.voxel_type = type
        new_button.hud = self    
    
        button_container.add_child(new_button)
        
        new_button.sprite.region_rect = Rect2(properties[Vector3.UP]*Voxel.TILE_SIZE, 
                                              Vector2.ONE*Voxel.TILE_SIZE)    
        if type == voxel_type:
            new_button.pressed = true
    
    button_prototype.visible = false
        
        

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    $FPSLabel.text = "FPS: %d  " % Engine.get_frames_per_second()


func deselect_buttons():
    """Set all buttons to deselected mode"""
    for button in button_container.get_children():
        button.pressed = false
    

