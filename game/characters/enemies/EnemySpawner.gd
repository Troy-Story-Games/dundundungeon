extends Spatial
class_name EnemySpawner

const PoofParticles = preload("res://game/fx/poof/PoofCPUParticles.tscn")

export(int) var MAX_HEALTH = 5
export(bool) var ENABLED = true
export(float) var SPAWN_INTERVAL = 5.0

var health := 0 setget set_health

onready var spawnTimer = $SpawnTimer
onready var pointer = $Pointer
onready var dummy = $DummyEnemy
onready var gravestone = $gravestone


func _ready():
    self.health = MAX_HEALTH
    spawnTimer.wait_time = SPAWN_INTERVAL
    pointer.visible = false
    dummy.visible = false
    if ENABLED:
        spawnTimer.start()


func set_health(value: int):
    health = clamp(value, 0, MAX_HEALTH)
    if health == 0:
        var particles : CPUParticles = Utils.instance_scene_on_main(PoofParticles, gravestone.global_transform) as CPUParticles
        particles.emitting = true
        SoundFx.play_3d("EnemyDisappear", global_transform.origin)
        queue_free()


func _on_Timer_timeout():
    var enemy = Utils.get_random_enemy()
    if not enemy:
        return
    # warning-ignore:return_value_discarded
    Utils.instance_scene_on_main(enemy, global_transform)
    SoundFx.play_3d("EnemyAppear2", global_transform.origin)


func _on_Hurtbox_take_damage(damage, _area):
    self.health -= damage
