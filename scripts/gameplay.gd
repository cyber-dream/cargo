class_name Gameplay
extends Node2D

enum Difficulty {
    EASY = 0, 
    MEDIUM = 1,
    HARD= 2
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

## Private

var _cur_level: CargoLevel
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
    
    #_load_level(0) FIXME
    CargoDnD.figure_dropped.connect(_on_figure_dropped)
    CargoDnD.game_end.connect(_on_game_end)
    
func _on_game_end():
    pass
    #if levels.size() <= _cur_level+1: FIXME
        #panel_game_end.show()
    #else:
        #_cur_level += 1
        #_load_level(_cur_level)
        

func _on_figure_dropped(in_pallete_idx:int, in_points: int):
    #_spawn_figure(in_pallete_idx, levels[_cur_level].max_difficulty)
    _points += in_points


#func _load_level(in_idx: int):
    #_points = 0
    #
    #var level = levels[in_idx]
    #level_title.text = "Level " + str(in_idx)
    #
    #truck.size = level.truck_size
    #
    #for c in figures_node.get_children():
        #c.queue_free()
    #
    #for p_idx in palletes.size():
        #_spawn_figure(p_idx, level.max_difficulty)
    
func _spawn_figure(in_idx: int):
    for c in palletes[in_idx].get_children():
        c.queue_free()
    
    var new_f = _get_random_figure()
    figures_node.add_child(new_f)
    new_f.set_meta("pallete_idx", in_idx)
    new_f.global_position = palletes[in_idx].global_position


func _get_random_figure() -> CargoFigure:
    var mindiff = _cur_level.min_difficulty
    var maxdiff = _cur_level.max_difficulty
    var dif = randi_range(mindiff, maxdiff)
    var idx = randi_range(0, figures.get(dif).size()-1)
    return figures.get(dif)[idx].instantiate()


func _on_next_level_button_pressed() -> void:
    _on_game_end()
