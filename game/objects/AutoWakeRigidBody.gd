extends RigidBody
class_name AutoWakeRigidBody


func _on_WakeUpArea_body_entered(_body):
    can_sleep = false


func _on_WakeUpArea_body_exited(_body):
    can_sleep = true
