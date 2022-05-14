extends Weapon
class_name Crossbow

const crossbowBolt = preload("res://game/projectiles/CrossbowBolt.tscn")

var can_shoot: bool = true

onready var shotDelay = $ShotDelay
onready var arrow = $crossbow_uncommon/arrow


func trigger():
    if not can_shoot:
        return
    can_shoot = false
    shotDelay.start()
    arrow.visible = false
    animationPlayer.play("DissolveArrow")

    var instance: Projectile = Utils.instance_scene_on_main(crossbowBolt, arrow.global_transform) as Projectile
    instance.fire(arrow.global_transform.basis.xform(Vector3.BACK))


func _on_ShotDelay_timeout():
    can_shoot = true
    arrow.visible = true
    animationPlayer.play_backwards("DissolveArrow")
