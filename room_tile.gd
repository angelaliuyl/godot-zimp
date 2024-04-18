extends CharacterBody2D

var dragging = false
var offset = Vector2.ZERO
var collision = false
var right_area_entered = false

var room_name_array = ["bathroom", "bedroom", "diningroom", "eviltemple", 
					"familyroom", "foyer", "kitchen", "storage"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
		
func load_texture(room_name : String):
	var path = "res://media/tiles/" + room_name + ".png"
	var tile_image = Image.load_from_file(path)
	var image_texture = ImageTexture.create_from_image(tile_image)
	$TileSprite.texture = image_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if dragging:
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
	


