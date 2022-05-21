extends Resource
class_name PlayerStats

signal player_died

export(int) var MAX_HELATH = 10

var health: int = 0 setget set_health


func _ready():
    self.health = MAX_HELATH


func set_health(value: int):
    health = clamp(value, 0, MAX_HELATH)
    if health == 0:
        print("YOU DIED!")
        emit_signal("player_died")
