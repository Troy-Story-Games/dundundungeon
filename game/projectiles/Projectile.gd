extends KinematicBody
class_name Projectile

export(float) var GRAVITY = 0.0
export(float) var SPEED = 75.0

var velocity: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO
var gravity: Vector3 = Vector3.ZERO
var speed: float = 0.0

onready var collider = $CollisionShape
onready var hitbox = $Hitbox


func _ready():
    gravity = Vector3(0, GRAVITY, 0)


func fire(heading: Vector3):
    direction = heading
    speed = SPEED


func _physics_process(delta):
    if direction == Vector3.ZERO or speed == 0.0:
        return

    velocity = direction * speed
    velocity = (velocity + gravity) * delta

    var collision: KinematicCollision = move_and_collide(velocity, false)
    if collision:
        handle_collision(collision)


func handle_collision(collision: KinematicCollision):
    speed = 0.0
    velocity = Vector3.ZERO
    direction = Vector3.ZERO
    collider.disabled = true


func _on_Lifespan_timeout():
    if speed == 0.0 and collider.disabled:
        return
    queue_free()
