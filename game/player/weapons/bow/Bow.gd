extends Weapon
class_name Bow

onready var arrow = $arrow


func _on_GrabArea_body_entered(body):
    print("Body entered: ", body)
    arrow.visible = true
