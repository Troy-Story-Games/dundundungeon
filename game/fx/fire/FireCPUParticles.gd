tool
extends CPUParticles
class_name FireCPUParticles

const MAX_VALUE = 1000000

export(float) var LIGHT_RANGE = 8.0
export(float) var LIGHT_ENERGY = 2.0

var value: float = 0.0

onready var noise = OpenSimplexNoise.new()
onready var omniLight = $OmniLight


func _ready():
    noise.seed = randi()
    omniLight.light_energy = LIGHT_ENERGY
    omniLight.omni_range = LIGHT_RANGE


func _process(_delta):
    # Where to sample the noise. Loop at 1 million (or risk loss of precision)
    value += 0.5
    if value > MAX_VALUE:
        value = 0
    # Cause the torch light to flicker
    var amnt = noise.get_noise_1d(value)
    omniLight.light_energy = LIGHT_ENERGY - (amnt * 2.0)

    omniLight.omni_range -= amnt
    if omniLight.omni_range != LIGHT_RANGE:
        omniLight.omni_range = lerp(omniLight.omni_range, LIGHT_RANGE, 0.85)
