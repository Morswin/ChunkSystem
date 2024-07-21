extends Node2D
class_name Chunk


var key: Vector2


func populate_chunk(_key: Vector2):
	key = _key

func depopulate_chunk():
	pass


func _on_timer_timeout():
	#print(key)
	pass
