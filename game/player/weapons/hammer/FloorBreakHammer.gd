extends RigidBody
class_name FloorBreakHammer

const GlowingRed = preload("res://assets/objects/weapons/GlowingRed.material")

var controller: ARVRController = null

onready var animationPlayer = $AnimationPlayer
onready var collider = $CollisionShape
onready var pickupArea = $ObjectPickupArea
onready var particles = $hammer_rare_long/CPUParticles
onready var hammer = $hammer_rare_long
onready var hitbox = $Hitbox


func _ready():
    particles.emitting = false
    pickupArea.disabled = true
    collider.disabled = true
    hitbox.disabled = true


func appear():
    animationPlayer.play("Appear")
    SoundFx.play_3d("HammerAppear", global_transform.origin)
    pickupArea.disabled = false
    collider.disabled = false
    hitbox.disabled = false


func interact(controller: ARVRController):
    particles.emitting = false
    animationPlayer.stop()


func dropped():
    particles.emitting = true
    animationPlayer.play("Hover")


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Appear":
        animationPlayer.play("Hover")
        hammer.set_surface_material(3, GlowingRed)
