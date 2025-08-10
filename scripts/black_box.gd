extends Node
class_name BlackBox

signal changed
signal filled
signal emptied

## Максимум фигур в ящике (0 = без лимита)
@export var capacity:int = 0

## (опционально) источник всех возможных ID фигур,
## чтобы можно было случайно наполнить ящик.
@export var source_pool:Array[StringName] = []

## Текущий набор “заблокированных” фигур
var _blocked := {} : Dictionary  # {id: true}

func is_blocked(id:StringName) -> bool:
    return _blocked.has(id)

func get_all() -> Array[StringName]:
    return _blocked.keys()

func clear() -> void:
    var was_empty := _blocked.is_empty()
    _blocked.clear()
    if not was_empty:
        emit_signal("changed")
        emit_signal("emptied")

## Добавить фигуру в ящик. Возвращает true, если успешно.
func add(id:StringName) -> bool:
    if is_blocked(id):
        return true
    if capacity > 0 and _blocked.size() >= capacity:
        return false
    _blocked[id] = true
    emit_signal("changed")
    if capacity > 0 and _blocked.size() == capacity:
        emit_signal("filled")
    return true

## Удалить фигуру из ящика (если надо “разблокировать”)
func remove(id:StringName) -> void:
    if _blocked.erase(id):
        emit_signal("changed")
        if _blocked.is_empty():
            emit_signal("emptied")

## Массово добавить
func add_many(ids:Array[StringName]) -> void:
    for id in ids:
        if capacity > 0 and _blocked.size() >= capacity:
            break
        add(id)

## Случайно наполнить из source_pool
func fill_random(count:int, seed:int = 0) -> void:
    if seed != 0:
        seeded_randomize()
    var pool := source_pool.duplicate()
    pool.shuffle()
    add_many(pool.slice(0, min(count, pool.size())))

## Удобный фильтр: вернуть только разрешённые ID из списка
func filter_allowed(ids:Array[StringName]) -> Array[StringName]:
    var out:Array[StringName] = []
    for id in ids:
        if not is_blocked(id):
            out.append(id)
    return out
