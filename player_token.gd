extends CharacterBody2D

#region Click and drag code, maybe make this more universal

var dragging = false
var offset = Vector2.ZERO
var mouse_in = false

var initial_position
var is_placed_in_spot


func _process(delta):
	if dragging:
		var new_position = get_global_mouse_position() - offset
		position = new_position
		offset = get_global_mouse_position() - position	

#endregion

#region Dropping code

var is_inside_dropable
var drop_space_body_ref

func _on_area_2d_body_entered(body):
	if body.is_in_group('player_tile_placement_space'):
		print("entered tile space")
	
		if !is_inside_dropable:
			is_inside_dropable = true
			drop_space_body_ref = body
			print("saved new body ref")
			print(body.position)

func _on_area_2d_body_exited(body):
	if body.is_in_group('player_tile_placement_space'):
		print("exited tile space")
		if is_inside_dropable:
			is_inside_dropable = false

#endregion



func _on_sprite_2d_button_up():
	dragging = false
	var tween = get_tree().create_tween()
	var go_to_position
	if is_inside_dropable:
		go_to_position = drop_space_body_ref.global_position
		is_placed_in_spot = true
	else:
		go_to_position = initial_position
	
	tween.tween_property(self, "position", go_to_position, 0.2).set_ease(Tween.EASE_OUT)
		
func _on_sprite_2d_button_down():
	dragging = true
	initial_position = position
	offset = get_global_mouse_position() - global_position
