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

## Private

var _cur_level: int = 0

func _enter_tree() -> void: 
	for f in figure_prefabs:
		var new_sprite = f.instantiate() as CargoFigure
		var arr = figures.get(Difficulty.EASY)
		arr.push_back(new_sprite)
	
	_load_level(0)
	

func _load_level(in_idx: int):
	var level = levels[in_idx]
	level_title.text = "Level " + str(in_idx)
	
	truck.size = level.truck_size
	
	for p_idx in palletes.size():
		_spawn_figure(p_idx, level.max_difficulty)
	
func _spawn_figure(in_idx: int, in_max_difficulty: Difficulty):
	for c in palletes[in_idx].get_children():
		c.queue_free()
	
	var new_f = _get_random_figure(in_max_difficulty)
	figures_node.add_child(new_f)
	new_f.global_position = palletes[in_idx].global_position


func _get_random_figure(in_max_difficulty: Difficulty) -> CargoFigure:
	var dif = randi_range(0, in_max_difficulty)
	
	var figures = figures.get(dif)
	var idx = randi_range(0, figures.size()-1)
	
	return figures[idx]
