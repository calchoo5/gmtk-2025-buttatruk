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

var cardtitle = {
	1:"An Ice Cold Beer",
	2:"Karbon Faiba",
	3:"Ying Yang Spinny Thang"
}

var carddesc = {
	1:"Extra points at the cost of nausea.\n (driving in my car, right after a beer!)",
	2:"Less vehicle weight. May cause less grip.\n (i dont think this helps...)",
	3:"Slap a turbo on it for better acceleration.\n (can always trust ol mate garrett)"
}

func _ready() -> void:
	Transition.playback("white_fade")


func _process(delta : float) -> void:
	if start:
		time += delta
		$stopwatch.text = _format_seconds(time, use_milliseconds)

func _card():
	var rand1 = randi_range(1,3)
	var rand2 = randi_range(1,3)
	var rand3 = randi_range(1,3)
	$rogue.visible = true
	%vb/title1.text = cardtitle[rand1]
	%vb/what1.text = carddesc[rand1]
	%vb2/title2.text = cardtitle[rand2]
	%vb2/what2.text = carddesc[rand2]
	%vb3/title3.text = cardtitle[rand3]
	%vb3/what3.text = carddesc[rand3]
	
		
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
			totpoints += points
			if time < besttime:
				besttime = time
				$besttime.text = _format_seconds(time, use_milliseconds)
			$points.text = "Points: %2d" % [totpoints]
			time = 0
			
			$check1/yay.play()
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


func _on_vb_mouse_entered() -> void:
	print("entered")
