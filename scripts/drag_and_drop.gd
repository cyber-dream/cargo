class_name CargoCustomDragAndDrop
extends Node

var _dragging_node: Node2D
var _dragging_area_2d: Area2D
var _init_pointer_offset: Vector2
var _init_pos: Vector2

signal figure_dropped(pallete_idx: int)

func register_dnd_object(in_node: Node2D, in_area_2d: Area2D):
	in_area_2d.input_event.connect(func(viewport: Node, event: InputEvent, shape_idx: int): 
		if event is InputEventMouseButton: 
			if event.button_index == MOUSE_BUTTON_LEFT:
				var stop_drag: bool = false
				if event.pressed:
					# Проверка: навели ли на объект
					#if get_rect().has_point(to_local(event.position)):
					if _dragging_node != null: 
						return
					
					_dragging_node = in_node
					_dragging_area_2d = in_area_2d
					_init_pointer_offset = in_node.position - event.position
					_init_pos = in_node.position
		)

func _input(event: InputEvent) -> void:
	if _dragging_node == null:
		return
	
	if event is InputEventMouseMotion:
		event = (event as InputEventMouseMotion)
		_dragging_node.position = event.position + _init_pointer_offset
	elif event is InputEventMouseButton:
		event = (event as InputEventMouseButton)
		if !event.is_released(): return
		
		var overlaps = _dragging_area_2d.get_overlapping_areas()
		if overlaps.size() != _dragging_area_2d.get_child_count():
			_dragging_node.position = _init_pos
		else:
			var first_shape = _dragging_area_2d.get_child(0) as CollisionShape2D

			var nearest_idx: int
			var nearest_delta_pos: Vector2 = Vector2(99999999,999999999) # Hehe kill me
			
			for overlap_idx in overlaps.size():
				var delta_pos = overlaps[overlap_idx].global_position - first_shape.global_position
				
				if delta_pos < nearest_delta_pos: 
					nearest_delta_pos = delta_pos
					nearest_idx = overlap_idx
			
			_dragging_node.position += nearest_delta_pos
			
			figure_dropped.emit(_dragging_node.get_meta("pallete_idx"))
		
		_dragging_node = null
		
