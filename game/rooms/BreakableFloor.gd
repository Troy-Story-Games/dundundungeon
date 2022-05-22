extends StaticBody

signal floor_break

export(bool) var START_ENABLED = false

var enabled: bool = false setget set_enabled

onready var hurtbox: Hurtbox = $Hurtbox
onready var animationPlayer = $AnimationPlayer
onready var collider = $CollisionShape
onready var floorBreakHammer = $FloorBreakHammer
onready var enableCheck = $EnableCheck


func _ready():
    self.enabled = START_ENABLED


func break_floor():
    emit_signal("floor_break")
    collider.disabled = true
    animationPlayer.play("Break")
    SoundFx.play_3d("FloorBreak3", global_transform.origin)


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


func _on_EnableCheck_timeout():
    if len(get_tree().get_nodes_in_group("Enemy")) == 0:
        self.enabled = true
        enableCheck.stop()
