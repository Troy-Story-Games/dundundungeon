extends Area
class_name ObjectPickupArea

var pickup_object: RigidBody = null
var disabled: bool = false setget set_disabled

onready var collider = $CollisionShape


func _ready():
    pickup_object = get_parent() as RigidBody


func set_disabled(value: bool):
    disabled = value
    collider.disabled = disabled
