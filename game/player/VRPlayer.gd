extends Spatial
class_name VRPlayer


func _on_SleepArea_body_entered(body):
    if "can_sleep" in body:
        body.can_sleep = false
        body.sleeping = false


func _on_SleepArea_body_exited(body):
    if "can_sleep" in body:
        body.can_sleep = true
