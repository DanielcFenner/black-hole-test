extends RigidBody2D
class_name Orb

const TRAIL_LENGTH: int = 20
var trail_points = []
@onready var light = $light


func _ready():
	pass

func _process(delta):
	light.rotation_degrees += 100 * delta
	update_trail()

func update_trail():
	# Store global position in trail points
	trail_points.append(global_position)

	if trail_points.size() > TRAIL_LENGTH:
		trail_points.pop_front()

	# Convert global positions to local positions relative to the Line2D
	var local_points = []
	for point in trail_points:
		local_points.append(to_local(point))

	var packed_points = PackedVector2Array(local_points)
	$Line2D.points = packed_points
