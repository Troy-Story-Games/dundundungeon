extends Spatial
class_name EnemySpawner


func _ready():
    if len(Utils.enemies) == 0:
        Utils.load_enemies()


func _on_Timer_timeout():
    var enemy = Utils.get_random_enemy()
    if not enemy:
        return
    Utils.instance_scene_on_main(enemy, global_transform)
