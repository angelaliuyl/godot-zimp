extends StaticBody2D

signal tile_placed_in_space()

var pos_direction
var sprite_scale = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.scale = Vector2(sprite_scale, sprite_scale)

func _when_tile_placed_in():
	tile_placed_in_space.emit()
