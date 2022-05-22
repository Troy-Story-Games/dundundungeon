extends GameRoom
class_name StartRoom

var done: bool = false

onready var animationPlayer = $AnimationPlayer
onready var door = $Door
onready var ground = $PlayerArea/StartAreaEnvironment/Ground


func _on_Area_body_entered(_body):
    if done:
        return
    done = true
    SoundFx.play_3d("DoorClose09", door.global_transform.origin)
    animationPlayer.play("DoorClose")


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "DoorClose":
        ground.queue_free()
