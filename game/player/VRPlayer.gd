extends Spatial
class_name VRPlayer

export(float) var GRAVITY = 9.8
export(float) var MAX_FALL_SPEED = 100.0

var playerStats: PlayerStats = null
var fall_speed: float = 0.0

onready var arvrOrigin = $FPController
onready var rayCast: RayCast = $FPController/RayCast


func _ready():
    playerStats = Utils.get_player_stats()


func _physics_process(delta):
    rayCast.force_raycast_update()
    if rayCast.is_colliding():
        if fall_speed > 0.0:
            print("NEVER STOP!")
            fall_speed = 0.0
            return
        else:
            fall_speed = 0.0
            return
    print("FALLING!!!")
    fall_speed = clamp(fall_speed + GRAVITY, 0, MAX_FALL_SPEED)
    arvrOrigin.global_transform.origin.y -= fall_speed * delta


func _on_SleepArea_body_entered(body):
    if "can_sleep" in body:
        body.can_sleep = false
        body.sleeping = false


func _on_SleepArea_body_exited(body):
    if "can_sleep" in body:
        body.can_sleep = true


func _on_Hurtbox_take_damage(damage, _area):
    playerStats.health -= damage
    SoundFx.play_3d("PlayerTakeDamage2", global_transform.origin)
