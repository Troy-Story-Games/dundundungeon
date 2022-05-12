extends "res://addons/godot-openxr/scenes/controller.gd"

enum Buttons {
    VR_BUTTON_BY = JOY_OCULUS_BY,
    VR_GRIP = JOY_VR_GRIP,
    VR_BUTTON_AX = JOY_OCULUS_AX,
    VR_TRIGGER = JOY_VR_TRIGGER
}

enum MovementType {
    NONE,
    DIRECTIONAL,
    TELEPORT,
    ROTATION
}

export(float) var ROTATION_DEGREES = 45.0
export(float) var DIRECTIONAL_MOVEMENT_SPEED = 3.0
export(float) var CONTROLLER_DEADZONE = 0.65
export(MovementType) var MOVEMENT_TYPE = MovementType.TELEPORT
export(Buttons) var PICKUP_BUTTON = Buttons.VR_TRIGGER

var origin_node: ARVROrigin = null
var vr_camera: ARVRCamera = null
var controller_velocity := Vector3.ZERO
var prior_controller_position := Vector3.ZERO
var prior_controller_velocities := []
var joystick_vector := Vector2.ZERO
var joystick_x_axis := JOY_ANALOG_LX
var joystick_y_axis := JOY_ANALOG_LY
var just_rotated := false
var pickup_area: Area = null
var grab_position: Position3D = null
var held_object: Node = null
var held_object_data := {"mode": RigidBody.MODE_RIGID, "layer": 1, "mask": 1}


func _ready():
    grab_position = find_node("GrabPosition") as Position3D
    pickup_area = find_node("PickupArea") as Area
    origin_node = get_parent() as ARVROrigin
    vr_camera = origin_node.find_node("*Camera") as ARVRCamera

    # Crash if we don't have the required nodes
    assert(vr_camera != null)
    assert(pickup_area != null)
    assert(grab_position != null)

    connect("button_pressed", self, "_on_button_pressed")
    connect("button_release", self, "_on_button_release")


func _physics_process(delta):
    if not get_is_active():
        return

    # Update the held object's position
    if held_object:
        held_object.global_transform = grab_position.global_transform

    joystick_vector = Vector2(
        get_joystick_axis(joystick_x_axis),
        -get_joystick_axis(joystick_y_axis)
    )

    if joystick_vector.length() < CONTROLLER_DEADZONE:
        joystick_vector = Vector2.ZERO

    update_velocity(delta)
    handle_directional_movement(delta)
    handle_rotation_movement()


func update_velocity(delta):
    # Reset the controller velocity
    controller_velocity = Vector3.ZERO

    if prior_controller_velocities.size() > 0:
        for vel in prior_controller_velocities:
            controller_velocity += vel

        # Get the average velocity, instead of just adding them together.
        controller_velocity = controller_velocity / prior_controller_velocities.size()

    # Add the most recent controller velocity to the list of proper controller velocities
    prior_controller_velocities.append((global_transform.origin - prior_controller_position) / delta)

    # Calculate the velocity using the controller's prior position.
    controller_velocity += (global_transform.origin - prior_controller_position) / delta
    prior_controller_position = global_transform.origin

    # If we have more than a third of a seconds worth of velocities, then we
    # should remove the oldest
    if prior_controller_velocities.size() > 30:
        prior_controller_velocities.remove(0)


func handle_rotation_movement():
    if MOVEMENT_TYPE != MovementType.ROTATION:
        return
    if joystick_vector.x == 0:
        just_rotated = false
        return

    if just_rotated:
        return
    just_rotated = true

    var rotate_amnt :float = ROTATION_DEGREES
    if joystick_vector.x < 0:
        rotate_amnt *= -1

    rotate_player(rotate_amnt)


func rotate_player(angle: float):
    var t1 := Transform()
    var t2 := Transform()
    var rot := Transform()

    t1.origin = -vr_camera.transform.origin
    t2.origin = vr_camera.transform.origin
    rot = rot.rotated(Vector3(0.0, -1.0, 0.0), angle)
    origin_node.transform = (origin_node.transform * t2 * rot * t1).orthonormalized()


func handle_directional_movement(delta):
    if MOVEMENT_TYPE != MovementType.DIRECTIONAL:
        return
    if joystick_vector == Vector2.ZERO:
        return

    var forward_direction : Vector3 = vr_camera.transform.basis.z.normalized()
    var right_direction : Vector3 = vr_camera.transform.basis.x.normalized()

    var movement_forward : Vector3 = forward_direction * joystick_vector.y * delta * DIRECTIONAL_MOVEMENT_SPEED
    var movement_right : Vector3 = right_direction * joystick_vector.x * delta * DIRECTIONAL_MOVEMENT_SPEED

    movement_forward.y = 0
    movement_right.y = 0

    if movement_right.length() > 0 or movement_forward.length() > 0:
        # warning-ignore:unsafe_method_access
        get_parent().translate(movement_right + movement_forward)


func handle_pickup():
    # Pick up RigidBody if we are not holding a object
    if held_object:
        return

    var rigid_body : RigidBody = null
    var bodies : Array = pickup_area.get_overlapping_bodies()
    for body in bodies:
        if body is RigidBody and body.mode == RigidBody.MODE_RIGID:
            rigid_body = body
            break

    if not rigid_body:
        return

    # Assign held object to it.
    held_object = rigid_body
    grab_position.global_transform = held_object.global_transform

    # Store the now held RigidBody's information.
    held_object_data.mode = held_object.mode
    held_object_data.layer = held_object.collision_layer
    held_object_data.mask = held_object.collision_mask

    # Set it to static, TODO - do we make it collide or not?
    held_object.mode = RigidBody.MODE_STATIC

    # If the RigidBody has a function called picked_up, then call it.
    if held_object.has_method("picked_up"):
        # warning-ignore:unsafe_method_access
        held_object.picked_up()

    # If the RigidBody has a variable called controller, then assign it to this controller.
    if "controller" in held_object:
        held_object.controller = self


func handle_drop():
    if not held_object:
        return

    # Reset the grab position
    grab_position.translation = Vector3.ZERO

    # Set the held object's RigidBody data back to what is stored.
    held_object.mode = held_object_data["mode"]
    held_object.collision_layer = held_object_data["layer"]
    held_object.collision_mask = held_object_data["mask"]

    # Apply a impulse in the direction of the controller's velocity.
    held_object.apply_impulse(Vector3.ZERO, controller_velocity)

    # If the RigidBody has a function called dropped, then call it.
    if held_object.has_method("dropped"):
        # warning-ignore:unsafe_method_access
        held_object.dropped()

    # If the RigidBody has a variable called controller, then set it to null
    if "controller" in held_object:
        held_object.controller = null

    # Set held_object to null since this controller is no longer holding anything.
    held_object = null


func _on_button_pressed(button: int):
    if button == PICKUP_BUTTON:
        handle_pickup()


func _on_button_release(button: int):
    if button == PICKUP_BUTTON:
        handle_drop()

