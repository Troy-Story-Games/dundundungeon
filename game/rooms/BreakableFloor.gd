extends StaticBody

export(bool) var START_ENABLED = false

var enabled: bool = false setget set_enabled

onready var hurtbox: Hurtbox = $Hurtbox
onready var animationPlayer = $AnimationPlayer
onready var collider = $CollisionShape
onready var floorBreakHammer = $FloorBreakHammer


func _ready():
    self.enabled = START_ENABLED


func break_floor():
    collider.disabled = true
    animationPlayer.play("Break")


func set_enabled(value: bool):
    enabled = value
    if enabled:
        floorBreakHammer.appear()


func _on_Hurtbox_take_damage(_damage, _area):
    if not self.enabled:
        return
    hurtbox.disabled = true
    enabled = false
    break_floor()
