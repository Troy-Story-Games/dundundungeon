extends RigidBody
class_name FloorBreakHammer

var controller: ARVRController = null

onready var animationPlayer = $AnimationPlayer
onready var collider = $CollisionShape
onready var pickupArea = $ObjectPickupArea
onready var particles = $hammer_rare_long/CPUParticles


func _ready():
    pickupArea.disabled = true
    collider.disabled = true


func appear():
    animationPlayer.play("Appear")
    SoundFx.play_3d("HammerAppear", global_transform.origin)
    pickupArea.disabled = false
    collider.disabled = false


func interact(controller: ARVRController):
    particles.emitting = false
    animationPlayer.stop()


func dropped():
    particles.emitting = true
    animationPlayer.play("Hover")


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Appear":
        animationPlayer.play("Hover")
