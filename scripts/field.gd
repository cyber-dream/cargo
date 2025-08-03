@tool
class_name CargoField
extends Node2D

@export var gap: int = 2
@export var tile_size: int = 32
@export var size: Vector2i:
	set(in_size):
		size = in_size
		if !Engine.is_editor_hint(): return
		generate_field()
	
@export var field_cell_prefab: PackedScene

func _enter_tree() -> void:
	generate_field()

func generate_field():
	for c in self.get_children():
		c.queue_free()
	
	for idx in size.x:
		for idy in size.y:
			var cell = field_cell_prefab.instantiate() as Node2D
			cell.position = Vector2i(idx * -tile_size - (gap*idx), idy * -tile_size - (gap*idy))
			
			self.add_child(cell)
