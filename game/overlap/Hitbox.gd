extends Area
class_name Hitbox

# warning-ignore:unused_class_variable
export(int) var DAMAGE = 1

var disabled: bool = false setget set_disabled

onready var collider = $CollisionShape


func set_disabled(value: bool):
    disabled = value
    collider.disabled = disabled
