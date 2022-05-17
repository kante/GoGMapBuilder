extends TextureButton


# initialized in the MapBuilderHUD
var hud = null
var voxel_type = null
onready var texture_rect = $TextureRect
onready var label = $Label


func set_texture(face_type, texture_name):
    """Sets the texture, yo."""
    match face_type:
        Voxel.BEDROCK:
            texture_rect.texture = load("res://Map/assets/bedrock.png")
        Voxel.COBBLE:
            texture_rect.texture = load("res://Map/assets/cobble.png")
        Voxel.STONE:
            texture_rect.texture = load("res://Map/assets/stone.png")
        Voxel.DIRT:
            texture_rect.texture = load("res://Map/assets/dirt.png")
        Voxel.GRASS:
            texture_rect.texture = load("res://Map/assets/grass_top.png")
        
    label.text = texture_name
    

func _on_VoxelSelectButton_pressed():
    """Select the texture represented by this VoxelSelectButton, yo."""
    if hud:
        hud.voxel_type = voxel_type
        hud.deselect_buttons()
        
        pressed = true 
