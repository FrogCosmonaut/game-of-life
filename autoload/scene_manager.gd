extends Node

signal scene_changed

var current_scene = null
var scene_history: Array = []


func change_scene(path, store_history: bool = true) -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

	if store_history and current_scene:
		scene_history.push_back(current_scene.scene_file_path)

	call_deferred("_deferred_change_scene", path)


func reload_scene() -> void:
	var path = get_tree().current_scene.scene_file_path
	change_scene(path)


func go_back() -> void:
	if scene_history.size() > 0:
		var previous_scene = scene_history.pop_back()
		change_scene(previous_scene, false)


func _deferred_change_scene(path: String) -> void:
	current_scene.free()

	var next_scene = ResourceLoader.load(path)
	current_scene = next_scene.instantiate()

	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	scene_changed.emit()
