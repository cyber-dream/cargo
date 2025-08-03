class_name CargoFigure
extends Node2D


@export var difficulty: Gameplay.Difficulty
@export var area_2d: Area2D

## Private

var _is_drag = false
var _init_offset = Vector2.ZERO
var _init_pos: Vector2


func _ready() -> void:
	CargoDnD.register_dnd_object(self, area_2d)
	area_2d.set_meta("is_figure", true)
