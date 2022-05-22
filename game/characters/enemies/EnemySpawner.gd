extends Spatial
class_name EnemySpawner

const PoofParticles = preload("res://game/fx/poof/PoofCPUParticles.tscn")
const DamageParticles = preload("res://game/fx/poof/DamageCPUParticles.tscn")

export(int) var MAX_HEALTH = 5
export(float) var SPAWN_INTERVAL_MIN = 5.0
export(float) var SPAWN_INTERVAL_MAX = 10.0

var health := 0 setget set_health
var enabled: bool = false setget set_enabled

onready var spawnTimer = $SpawnTimer
onready var pointer = $Pointer
onready var dummy = $DummyEnemy
onready var gravestone = $Gravestone
onready var hurtbox_collider = $Gravestone/gravestone/Hurtbox/CollisionShape


func _ready():
    self.health = MAX_HEALTH
    self.enabled = true
    pointer.visible = false
    dummy.visible = false


func set_enabled(value: bool):
    enabled = value
    if enabled:
        spawnTimer.start(rand_range(SPAWN_INTERVAL_MIN, SPAWN_INTERVAL_MAX))


func set_health(value: int):
    health = clamp(value, 0, MAX_HEALTH)
    if health == 0:
        var particles : CPUParticles = Utils.instance_scene_on_main(PoofParticles, hurtbox_collider.global_transform) as CPUParticles
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
    spawnTimer.start(rand_range(SPAWN_INTERVAL_MIN, SPAWN_INTERVAL_MAX))


func _on_Hurtbox_take_damage(damage, _area):
    self.health -= damage
    SoundFx.play_3d("EnemyTakeDamage3", global_transform.origin)
    var particles : CPUParticles = Utils.instance_scene_on_main(DamageParticles, hurtbox_collider.global_transform) as CPUParticles
    particles.emitting = true

