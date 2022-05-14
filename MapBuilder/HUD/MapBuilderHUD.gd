extends Control


var voxel_type = Voxel.STONE
onready var button_prototype = preload("res://MapBuilder/HUD/VoxelSelectButton.tscn")
onready var button_container = $HBoxContainer


func _ready():
    """Just initializes the voxel selection buttons for now."""
    for type in Voxel.properties:
        var properties = Voxel.properties[type]
        var new_button = button_prototype.instance()
        new_button.voxel_type = type
        new_button.hud = self    
    
        button_container.add_child(new_button)
        
        var atlas_rect = Rect2(properties[Vector3.UP]*Voxel.TILE_SIZE, Vector2.ONE*Voxel.TILE_SIZE)    
        new_button.set_texture(atlas_rect, properties.name)

        
        if type == voxel_type:
            new_button.pressed = true
    
        
        
func _process(_delta):
    """FPS label text update."""
    $FPSLabel.text = "FPS: %d  " % Engine.get_frames_per_second()


func deselect_buttons():
    """Set all buttons to deselected mode"""
    for button in button_container.get_children():
        button.pressed = false
    

