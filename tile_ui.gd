extends Control

signal turn_left
signal turn_right
signal mark_done

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_turn_left_pressed():
	turn_left.emit()

func _on_turn_right_pressed():
	turn_right.emit()

func _on_done_pressed():
	mark_done.emit()
