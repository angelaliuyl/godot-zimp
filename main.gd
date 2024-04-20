extends Node2D
@export var tile_scene: PackedScene

var is_placing_tile = false

#TODO read this from a file or from directory
var indoor_deck = ["bathroom", "bedroom", "diningroom", "eviltemple", 
					"familyroom", "kitchen", "storage"]

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_starting_tile()
	
	# randomise indoor_deck
	indoor_deck.shuffle()
	print(indoor_deck)
	
func _load_starting_tile():
	$StartingTile.start($StartingTileMarker.position)
	$StartingTile.load_texture("foyer")
	$StartingTile.placed = true
	$StartingTile.is_placed_in_spot = true
	$StartingTile._on_tile_ui_mark_done()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_indoor_tile():
	if indoor_deck.size() > 0:
		add_child(indoor_tile_generation(indoor_deck.pop_front()))
	if indoor_deck.size() <= 0:
		print("no indoor tiles left")
	$"HUD/Indoor button".hide()

func indoor_tile_generation(tile_name):
	var indoor_tile = tile_scene.instantiate()
	indoor_tile.position = $NewTileMarker.position
	indoor_tile.load_texture(tile_name)
	indoor_tile.tile_placed.connect(tile_final_placed)
	return indoor_tile
	
func tile_final_placed():
	$"HUD/Indoor button".show()

#TODO add option to make new doorway when no doorways available
