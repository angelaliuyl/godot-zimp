extends Node2D
@export var tile_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartingTile.start($StartingTileMarker.position)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_indoor_tile():
	var indoor_tile = tile_scene.instantiate()
	indoor_tile.position = $NewTileMarker.position
	add_child(indoor_tile)
