class_name Gameplay
extends Node2D

enum Difficulty {
	EASY = 0, 
	MEDIUM = 1,
	HARD= 2
}

@export var levels: Array[Level]
@export var truck_prefab: PackedScene
@export var level_title: Label
@export var truck: CargoTruck
@export var figure_prefabs: Array[PackedScene]
@export var figures: Dictionary
@export var palletes: Array[Node2D]
@export var figures_node: Node2D
@export var panel_game_end: Panel
@export var points_label: Label

## Private

var _cur_level: int = 0
var _points: int = 0:
	set(value):
		_points = value
		points_label.text = "Points: " + str(value)
		

func _enter_tree() -> void: 
	for f in figure_prefabs:
		var kek = f.instantiate() as CargoFigure
		var arr = figures.get(kek.difficulty)
		arr.push_back(f)
		kek.queue_free()
	
	_load_level(0)
	CargoDnD.figure_dropped.connect(_on_figure_dropped)
	CargoDnD.game_end.connect(_on_game_end)
	
func _on_game_end():
	if levels.size() <= _cur_level+1:
		panel_game_end.show()
	else:
		_cur_level += 1
		_load_level(_cur_level)
		

func _on_figure_dropped(in_pallete_idx:int, in_points: int):
	_spawn_figure(in_pallete_idx, levels[_cur_level].max_difficulty)
	_points += in_points


func _load_level(in_idx: int):
	_points = 0
	
	var level = levels[in_idx]
	level_title.text = "Level " + str(in_idx)
	
	truck.size = level.truck_size
	
	for c in figures_node.get_children():
		c.queue_free()
	
	for p_idx in palletes.size():
		_spawn_figure(p_idx, level.max_difficulty)
	
func _spawn_figure(in_idx: int, in_max_difficulty: Difficulty):
	for c in palletes[in_idx].get_children():
		c.queue_free()
	
	var new_f = _get_random_figure(in_max_difficulty)
	figures_node.add_child(new_f)
	new_f.set_meta("pallete_idx", in_idx)
	new_f.global_position = palletes[in_idx].global_position


func _get_random_figure(in_max_difficulty: Difficulty) -> CargoFigure:
	var dif = randi_range(0, in_max_difficulty)
	var idx = randi_range(0, figures.get(dif).size()-1)
	return figures.get(dif)[idx].instantiate()


func _on_next_level_button_pressed() -> void:
	_on_game_end()
