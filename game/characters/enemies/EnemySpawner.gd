extends Spatial
class_name EnemySpawner

export(float) var SPAWN_INTERVAL = 5.0

onready var spawnTimer = $SpawnTimer
onready var pointer = $Pointer
onready var dummy = $DummyEnemy

func _ready():
    spawnTimer.wait_time = SPAWN_INTERVAL
    pointer.visible = false
    dummy.visible = false
    spawnTimer.start()


func _on_Timer_timeout():
    var enemy = Utils.get_random_enemy()
    if not enemy:
        return
    Utils.instance_scene_on_main(enemy, global_transform)
