extends Node3D

var check1 = false
var check2 = false
var check3 = false
var check4 = false
var check5 = false
var check6 = false
var check7 = false
var check8 = false

@onready var time = 0
@onready var use_milliseconds = true
@onready var start = false

var once = true
var points = 0
var totpoints = 0
var besttime = 1000000000

var opt1: int = -1
var opt2: int = -1
var opt3: int = -1

var cardtitle = {
	1:"An Ice Cold Beer",
	2:"Karbon Faiba",
	3:"Ying Yang Spinny Thang",
	4:"Tungsten Cube",
	5:"Buttery Tires",
	6:"Mattress Springs",
	7:"Cinder Block Springs",
	8:"Brake Delete",
	9:"Gorilla Brakes",
	10:"Rat Trap tires"
}

var carddesc = {
	1:"Extra points at the cost of nausea.\n (driving in my car, right after a beer!)",
	2:"Replace parts with Karbon Faiba.\n (Karbon Faiba!)",
	3:"Slap a turbo on it for better speed.\n (can always trust ol mate garrett)",
	4:"Throw in a tungsten cube to increase weight.\n (all praise the cube.)",
	5:"Spread butter on them to keep them slick.\n (wonder what it tastes like...)",
	6:"Why would you do this. Suspension becomes slack.\n (where'd my mattress go?)",
	7:"This is even worse. Suspension becomes stiff.\n (i stole that from the deelorship.)",
	8:"Who needs those when you can brake caveman style.\n (i hope you have good shoes)",
	9:"Grip the brakes with the force of a thousand gorillas.\n (OOGH OUGH AAAAGH AAAAAAAGHAAAAAAAAA)",
	10:"Just stick em on there. That aint goin nowhere.\n (what are you trying to catch with that?)"
}

func _ready() -> void:
	Transition.playback("white_fade")
	#_card()

func _process(delta : float) -> void:
	if start:
		time += delta
		$stopwatch.text = _format_seconds(time, use_milliseconds)

func _card():
	get_tree().paused = true
	var rand1 = randi_range(1,cardtitle.size())
	var rand2 = randi_range(1,cardtitle.size())
	var rand3 = randi_range(1,cardtitle.size())
	$rogue.visible = true
	%vb/title1.text = cardtitle[rand1]
	%vb/what1.text = carddesc[rand1]
	%vb2/title2.text = cardtitle[rand2]
	%vb2/what2.text = carddesc[rand2]
	%vb3/title3.text = cardtitle[rand3]
	%vb3/what3.text = carddesc[rand3]
	
	opt1 = rand1
	opt2 = rand2
	opt3 = rand3
		
func _on_check_1_body_entered(body: Node3D) -> void:
	if body.is_in_group("car"):
		if check8 && check1:
			print("success")
			check2 = false
			check3 = false
			check4 = false
			check5 = false
			check6 = false
			check7 = false
			check8 = false
			points = 200/time
			totpoints += points * $dumbcar.getPointsMult()
			if time < besttime:
				besttime = time
				$besttime.text = _format_seconds(time, use_milliseconds)
			$points.text = "Points: %2d" % [totpoints]
			time = 0
			
			$check1/yay.play()
			_card()
		else:
			print("fail")
			#get_tree().paused = true
			#_card()
			time = 0
			start = true
		check1 = true

func _format_seconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)

	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]

	var milliseconds := fmod(time, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]


func _on_check_2_body_entered(body: Node3D) -> void:
	if check1 && body.is_in_group("car"):
		check2 = true


func _on_check_3_body_entered(body: Node3D) -> void:
	if check2 && body.is_in_group("car"):
		check3 = true


func _on_check_4_body_entered(body: Node3D) -> void:
	if check3 && body.is_in_group("car"):
		check4 = true


func _on_check_5_body_entered(body: Node3D) -> void:
	if check4 && body.is_in_group("car"):
		check5 = true


func _on_check_6_body_entered(body: Node3D) -> void:
	if check5 && body.is_in_group("car"):
		check6 = true


func _on_check_7_body_entered(body: Node3D) -> void:
	if check6 && body.is_in_group("car"):
		check7 = true


func _on_check_8_body_entered(body: Node3D) -> void:
	if check7 && body.is_in_group("car"):
		check8 = true

func _on_card_1_pressed() -> void:
	_on_upgrade_click(opt1)

func _on_card_2_pressed() -> void:
	_on_upgrade_click(opt2)

func _on_card_3_pressed() -> void:
	_on_upgrade_click(opt3)

var drunkInterval = 30.0

func _on_upgrade_click(index : int) -> void:
	$rogue.hide()
	get_tree().paused = false
	match index:
		1: #extra points but nausea
			$dumbcar.get_upgrade("Beer")
			$DrunkInterval.wait_time = drunkInterval
			drunkInterval /= 2
			$DrunkInterval.start()
		2: #less weight
			$dumbcar.get_upgrade("Fiber")
		3: #turbo acceleration
			$dumbcar.get_upgrade("YingYang")
		4:
			$dumbcar.get_upgrade("Cube")
		5:
			$dumbcar.get_upgrade("Butter")
		6:
			$dumbcar.get_upgrade("Mattress")
		7:
			$dumbcar.get_upgrade("Cinder")
		8:
			$dumbcar.get_upgrade("Caveman")
		9:
			$dumbcar.get_upgrade("Gorilla")
		10:
			$dumbcar.get_upgrade("Rat")
		_:
			print("invalid")

func _on_body_fall(body: Node3D) -> void:
	if body.is_in_group("car"):
		body.position = Vector3(-42.12,0.726,-3.148)
		body.rotation = Vector3(0,0,0)
		time = 0
		start = true

func _on_drunk_interval_timeout() -> void:
	$dumbcar.flip_directions()
	if($dumbcar.get_direction() < 0):
		$stopwatch["theme_override_colors/font_color"] = Color.RED
	else:
		$stopwatch["theme_override_colors/font_color"] = Color.WHITE
		
func _on_shoparea_body_entered(body: Node3D) -> void:
	if body.is_in_group("car"):
		get_tree().paused = true
		$shopgui.show()
		
		
		


func _on_leave_pressed() -> void:
	get_tree().paused = false
	$shopgui.hide()
	


func _on_car_1_pressed() -> void:
	$dumbcar.change_model("butter")
	
func _on_car_2_pressed() -> void:
	if points == 0:
		points -= 50
		$dumbcar.change_model("word")
		
