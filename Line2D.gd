extends Line2D

@export var target_position: Vector2
@export var speed: float = 400.0
@export var trail_length: int = 10

var trail_points = []

func _ready():
	set_process(true)

func _process(delta):
	var direction = (target_position - global_position).normalized()
	global_position += direction * speed * delta

	# Update Line2D points for the trail
	update_trail()

	# Check if the missile has reached the target
	if global_position.distance_to(target_position) < speed * delta:
		# Handle what happens when the missile reaches the target
		queue_free()  # For example, remove the missile

func update_trail():
	# Add current position to the points list
	trail_points.append(global_position)

	# Keep only the last `trail_length` points
	if trail_points.size() > trail_length:
		trail_points.pop_front()

	# Update the Line2D points using PackedVector2Array
	var packed_points = PackedVector2Array(trail_points)
	$Line2D.points = packed_points
