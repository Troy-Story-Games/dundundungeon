extends Spatial


onready var animationPlayer = $Animations/AnimationPlayer


func _ready():
    print("Hello!!!")
    animationPlayer.play("Dance")

func _process(_delta):
    if not animationPlayer.is_playing():
        animationPlayer.play("Dance")
