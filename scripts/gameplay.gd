class_name Gameplay
extends Node2D

enum Difficulty {
	EASY, 
	MEDIUM,
	HARD
}

@export var levels: Array[Level]
@export var truck_prefab: PackedScene

## Private

var _cur_level: int = 0

func _init() -> void:
	pass

func _ready() -> void:
	var truck = truck_prefab.instantiate()
	
	self.add_child(truck)
