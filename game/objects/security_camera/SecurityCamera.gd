extends Spatial

enum SearchMode {
    NONE,
    TRACK_PLAYER,
    PAN
}

export(SearchMode) var SEARCH_MODE = SearchMode.NONE
export(float) var MAX_ANGLE = 90.0

var track_player: bool = false

onready var animationPlayer = $AnimationPlayer


func _ready():
    match SEARCH_MODE:
        SearchMode.NONE:
            pass
        SearchMode.PAN:
            animationPlayer.play("Pan")
        SearchMode.TRACK_PLAYER:
            track_player = true


func _process(delta):
    pass  # TODO: Track player
