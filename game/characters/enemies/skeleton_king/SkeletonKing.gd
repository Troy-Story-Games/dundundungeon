extends Spatial

onready var animationPlayer = $Animations/AnimationPlayer
onready var skeleton = $Animations/Skeleton

var ragdoll: bool = false


func _process(_delta):
    if not ragdoll and not animationPlayer.is_playing():
        animationPlayer.play("Dance")


func _on_HitBox_body_entered(body):
    print("Ragdoll!")
    skeleton.physical_bones_start_simulation()
    ragdoll = true
