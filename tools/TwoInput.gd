extends Node2D

signal placed(right)

var _counter: int = 0
var _fingers: Dictionary = {}
var _protuberance
var space_state: Physics2DDirectSpaceState
var _initial_distance: float

# Called when the node enters the scene tree for the first time.
func _ready():
	_fingers[0] = $finger_cero
	_fingers[1] = $finger_one
	space_state = get_world_2d().direct_space_state
#	var result = space_state.intersect_ray(Vector2(100, 100), Vector2(300, 300))
#	print(result)
#	print ({} == {})
#	print ({} == {'1': 2})
#	print ({}.empty())

func _input(event):
	if event is InputEventScreenTouch:
		if event.index > 1:
			return
		if event.pressed:
			var finger: FingerPointer = _fingers[event.index]
			finger.position = event.position
			finger.draw_pointer()
			# When the second finger touchs the screen
			# it calculates if the line between the two fingers intersect
			# a pimple.
			if event.index == 1:
				var f0_position: Vector2 = $finger_cero.position
				var f1_position: Vector2 = $finger_one.position
				var result: Dictionary = space_state.intersect_ray(f0_position, f1_position, [], 2147483647, false, true)
				print (result)
				if not result.empty():
					_protuberance = result['collider']
					_protuberance
					_initial_distance = (f0_position - f1_position).length()
					pass
				pass
		else:
			var finger: FingerPointer = _fingers[event.index]
			finger.position = event.position
			finger.hide_pointer()
			if event.index == 1:
				_protuberance = null
			
	elif event is InputEventScreenDrag:
		if event.index > 1:
			return
		var finger: FingerPointer = _fingers[event.index]
		finger.position = event.position
		if event.index == 1:
			if _protuberance:
				var f0_position: Vector2 = _fingers[0].position
				var f1_position: Vector2 = _fingers[1].position
				var new_distance: float = (f0_position - f1_position).length()
				if new_distance < _initial_distance:
					_protuberance.apply_pressure(_initial_distance - new_distance)


