extends Spatial


onready var camera_target = $CameraTarget


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func get_camera_target():
    return camera_target.global_transform.origin
    
