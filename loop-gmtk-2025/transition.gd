extends CanvasLayer


func play(name):
	$anim.play(name)
	await $anim.animation_finished
	
func playback(name):
	$anim.play_backwards(name)
	await $anim.animation_finished
