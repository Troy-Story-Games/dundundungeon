extends Projectile
class_name CrossbowBolt

export(float) var IMPULSE = 5.0


func handle_collision(collision: KinematicCollision):
    .handle_collision(collision)
    var collider = collision.collider
    var old_transform = global_transform
    var new_parent = collider

    get_parent().remove_child(self)
    new_parent.add_child(self)

    # Make sure we're at the right spot
    global_transform = old_transform

    print("Collided with: ", collider)
    if collider.has_method("apply_impulse"):
        var impulse_direction = global_transform.origin.direction_to(collider.global_transform.origin).normalized()
        var impulse = impulse_direction * IMPULSE
        if collider is PhysicalBone:
            var enemy = collider.get_parent().get_parent().get_parent()
            if enemy is Enemy:
                SoundFx.play_3d("ArrowHitEnemy3", global_transform.origin)
                enemy.defer_impulse(collider, collision.position, impulse)
        else:
            collider.apply_impulse(collision.position, impulse)
            SoundFx.play_3d("ArrowHitObject", global_transform.origin)
