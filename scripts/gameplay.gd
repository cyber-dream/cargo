class_name Gameplay
extends Node2D

enum Difficulty {
	EASY   = 0, 
	MEDIUM = 1,
	HARD   = 2
}

@export var levels_path: String
@export var truck_prefab: PackedScene
@export var level_title: Label
@export var truck: CargoTruck
@export var figure_prefabs: Array[PackedScene]
@export var figures: Dictionary
@export var palletes: Array[Node2D]
@export var figures_node: Node2D
@export var panel_game_end: Panel
@export var points_label: Label
@export var levelsequence: CargoLevelsSequence

## Private

var _cur_level: int
var _points: int = 0:
	set(value):
		_points = value
		points_label.text = "Points: " + str(value)
		

func _load_resources_recursive(in_path: String) -> Array[CargoLevel]:
	var result: Array[CargoLevel] = []
	var dir = DirAccess.open(in_path)

	if dir == null:
		push_error("Не удалось открыть папку: " + in_path)
		return result

	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		if file_name.begins_with("."):
			continue

		var full_path = in_path + "/" + file_name

		if dir.current_is_dir():
			result += _load_resources_recursive(in_path)
		else:
			if ResourceLoader.exists(full_path):
				var res = ResourceLoader.load(full_path)
				
				if !res:
					print("Не удалось загрузить: ", full_path)
				elif res.get_script() != CargoLevel:
					continue
				else:
					result.append(res as CargoLevel)

	dir.list_dir_end()
	return result

func _enter_tree() -> void:
	var found_levels = _load_resources_recursive(levels_path)
	
	for f in figure_prefabs:
		var new_f = f.instantiate() as CargoFigure
		var arr = figures.get(new_f.difficulty)
		arr.push_back(f)
		new_f.queue_free()
	
	_load_level(0) 
	CargoDnD.figure_dropped.connect(_on_figure_dropped)
	CargoDnD.game_end.connect(_on_game_end)
	
func _on_game_end():
	pass
	if levelsequence.sequence.size() <= _cur_level+1: 
		panel_game_end.show()
	else:
		_cur_level += 1
		_load_level(_cur_level)
		

func _on_figure_dropped(in_pallete_idx:int, in_points: int):
	_spawn_figure(in_pallete_idx)
	_points += in_points


func _load_level(in_idx: int):
	var level=levelsequence.sequence[in_idx]
	level_title.text = "Level " + str(in_idx)
	truck.size = level.truck_size
	
	for c in figures_node.get_children():
		c.queue_free()
	
	for p_idx in palletes.size():
		_spawn_figure(p_idx)


func _increment_level_difficulty(in_difficulty: CargoLevelDifficulty) -> CargoLevelDifficulty:
	var new_dif: CargoLevelDifficulty
	if in_difficulty.max_difficulty == Difficulty.size()-1:
		if in_difficulty.min_difficulty == Difficulty.size() - 1:
			new_dif.min_difficulty = 0
			new_dif.max_difficulty = 0
		else:
			new_dif.min_difficulty = in_difficulty.min_difficulty +1
			new_dif.max_difficulty = 0 
	else:
		new_dif.min_difficulty = in_difficulty.min_difficulty
		new_dif.max_difficulty = in_difficulty.max_difficulty +1 
	
	return new_dif
	
func _spawn_figure(in_idx: int):
	for c in palletes[in_idx].get_children():
		c.queue_free()
	
	var new_f = _get_random_figure()
	figures_node.add_child(new_f)
	new_f.set_meta("pallete_idx", in_idx)
	new_f.global_position = palletes[in_idx].global_position


func _get_random_figure() -> CargoFigure:
	# Берём мин и макс сложности из текущего уровня
	var mindiff = levelsequence.sequence[_cur_level].min_difficulty
	var maxdiff = levelsequence.sequence[_cur_level].max_difficulty
	var dif = randi_range(mindiff, maxdiff)
	
	# Берём рандомный индекс фигуры из словаря по сложности
	var idx = randi_range(0, figures.get(dif).size()-1)
	
	# Возвращаем фигуру по двум рандомам
	return figures.get(dif)[idx].instantiate()


func _on_next_level_button_pressed() -> void:
	_on_game_end()
