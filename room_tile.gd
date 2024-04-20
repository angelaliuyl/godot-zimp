extends CharacterBody2D

@export var tile_placement_scene : PackedScene

signal tile_placed

var dragging = false
var offset = Vector2.ZERO
var collision = false
var right_area_entered = false
var placed = false
var room_name_string

var is_inside_dropable
var drop_space_body_ref
var initial_position
var is_placed_in_spot

#TODO move this to a file
var doorway_dict = {
	"foyer" : [true, false, false, false],
	"bathroom" : [true, false, false, false], 
	"bedroom" : [true, false, false, true], 
	"diningroom" : [false, true, true, true], 
	"eviltemple" : [false, true, false, true], 
	"familyroom" : [true, true, false, true], 
	"kitchen" : [true, true, false, true], 
	"storage" : [true, false, false, false]
}

var doorway 

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
	initial_position = global_position
	doorway = doorway_dict[room_name]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if !placed:
		if dragging:
			#var current_position = position
			var new_position = get_global_mouse_position() - offset
			
			#_move_and_slide_alt(current_position, new_position, delta)
			position = new_position
			
			offset = get_global_mouse_position() - position
		elif Input.is_action_just_released("click"):
			var tween = get_tree().create_tween()
			var go_to_position
			if is_inside_dropable:
				go_to_position = drop_space_body_ref.global_position
				is_placed_in_spot = true
			else:
				go_to_position = initial_position
			tween.tween_property(self, "position", go_to_position, 0.2).set_ease(Tween.EASE_OUT)

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
	var tween = get_tree().create_tween()
	var new_rotation = $TileSprite.rotation - PI / 2
	tween.tween_property($TileSprite, "rotation", new_rotation, 0.2).set_ease(Tween.EASE_OUT)
	doorway  = _rotate_array_cw(doorway, -1)

func _on_tile_ui_turn_right():
	var tween = get_tree().create_tween()
	var new_rotation = $TileSprite.rotation + PI / 2
	tween.tween_property($TileSprite, "rotation", new_rotation, 0.2).set_ease(Tween.EASE_OUT)

	doorway  = _rotate_array_cw(doorway, 1)

func _on_tile_ui_mark_done():
	#TODO stop being able to place if the doorways don't line up
	if is_placed_in_spot:
		if drop_space_body_ref != null:
			# first check if the move is valid
			var own_space = (drop_space_body_ref.pos_direction + 2) % 4
			if !doorway[own_space]:
				return
			
			# set own space to filled corresponding to other tile
			doorway[own_space] = false
			print("Spaces after being placed:")
			print(doorway)
			
			# turn off snapping body
			drop_space_body_ref.queue_free()
			
			tile_placed.emit()
		
		# generate tile placement spaces
		_spawn_tile_snapping_spaces()
		$CollisionShape2D.set_deferred("disabled", 1)
		placed = true
		$TileUI.hide()

func _spawn_tile_snapping_spaces():
	var placementSpace = tile_placement_scene.instantiate()
	placementSpace.scale = $TileSprite.scale
	for i in 4:
		if doorway[i]:
			_spawn_tile_snapping_space(i)

func _spawn_tile_snapping_space(tile_dir):
	var placementSpace = tile_placement_scene.instantiate()
	placementSpace.scale = $TileSprite.scale
	placementSpace.pos_direction = tile_dir
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
	#placementSpace.tile_placed_in_space.connect(Callable(room_tile_placed).bind(placementSpace.pos_direction))
	print("made placementSpace in direction")
	print(placementSpace.pos_direction)
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

func _on_area_2d_body_entered(body:StaticBody2D):
	if body.is_in_group('dropable'):
		print("entered body")
		body.sprite_scale = body.sprite_scale * 1.1
	
		if !is_inside_dropable:
			is_inside_dropable = true
			drop_space_body_ref = body
			print("saved new body ref")
			print(body.position)

func _on_area_2d_body_exited(body:StaticBody2D):
	if body.is_in_group('dropable'):
		print("exited body")
		body.sprite_scale = body.sprite_scale / 1.1
		if is_inside_dropable:
			is_inside_dropable = false

#TODO this might not be needed anymore, consider removing
func room_tile_placed(pos_dir):
	doorway[pos_dir] = false
	var child_nodes = get_children()
	for node in child_nodes:
		if node.is_in_group('dropable') && node.pos_direction == pos_dir:
			node.hide()
			
	
	
