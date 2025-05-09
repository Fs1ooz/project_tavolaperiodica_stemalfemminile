extends CanvasLayer

@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer

func _ready():
	animation_player.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	
	# Rimuovi la scena corrente
	var old_scene = get_tree().current_scene
	var new_scene = preload("res://Main/main.tscn").instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	await get_tree().process_frame
	old_scene.queue_free()
