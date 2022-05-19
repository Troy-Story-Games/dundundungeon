extends Spatial

var next_room = null


func _ready():
    # This only does something on first call
    Utils.load_rooms()
    next_room = Utils.get_random_room()
