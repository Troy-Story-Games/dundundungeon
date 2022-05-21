extends GameRoom
class_name StartRoom

onready var animationPlayer = $AnimationPlayer
onready var door = $Door
onready var ground = $PlayerArea/StartAreaEnvironment/Ground


func _on_Area_body_entered(_body):
    SoundFx.play_3d("DoorClose09", door.global_transform.origin)
    animationPlayer.play("DoorClose")


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "DoorClose":
        ground.visible = false
