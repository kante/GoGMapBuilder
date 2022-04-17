extends Spatial


onready var camera = $PitchYaw/Camera
onready var pitch_yaw = $PitchYaw

var combatant = null


func follow_combatant(new_combatant):
    var old_parent = get_parent()
    if old_parent:
        old_parent.remove_child(self)
    
    combatant = new_combatant
    new_combatant.add_child(self)
    
    var camera_position = camera.global_transform.origin
    camera.look_at_from_position(camera_position, combatant.get_camera_target(), Vector3.UP)


func zoom(zoom_in, zoom_factor=0.1):
    # moves the camera towards character if zoom_in is true, away if zoom_in is false.
    var camera_target = combatant.get_camera_target()
    var camera_position = camera.global_transform.origin
    
    var target_vector = camera_target - camera_position
    var min_distance = 0.1
    var max_distance = 10.0
    var current_distance = target_vector.length()

    
    if zoom_in and current_distance < min_distance:
        return
    if not zoom_in and current_distance > max_distance:
        return
    
    if zoom_in:
        camera.global_translate(target_vector*zoom_factor)
    else:
        camera.global_translate(-target_vector*zoom_factor)
    

func pan(pan_vector):
    # Not really a pan, but rotation of camera so that it looks at the target
    var camera_target = combatant.camera_target.transform.origin
    
    # first rotate for horizontal mouse motion (circle around y-axis in same horizontal plane)
    translate(camera_target)
    rotate(Vector3.UP, -pan_vector.x)
    translate(-camera_target)
    
    
    # now do the rotation for vertical mouse motion. 
    var forward = combatant.camera_target.global_transform.origin - camera.global_transform.origin
    var theta = forward.angle_to(Vector3.DOWN)
    var delta_theta = -pan_vector.y

    pitch_yaw.translate(camera_target)
    # don't rotate past looking straight down, or straight up
    if delta_theta < 0 and theta + delta_theta > 0.05 or\
        delta_theta > 0 and theta + delta_theta < PI - 0.05:
        pitch_yaw.rotate(-Vector3.RIGHT, delta_theta)
    pitch_yaw.translate(-camera_target)
        
    


