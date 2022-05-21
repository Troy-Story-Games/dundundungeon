extends Node

var enemies: Array = []
var rooms: Array = []


func instance_scene_on_main(packed_scene: PackedScene, position) -> Node:
    var main := get_tree().current_scene
    var instance : Spatial = packed_scene.instance()
    main.add_child(instance)

    if position is Transform:
        instance.global_transform = position
    elif position is Vector3:
        instance.global_transform.origin = position

    return instance


func load_enemy_dir(path: String):
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin(true, true)
    var check = dir.get_next()
    while check != "":
        if check.ends_with(".tscn"):
            var asset_path = path + "/" + check
            enemies.append(load(asset_path))
            print("Loaded enemy: ", asset_path)
        check = dir.get_next()


func load_enemies():
    if len(enemies) > 0:
        return

    var base = "res://game/characters/enemies/"
    var dir = Directory.new()
    dir.open(base)
    dir.list_dir_begin(true, true)
    var check = dir.get_next()
    while check != "":
        var full_path = base + check
        if dir.current_is_dir():
            load_enemy_dir(full_path)
        check = dir.get_next()


func load_rooms():
    if len(rooms) > 0:
        return

    var base = "res://game/rooms/combat_rooms/"
    var dir = Directory.new()
    dir.open(base)
    dir.list_dir_begin(true, true)
    var check = dir.get_next()
    while check != "":
        var full_path = base + check
        if check.ends_with(".tscn"):
            rooms.append(load(full_path))
            print("Loaded combat room: ", full_path)
        check = dir.get_next()


func get_player_stats() -> Resource:
    return ResourceLoader.load("res://game/player/PlayerStats.tres")


func get_random_room() -> PackedScene:
    if len(rooms) == 0:
        load_rooms()
    rooms.shuffle()
    return rooms[0]


func get_random_enemy() -> PackedScene:
    if len(enemies) == 0:
        load_enemies()
    enemies.shuffle()
    return enemies[0]
