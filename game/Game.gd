extends Spatial

const StartRoom: PackedScene = preload("res://game/rooms/StartRoom.tscn")

var next_room: PackedScene = null
var current_room: GameRoom = null
var playerStats: PlayerStats = null

onready var vrPlayer = $VRPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
    playerStats = Utils.get_player_stats() as PlayerStats
    playerStats.connect("player_died", self, "_on_PlayerStats_player_died")
    start_game()


func start_game():
    current_room = StartRoom.instance() as GameRoom
    add_child(current_room)
    vrPlayer.global_transform = current_room.get_prev_room_spawn()
    get_next_room()


func get_next_room():
    next_room = Utils.get_random_room()


func enable_next_room():
    var instance: GameRoom = next_room.instance()
    add_child(instance)
    instance.spawn_room(current_room.get_next_room_spawn())



func _on_PlayerStats_player_died():
    print("PLAYER DIED - Handle this")
