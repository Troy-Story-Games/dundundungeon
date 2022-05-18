extends Node

# Auto-load singleton to play sound effects

var sounds_path = "res://game/audio/soundfx/sounds/"

var sounds := {}

onready var sound_players := $StreamPlayers.get_children()
onready var sound_players_3d := $StreamPlayers3D.get_children()


func _ready():
    load_sound_fx()


func load_sound_fx():
    if len(sounds.keys()) != 0:
        return

    var dir := Directory.new()
    dir.open(sounds_path)
    dir.list_dir_begin(true, true)
    var check = dir.get_next()
    while check != "":
        var full_path = sounds_path + check
        if check.ends_with(".ogg"):
            var fx_name: String = check.split(".", false, 1)[0]
            print("Found Sound effect: ", check)
            print("Access by name: ", fx_name)
            sounds[fx_name] = load(full_path)
        check = dir.get_next()


func play(sound_string : String, pitch_scale : float = 1, volume_db : float = 0):
    for player in sound_players:
        if not player.playing:
            player.pitch_scale = pitch_scale
            player.volume_db = volume_db
            player.stream = sounds[sound_string]
            player.play()
            return
    print("WARNING: Too many sounds playing at once!")


func play_3d(sound_string : String, origin : Vector3, pitch_scale : float = 1.0, volume_db : float = 0.0, max_distance : float = 0.0):
    for player in sound_players_3d:
        if not player.playing:
            player.pitch_scale = pitch_scale
            player.unit_db = volume_db
            player.stream = sounds[sound_string]
            player.global_transform.origin = origin
            player.max_distance = max_distance
            player.play()
            return
    print("WARNING: Too many 3D sounds playing at once!")
