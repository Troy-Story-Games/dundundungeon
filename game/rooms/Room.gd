extends Spatial

var next_room = null


func _ready():
    next_room = Utils.get_random_room()
