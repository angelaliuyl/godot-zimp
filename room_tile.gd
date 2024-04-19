extends CharacterBody2D

@export var tile_placement_scene : PackedScene

var dragging = false
var offset = Vector2.ZERO
var collision = false
var right_area_entered = false
var placed = false
var room_name_string

#TODO move this to a file
var doorway_dict = {
	"foyer" : [true, false, false, false],
	"bathroom" : [true, false, false, false], 
	"bedroom" : [true, false, false, true], 
	"diningroom" : [false, true, true, true], 
	"eviltemple" : [false, true, false, true], 
	"familyroom" : [true, true, false, true], 
	"kitchen" : [true, false, true, true], 
	"storage" : [true, false, false, false]
}

#var doorway = [true, true, false, false]

var top = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
		
func load_texture(room_name : String):
	room_name_string = room_name
	var path = "res://media/tiles/" + room_name + ".png"
	var tile_image = Image.load_from_file(path)
	var image_texture = ImageTexture.create_from_image(tile_image)
	$TileSprite.texture = image_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if dragging && !placed:
		var current_position = position
		var new_position = get_global_mouse_position() - offset
		
		_move_and_slide_alt(current_position, new_position, delta)
		offset = get_global_mouse_position() - position
		
func _move_and_slide_alt(currentPosition, newPosition, delta):
	var distance = currentPosition.distance_to(newPosition)
	var direction = currentPosition.direction_to(newPosition)
	
	var speed = distance / delta
	velocity = direction * speed
	
	move_and_slide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_button_button_down():
	dragging = true
	offset = get_global_mouse_position() - global_position

func _on_button_button_up():
	dragging = false


func _on_tile_ui_turn_left():
	$TileSprite.rotation -= PI / 2
	doorway_dict[room_name_string]  = _rotate_array_cw(doorway_dict[room_name_string], -1)


func _on_tile_ui_turn_right():
	$TileSprite.rotation += PI / 2
	doorway_dict[room_name_string]  = _rotate_array_cw(doorway_dict[room_name_string], 1)

func _on_tile_ui_mark_done():
	placed = true
	$TileUI.hide()
	# generate tile placement spaces
	_spawn_tile_snapping_spaces()
	$CollisionShape2D.set_deferred("disabled", 1)

func _spawn_tile_snapping_spaces():
	var placementSpace = tile_placement_scene.instantiate()
	placementSpace.scale = $TileSprite.scale
	for i in 4:
		if doorway_dict[room_name_string][i]:
			_spawn_tile_snapping_space(i)

func _spawn_tile_snapping_space(tile_dir):
	var placementSpace = tile_placement_scene.instantiate()
	placementSpace.scale = $TileSprite.scale
	if tile_dir == 0:
		placementSpace.position = $TopSnapCenter.position
	elif tile_dir == 1:
		placementSpace.position = $RightSnapCenter.position
	elif tile_dir == 2:
		placementSpace.position = $DownSnapCenter.position
	elif tile_dir == 3:
		placementSpace.position = $LeftSnapCenter.position
	else:
		return
	add_child(placementSpace)

func _rotate_array_cw(old_array : Array, is_cw : int):
	var new_array = old_array.duplicate(true)
	print (new_array)
	var ran = old_array.size()
	var new_index
	for i in ran:
		new_index = (i+is_cw) % ran
		new_array[new_index] = old_array[i]
	return new_array
	
