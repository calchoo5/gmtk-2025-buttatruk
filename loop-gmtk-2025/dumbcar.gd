extends VehicleBody3D

@export var maxsteer = 0.9
@export var max_enginepower = 300
@export var brakepower = 1
@export var handbrakepower = 2
@export var steerdamp = 2

var enginepower = max_enginepower
var pedal = 0.0
var rpm = 0.0
var buffer = 0
var amount = 250
var shift1 = true
var shift2 = true

var pointsMult : int = 1

var models: Dictionary[String,PackedScene] = {
	"butter" : load("res://car models/butter_model.tscn"),
	"word" : load("res://car models/word_model.tscn"),
	"hotdog" : load("res://car models/hotdog_model.tscn"),
	"car" : load("res://car models/car_model.tscn"),
}

var frontleftPos : Dictionary[String,Vector3] = {
	"butter" : Vector3(0.75,0.254,1.0),
	"word" : Vector3(0.774,0.501,1.255),
	"hotdog" : Vector3(0.75,0.254,1.0),
	"car" : Vector3(0.963,0.381,0.888),
}

var frontrightPos : Dictionary[String,Vector3] = {
	"butter" : Vector3(-0.75,0.254,1.0),
	"word" : Vector3(-0.774,0.501,-1.255),
	"hotdog" : Vector3(-0.75,0.254,1.0),
	"car" : Vector3(-0.963,0.381,0.888),
	
}

var rearleftPos : Dictionary[String,Vector3] = {
	"butter" : Vector3(0.75,0.254,-1.0),
	"word" : Vector3(0.774,0.501,1.331),
	"hotdog" : Vector3(0.75,0.254,-1.0),
	"car" : Vector3(0.963,0.381,-0.785),
	
}

var rearrightPos : Dictionary[String,Vector3] = {
	"butter" : Vector3(-0.75,0.254,-1.0),
	"word" : Vector3(-0.774,0.501,-1.331),
	"hotdog" : Vector3(-0.75,0.254,-1.0),
	"car" : Vector3(-0.963,0.381,-0.785),
	
}

var curr_model = "null"

func _ready() -> void:
	change_model("butter")

func change_model(model : String) -> void:
	if(model != curr_model):
		for child in $Model.get_children():
			child.queue_free()
		$Model.add_child(models[model].instantiate())
		$frontleft.position = frontleftPos[model]
		$frontright.position = frontrightPos[model]
		$rearleft.position = rearleftPos[model]
		$rearright.position = rearrightPos[model]

func flip_directions() -> void:
	maxsteer *= -1
	print("flipped")

func get_direction() -> int:
	return sign(maxsteer)

func _process(delta: float) -> void:
	buffer += 1
	if buffer == 40:
		buffer = 0
		fart()

func getPointsMult() -> int:
	return pointsMult

func get_upgrade(name : String):
	match name:
		"Beer":
			pointsMult += 1
		"Fiber":
			mass -= 100
		"YingYang":
			max_enginepower += 50
		"Cube":
			mass += 100
	print(max_enginepower)
	print(pointsMult)
	print(mass)

func _physics_process(delta: float) -> void:
	#steering
	steering = move_toward(steering, Input.get_axis("right","left") * maxsteer,delta * steerdamp)
	
	pedal = Input.get_axis("down","up") 
	if pedal > 0.1:
		#print("go")
		engine_force = pedal * enginepower
		brake = 0
	elif pedal < -0.1:
		if going_forward():
			#print("brake")
			engine_force = 0.0
			brake = -pedal * brakepower
		else:
			#print("reverse")
			engine_force = pedal * enginepower
			brake = 0
	else:
		#print("coast")
		if engine_force > 0:
			engine_force -= 2
		elif engine_force < 0:
			engine_force += 2
	
	
	#simualted handbrake
	if Input.is_action_pressed("handbrake"):
		if Input.get_axis("right","left") > 0.1:
			if Input.is_action_pressed("up"):
				print("dorifto")
				$rearright.engine_force = 1000
			else:
				$rearright.engine_force = 0
			$rearleft.engine_force = 0
			brake = handbrakepower
		elif Input.get_axis("right","left") < -0.1:
			$rearright.engine_force = 0
			if Input.is_action_pressed("up"):
				print("dorifto")
				$rearleft.engine_force = 1000
			else:
				$rearright.engine_force = 0
			brake = handbrakepower
		else:
			print("SRTOPPPP")
			$rearright.engine_force = 0
			$rearleft.engine_force = 0
			brake = handbrakepower
		
	
func going_forward() -> bool:
	var relative_speed : float = basis.z.dot(linear_velocity.normalized())
	if relative_speed > 0.01:
		return true
	else:
		return false

func fart():
	var rpm = $frontleft.get_rpm()
	if rpm < 100:
		amount = 250
		shift1 = true
		shift2 = true
	elif 200 > rpm && rpm > 150:
		if shift1:
			print("shift1")
			enginepower = -10
			await get_tree().create_timer(0.2).timeout
			enginepower = max_enginepower 
			shift1 = false
			shift2 = true
		amount = 350
	elif 400 > rpm && rpm > 230:
		if shift2:
			print("shift2")
			enginepower = -10
			await get_tree().create_timer(0.2).timeout
			enginepower = max_enginepower 
			shift2 = false
			shift1 = true
		amount = 450
	var pitch = (abs($frontleft.get_rpm()) + 100)/amount
	$fartcan.pitch_scale = pitch
	$fartcan.play()
	
	
	
