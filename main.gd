extends Node2D
@export var tile_scene: PackedScene

#section for storing room tile logic
var indoor_deck = ["bathroom", "bedroom", "diningroom", "eviltemple", 
					"familyroom", "kitchen", "storage"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartingTile.start($StartingTileMarker.position)
	$StartingTile.load_texture("foyer")
	$StartingTile.placed = true
	
	# randomise indoor_deck
	indoor_deck.shuffle()
	print(indoor_deck)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_indoor_tile():
	var indoor_tile = tile_scene.instantiate()
	indoor_tile.position = $NewTileMarker.position
	indoor_tile.load_texture(indoor_deck.pop_front())
	add_child(indoor_tile)
	if indoor_deck.size() > 0:
		var indoor_tile = tile_scene.instantiate()
		indoor_tile.position = $NewTileMarker.position
		indoor_tile.load_texture(indoor_deck.pop_front())
		add_child(indoor_tile)
	else:
		print("no indoor tiles left")

