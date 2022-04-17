extends Node
class_name CombatInputUI

var screen_is_being_dragged = false
var screen_is_being_pinched = false
var left_button_pressed = false
var drag_position = null
var drag_vector = null
var drag_position2 = null
var drag_vector2 = null
var drag_threshold = 10

const MOUSE_SENSITIVITY= 0.01
const PINCH_ZOOM_FACTOR = 0.03
const TOUCH_SENSITIVITY = 0.0001


func _init():
    screen_is_being_dragged = false
    left_button_pressed = false
    drag_vector = null
    drag_threshold = 10


func handle_screen_pinch(camera): 
    # use average of the two finger drag vectors to direct any panning
    var pan_vector = (drag_vector + drag_vector2) / 2.0
    camera.pan(pan_vector*MOUSE_SENSITIVITY)
    
    # pinch/zoom based on how far away the drag events are at
    var start_distance = drag_position.distance_to(drag_position2)
    var end_distance = (drag_position + drag_vector).distance_to(drag_position2 + drag_vector2)
    if start_distance < end_distance:
        camera.zoom(true, PINCH_ZOOM_FACTOR) # zoom in.....
    else:
        camera.zoom(false, PINCH_ZOOM_FACTOR) # zoom out....


func handle_player_camera_ui(event, camera):
    # Handles:
    #       Touchscreen: pinch zoom, finger drag camera pan
    #       Mouse      : scroll wheel zoom, right click/drag camera pan
    
    if event is InputEventScreenTouch and not event.is_pressed():
        screen_is_being_pinched = false
    
    if event is InputEventScreenDrag:
        
        # first, record the first two 
        if event.index == 0:
            drag_position = event.position
            drag_vector = event.relative
        if event.index == 1:
            drag_position2 = event.position
            drag_vector2 = event.relative   
         
        # one finger pan
        if not screen_is_being_pinched:
            var drag_speed = event.get_speed()
            camera.pan(drag_speed*TOUCH_SENSITIVITY)
                
        if drag_vector2 and drag_vector:
            screen_is_being_pinched = true # set to false in InputEventScreenTouch event above
            handle_screen_pinch(camera)
        
                
    else:
        drag_position = null
        drag_position2 = null
        drag_vector = null
        drag_vector2 = null
            

    if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_RIGHT):
        camera.pan(event.relative*MOUSE_SENSITIVITY)

    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == BUTTON_WHEEL_UP :
            camera.zoom(true) # zoom in.....
        if event.button_index == BUTTON_WHEEL_DOWN:
            camera.zoom(false) # zoom out....


var registered_ui_object = null
func register_ui_object(ui_object):
    """Signifies that ui_object will be handling mouse/touch UI events until
    the left click is lifted. If this works well we could extend it to right
    clicks for menus, investigation checks, etc...
    
    TODO: check of some other fucker tries to register and clobbers this
        for now, returns omethign that can say it failed
         it can't happen cuz we only have one thing trying to call this
    """
    registered_ui_object = ui_object


func deregister_ui_object():
    # called by the ui object or by handle_input below if the mouse press is released
    #   from some other fucked up code
    registered_ui_object = null
        
    # reset all ui variable to their base state. 
    screen_is_being_dragged = false
    screen_is_being_pinched = false
    left_button_pressed = false
    drag_position = null
    drag_vector = null
    drag_position2 = null
    drag_vector2 = null
    

func handle_input(event, game_scene):
    """All the camera zoom and pan functionality is controlled here. If a game
    object calls usurp_control(game_object) then game_object.handle_input(event)
    
    """
    if registered_ui_object:
        if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
            # then the object needs to be deregistered, call mouse release in case the
            # mouse was off of the object when the release happened
            registered_ui_object.handle_left_mouse_release()
            deregister_ui_object()
        else:
            # just let the ui object handle inputs until the mouse button is released
            return

    handle_player_camera_ui(event, game_scene.camera)
    
    if event is InputEventScreenDrag:
        screen_is_being_dragged = true
    
    if event is InputEventMouseMotion:
        if drag_vector == null:
            drag_vector = event.relative
        else:
            drag_vector += event.relative

        if left_button_pressed and drag_vector.length() > drag_threshold:
            screen_is_being_dragged = true

    if event is InputEventMouseButton and not event.is_pressed():
        if event.button_index == BUTTON_LEFT:
            left_button_pressed = false
            drag_vector = null
            if screen_is_being_dragged:
                screen_is_being_dragged = false
                
#    if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
#        combat_scene.clear_target()
#        # collision objects are responsible for re-setting the new target now.
                
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == BUTTON_LEFT:
            left_button_pressed = true

    elif event is InputEventKey and event.pressed:
        match event.scancode:
            KEY_SPACE:
                game_scene.end_turn()
            KEY_W:
                game_scene.player.translate(Vector3.FORWARD)                
            KEY_A:
                game_scene.player.translate(Vector3.LEFT) 
            KEY_S:
                game_scene.player.translate(Vector3.BACK) 
            KEY_D:
                game_scene.player.translate(Vector3.RIGHT) 
