@tool
class_name CargoTruck
extends Node2D

@export var field: CargoField
@export var back: Sprite2D
@export var frame: Sprite2D
@export var background: Sprite2D
@export var size: Vector2i:
	get(): return size
	set(in_size):
		size = in_size
		if !Engine.is_editor_hint(): return
		
		_resize_truck()

func _ready() -> void:
	field.size = size
	field.generate_field()
	_resize_truck()
	

func _resize_truck(): 
	back.position.x = -field.tile_size * field.size.x
	frame.scale.x = (field.size.x - 4)
	var texture = background.texture as GradientTexture2D
	texture.width = (field.size.x * field.tile_size) + (field.gap * field.size.x) + field.gap
	texture.height = (field.size.y * field.tile_size) + (field.gap * field.size.y) + field.gap
