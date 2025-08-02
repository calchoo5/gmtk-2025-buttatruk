extends Camera3D

@export var look_target: Node3D
@export var distance = 4.0
@export var height = 2.0


func _ready() -> void:
	global_position = look_target.global_position + Vector3(0,2,-3)
	
func _physics_process(delta):
	var target = look_target.get_global_transform_interpolated().origin
	var pos = get_global_transform_interpolated().origin
	var up = Vector3(0,1,0)
	var offset = pos - target
	offset = offset.normalized()*distance
	offset.y = height
	pos = target + offset
	look_at_from_position(pos,target,up)
	
