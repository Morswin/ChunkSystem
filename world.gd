extends Node2D


const chunk_scene: PackedScene = preload("res://chunk.tscn")
const chunk_size: int = 50

@export var world_render_range: int = 200
@export var world_free_range: int = 250

@onready var player: Player = %Player

var chunk_map: Dictionary = {}


# Builtin functions
func _ready():
	for x in range(-world_render_range, world_render_range, chunk_size):
		for y in range(-world_render_range, world_render_range, chunk_size):
			create_new_chunk(x, y)

func _process(_delta):
	if Input.is_action_just_pressed("debug"):
		print(chunk_map)
		print(player.global_position)

# Signals
func _on_world_update_timeout():
	update_chunk_map(player.global_position)

# Other
func create_new_chunk(x: int, y: int):
	var _new_chunk_position = Vector2(x + (chunk_size / 2.0), y + (chunk_size / 2.0))
	if !chunk_map.has(_new_chunk_position):
		var _new_chunk: Chunk = chunk_scene.instantiate()
		_new_chunk.position = _new_chunk_position
		_new_chunk.populate_chunk(_new_chunk_position)
		chunk_map[_new_chunk_position] = _new_chunk
		add_child(_new_chunk)

func delete_chunk(_chunk_key: Vector2):
	if chunk_map.has(_chunk_key):
		chunk_map[_chunk_key].depopulate_chunk()
		chunk_map[_chunk_key].queue_free()
		chunk_map.erase(_chunk_key)

func update_chunk_map(_player_position: Vector2):
	var _update_offset = Vector2(
		int(_player_position.x - (int(_player_position.x) % chunk_size)) ,
		int(_player_position.y - (int(_player_position.y) % chunk_size))
	)
	# Delete all chunks that are out of range
	for _chunk_key in chunk_map.keys():
		var _condition_1: bool = _chunk_key.x < _update_offset.x - world_free_range
		var _condition_2: bool = _chunk_key.x > _update_offset.x + world_free_range
		var _condition_3: bool = _chunk_key.y < _update_offset.y - world_free_range
		var _condition_4: bool = _chunk_key.y > _update_offset.y + world_free_range
		if _condition_1 or _condition_2 or _condition_3 or _condition_4:
			delete_chunk(_chunk_key)
	# Create all chunks that should be in range but doesn't exist yet
	for _x in range(_update_offset.x - world_render_range, _update_offset.x + world_render_range, chunk_size):
		for _y in range(_update_offset.y - world_render_range, _update_offset.y + world_render_range, chunk_size):
			if !chunk_map.has(Vector2(_x, _y)):
				create_new_chunk(_x, _y)
