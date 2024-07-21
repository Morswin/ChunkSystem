extends CharacterBody2D
class_name Player


func _physics_process(_delta):
	var player_input: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = player_input * 150
	move_and_slide()
