extends Area
class_name PlayerPickupArea

var disabled: bool = false setget set_disabled

onready var collider = $CollisionShape


func set_disabled(value: bool):
    disabled = value
    collider.disabled = disabled
