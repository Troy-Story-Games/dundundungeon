extends Weapon
class_name Sword


func appear():
    .appear()
    SoundFx.play_3d("SwordAppear", global_transform.origin)
