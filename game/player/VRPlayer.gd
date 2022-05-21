extends Spatial
class_name VRPlayer

var playerStats = null


func _ready():
    playerStats = Utils.get_player_stats()


func _on_SleepArea_body_entered(body):
    if "can_sleep" in body:
        body.can_sleep = false
        body.sleeping = false


func _on_SleepArea_body_exited(body):
    if "can_sleep" in body:
        body.can_sleep = true


func _on_Hurtbox_take_damage(damage, _area):
    playerStats.health -= damage
    # TODO: Play sound and effect
