extends Spatial
class_name Enemy

const PoofParticles = preload("res://game/fx/poof/PoofCPUParticles.tscn")

export(int) var MAX_HEALTH = 1

var ragdoll: bool = false
var health: int setget set_health
var meshes: Array = []
var deferred_impulses: Array = []

onready var bodyBones = $Animations/Skeleton/PhysicalBoneBody
onready var characterAnimationPlayer = $Animations/AnimationPlayer
onready var skeleton = $Animations/Skeleton
onready var deathTimer = $DeathTimer


func _ready():
    self.health = MAX_HEALTH


func _process(delta):
    if ragdoll:
        return
    if not characterAnimationPlayer.is_playing():
        characterAnimationPlayer.play("Dance")

    var player: VRPlayer = get_tree().current_scene.find_node("VRPlayer")
    var direction = global_transform.origin.direction_to(player.global_transform.origin).normalized()
    global_transform.origin = global_transform.origin + ((direction) * delta)


func _physics_process(_delta):
    if ragdoll and len(deferred_impulses) > 0:
        for impulse in deferred_impulses:
            impulse[0].apply_impulse(impulse[1], impulse[2])
        deferred_impulses.clear()


func set_health(value: int):
    health = clamp(value, 0, MAX_HEALTH)
    if health == 0:
        ragdoll = true
        skeleton.physical_bones_start_simulation()
        deathTimer.start()


func defer_impulse(bone: PhysicalBone, position: Vector3, impulse: Vector3):
    deferred_impulses.append([bone, position, impulse])


func take_damage(damage):
    self.health -= damage


func _on_BodyHurtbox_take_damage(damage, _area):
    take_damage(damage)


func _on_HeadHurtbox_take_damage(damage, area):
    take_damage(damage)


func _on_DeathTimer_timeout():
    var particles : CPUParticles = Utils.instance_scene_on_main(PoofParticles, bodyBones.global_transform) as CPUParticles
    particles.emitting = true
    queue_free()
