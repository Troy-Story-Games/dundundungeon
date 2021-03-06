extends KinematicBody
class_name Enemy

const PoofParticles = preload("res://game/fx/poof/PoofCPUParticles.tscn")

export(int) var MAX_HEALTH = 1
export(float) var SPEED = 1.0

var speed: float = 0.0
var velocity: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO
var ragdoll: bool = false
var health: int setget set_health
var meshes: Array = []
var deferred_impulses: Array = []
var player_camera: ARVRCamera = null setget set_player_camera,get_player_camera

onready var bodyBones = $Animations/Skeleton/PhysicalBoneBody
onready var characterAnimationPlayer = $Animations/AnimationPlayer
onready var skeleton = $Animations/Skeleton
onready var deathTimer = $DeathTimer
onready var collider = $CollisionShape
onready var headHurtbox = $HeadHurtbox
onready var bodyHurtbox = $BodyHurtbox

onready var bodyRT = $Animations/Skeleton/Body/RemoteTransform
onready var headRT = $Animations/Skeleton/Head/RemoteTransform
onready var armLeftRT = $Animations/Skeleton/ArmLeft/RemoteTransform
onready var armRightRT = $Animations/Skeleton/ArmRight/RemoteTransform
onready var handLeftRT = $Animations/Skeleton/HandSlotLeft/RemoteTransform
onready var handRightRT = $Animations/Skeleton/HandSlotRight/RemoteTransform


func _ready():
    self.health = MAX_HEALTH
    speed = SPEED


func set_player_camera(value: ARVRCamera):
    player_camera = value


func get_player_camera():
    if player_camera:
        return player_camera
    player_camera = get_tree().current_scene.find_node("ARVRCamera")
    return player_camera


func _process(_delta):
    if ragdoll:
        return
    if not characterAnimationPlayer.is_playing():
        characterAnimationPlayer.play("Dance")


func _physics_process(delta):
    if ragdoll and len(deferred_impulses) > 0:
        for impulse in deferred_impulses:
            impulse[0].apply_impulse(impulse[1], impulse[2])
        deferred_impulses.clear()

    if ragdoll:
        return  # Don't need to move if we're ragdoll

    if not self.player_camera:
        return

    direction = global_transform.origin.direction_to(player_camera.global_transform.origin).normalized()
    direction.y = 0  # Only need the x,z direction
    velocity = (direction * speed) * delta
    look_at(global_transform.origin - direction, Vector3.UP)

    # warning-ignore:return_value_discarded
    move_and_collide(velocity, false)


func disconnect_remote_transform(remote_xform: RemoteTransform):
    remote_xform.update_position = false
    remote_xform.update_rotation = false
    remote_xform.update_scale = false


func set_health(value: int):
    # warning-ignore:narrowing_conversion
    health = clamp(value, 0, MAX_HEALTH)
    if health == 0:
        ragdoll = true
        headHurtbox.disabled = true
        bodyHurtbox.disabled = true
        collider.disabled = true

        # This is real dumb but ragdolls in godot are garbage
        disconnect_remote_transform(headRT)
        disconnect_remote_transform(bodyRT)
        disconnect_remote_transform(armLeftRT)
        disconnect_remote_transform(armRightRT)
        disconnect_remote_transform(handLeftRT)
        disconnect_remote_transform(handRightRT)

        skeleton.physical_bones_start_simulation()
        deathTimer.start()


func defer_impulse(bone: PhysicalBone, position: Vector3, impulse: Vector3):
    deferred_impulses.append([bone, position, impulse])


func take_damage(damage):
    self.health -= damage
    SoundFx.play_3d("EnemyTakeDamage3", global_transform.origin)


func _on_BodyHurtbox_take_damage(damage, _area):
    SoundFx.play_3d("SwordHitEnemy5", global_transform.origin)
    take_damage(damage)


func _on_HeadHurtbox_take_damage(damage, _area):
    SoundFx.play_3d("ArrowHitEnemy3", global_transform.origin)
    take_damage(damage)


func _on_DeathTimer_timeout():
    var particles : CPUParticles = Utils.instance_scene_on_main(PoofParticles, bodyBones.global_transform) as CPUParticles
    particles.emitting = true
    SoundFx.play_3d("EnemyDisappear", global_transform.origin)
    queue_free()
