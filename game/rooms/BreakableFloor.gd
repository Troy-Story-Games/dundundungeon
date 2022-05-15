extends StaticBody

export(bool) var START_ENABLED = false

var enabled: bool = false

onready var hurtbox: Hurtbox = $Hurtbox
onready var animationPlayer = $AnimationPlayer
onready var collider = $CollisionShape


func _ready():
    enabled = START_ENABLED


func break_floor():
    collider.disabled = true
    animationPlayer.play("Break")


func _on_Hurtbox_take_damage(_damage, _area):
    if not enabled:
        return
    hurtbox.disabled = true
    enabled = false
    break_floor()
