extends Spatial

export(String, FILE, "*.mp3") var SONG = null

var next_room = null

onready var audioStreamPlayer = $AudioStreamPlayer


func _ready():
    next_room = Utils.get_random_room()
    var song = load(SONG)
    audioStreamPlayer.stream = song
    audioStreamPlayer.play()
