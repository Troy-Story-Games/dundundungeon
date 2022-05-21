extends Spatial
class_name GameRoom

onready var nextRoomSpawn = $NextRoomSpawn
onready var prevRoomSpawn = $PrevRoomSpawn


func get_next_room_spawn() -> Transform:
    return nextRoomSpawn.global_transform


func get_prev_room_spawn() -> Transform:
    return prevRoomSpawn.global_transform


func spawn_room(spawn_transform: Transform):
    global_transform = spawn_transform
    global_transform.origin += prevRoomSpawn.global_transform.origin
    visible = false


func start_room():
    visible = true
    # TODO: Enable the enemy spanwers - have them disabled by default
