extends Area
class_name ObjectPickupArea

var pickup_object: RigidBody = null


func _ready():
    pickup_object = get_parent() as RigidBody
