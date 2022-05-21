extends "res://game/rooms/Room.gd"


onready var animationPlayer = $AnimationPlayer


func _on_DoorCloseArea_body_entered(body):
    animationPlayer.play("DoorClose")
    # TODO: Play door close noise

