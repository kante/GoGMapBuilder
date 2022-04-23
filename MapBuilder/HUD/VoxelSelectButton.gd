extends TextureButton


# initialized in the MapBuilderHUD
var hud = null
var voxel_type = null
onready var sprite = $Sprite


func _on_VoxelSelectButton_pressed():
    if hud:
        hud.voxel_type = voxel_type
        hud.deselect_buttons()
        
        pressed = true 
