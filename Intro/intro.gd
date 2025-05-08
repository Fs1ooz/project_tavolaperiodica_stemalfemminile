extends CanvasLayer

func _ready():
	$AnimationPlayer.play("fade_in_out")
	await get_tree().create_timer(1.0).timeout  
	var new_scene = preload("res://Main/main.tscn").instantiate()
	get_tree().root.add_child(new_scene)
	await get_tree().process_frame  # aspetta un frame
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene
