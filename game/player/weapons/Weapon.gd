extends KinematicBody
class_name Weapon

onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var hitbox = $Hitbox
onready var collider = $CollisionShape


func _ready():
    # Start invisible
    dissolve()


func appear():
    if not animationPlayer.has_animation("Dissolve"):
        print("ERROR: Cannot play Dissolve animation on weapon. Animation doesn't exist.")
        return

    animationPlayer.play_backwards("Dissolve")
    collider.disabled = false
    hitbox.disabled = false


func dissolve():
    if not animationPlayer.has_animation("Dissolve"):
        print("ERROR: Cannot play Dissolve animation on weapon. Animation doesn't exist.")
        return

    animationPlayer.play("Dissolve")
    collider.disabled = true
    hitbox.disabled = true


func trigger():
    pass  # Override this
