extends Control

var yeet = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if yeet:
		$dumbcar.engine_force = 1000
	else:
		$dumbcar.engine_force = 0


func _on_start_pressed() -> void:
	yeet = true
	Transition.play("white_fade")
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://driving.tscn")


func _on_settin_pressed() -> void:
	if !$settin.visible:
		$settin.visible = true
	else:
		$settin.visible = false
	


func _on_leave_pressed() -> void:
	get_tree().quit()
