extends Spatial
class_name GameRoom

onready var nextRoomSpawn = $NextRoomSpawn
onready var prevRoomSpawn = $PrevRoomSpawn


func get_next_room_spawn() -> Transform:
    return nextRoomSpawn.global_transform


func get_prev_room_spawn() -> Transform:
    return prevRoomSpawn.global_transform

func start_room():
    for child in get_children():
        if child is EnemySpawner:
            child.enabled = true


func _on_BreakableFloor_floor_break():
    get_parent().next_room.start_room()
