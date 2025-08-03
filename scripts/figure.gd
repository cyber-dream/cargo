class_name CargoFigure
extends Node2D

@export var area_2d: Area2D

## Private

var _is_drag = false
var _init_offset = Vector2.ZERO
var _init_pos: Vector2

func _ready() -> void:
	area_2d.input_event.connect(test)

func test(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var stop_drag: bool = false
			if event.pressed:
				# Проверка: навели ли на объект
				#if get_rect().has_point(to_local(event.position)):
				_is_drag = true
				_init_offset = position - event.position
				_init_pos = position
				
			else:
				_is_drag = false
				
				var overlaps = area_2d.get_overlapping_areas()
				if !_can_drop(overlaps):
					self.position = _init_pos
				else:
					var first_shape = area_2d.get_child(0) as CollisionShape2D
	
					var nearest_idx: int
					var nearest_delta_pos: Vector2 = Vector2(99999999,999999999) # Hehe kill me
					
					
					for overlap_idx in overlaps.size():
						var delta_pos = overlaps[overlap_idx].global_position - first_shape.global_position
						
						if delta_pos < nearest_delta_pos: 
							nearest_delta_pos = delta_pos
							nearest_idx = overlap_idx
						
					
					self.position += nearest_delta_pos
						
					
				
	elif event is InputEventMouseMotion and _is_drag:
		self.position = event.position + _init_offset


func _can_drop(in_overlaps: Array[Area2D]) -> bool:
	if in_overlaps.size() != area_2d.get_child_count():
		return false
	
	return true
