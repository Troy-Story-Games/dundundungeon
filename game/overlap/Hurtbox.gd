extends Area
class_name Hurtbox

signal take_damage(damage, area)
signal invincibility_started()
signal invincibility_ended()

var disabled: bool = false setget set_disabled
var invincible: bool = false setget set_invincible

onready var invincibilityTimer: Timer = $InvinvibilityTimer
onready var collider: CollisionShape = $CollisionShape


func set_invincible(value: bool):
    invincible = value
    if invincible == true:
        emit_signal("invincibility_started")
    else:
        emit_signal("invincibility_ended")


func set_disabled(value: bool):
    disabled = value
    collider.disabled = value


func start_invincibility(duration: float):
    self.invincible = true
    invincibilityTimer.start(duration)


func _on_Hurtbox_area_entered(area: Area):
    if area is Hitbox and not self.invincible:
        emit_signal("take_damage", area.DAMAGE, area)


func _on_InvinvibilityTimer_timeout():
    self.invincible = false
