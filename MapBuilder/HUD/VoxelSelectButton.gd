extends TextureButton


# initialized in the MapBuilderHUD
var hud = null
var voxel_type = null
onready var atlas_texture = $TextureRect.texture
onready var label = $Label


func set_texture(new_rect, texture_name):
    """Sets the texture, yo."""
    atlas_texture.region = new_rect
    label.text = texture_name
    

func _on_VoxelSelectButton_pressed():
    """Select the texture represented by this VoxelSelectButton, yo."""
    if hud:
        hud.voxel_type = voxel_type
        hud.deselect_buttons()
        
        pressed = true 
