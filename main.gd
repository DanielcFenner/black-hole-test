extends Node2D
const ORB = preload("res://orb.tscn")
@onready var black_hole = $"Black Hole"
var placed_black_hole_position : Vector2
@onready var detector = $"Black Hole/Detector"
const PARTICLE_EXPLODE = preload("res://particle_explode.tscn")
const POP = preload("res://assets/pop.mp3")
const GRAVITY_STRENGTH = 1000
@onready var label = $Label
@onready var circle = $"Node/Circle Inner"
@onready var popper = $Popper
@onready var shiny = $"Node/Circle Inner/Shiny"
@onready var shiny_2 = $"Node/Circle Inner/Shiny2"
@onready var shiny_3 = $"Node/Circle Inner/Shiny3"
@onready var shiny_5 = $"Node/Circle Inner/Shiny5"
@onready var progress_bar = $ProgressBar
@onready var particle_mask = $ProgressBar/ParticleMask
@onready var sub_goal = $"ProgressBar/Sub Goal"


# Called when the node enters the scene tree for the first time.
func _ready():
	#black_hole.gravity = GRAVITY_STRENGTH
	placed_black_hole_position = black_hole.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("1"):
		spawn_orbs(5)
	if Input.is_action_just_pressed("2"):
		spawn_orbs(25)
	if Input.is_action_just_pressed("3"):
		spawn_orbs(100)
	if Input.is_action_just_pressed("4"):
		spawn_orbs(500)
	shiny.rotation_degrees += 20 * delta
	shiny_2.rotation_degrees -= 30 * delta
	shiny_3.rotation_degrees -= 15 * delta
	shiny_5.rotation_degrees += 20 * delta

# Switch orb gravity
func orb_gravity_flip(orb):
	if orb == null:
		return
	if orb.gravity_scale == 0:
		orb.gravity_scale = 1
	else:
		orb.gravity_scale = 0
		orb.linear_velocity = Vector2(0, 0)
		
# Switch orb gravity after timer
func set_orb_gravity_flip_timer(orb, duration):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout").bind(orb))
	add_child(timer)
	timer.start()

# After time to switch orb gravity
func _on_timer_timeout(orb):
	orb_gravity_flip(orb)
	orb.linear_velocity = Vector2(randf_range(-30, 30), randf_range(-30, 30))
	
func spawn_orbs(orb_amount: int):
	# Move black hole to bottom of the screen
	$Label.visible = true
	black_hole.position = Vector2(960.0, 300)
	detector.monitoring = false
	
	# Spawn orbs
	var orbs = []
	for i in orb_amount:
		var new_orb = ORB.instantiate()
		var random_x = randi_range(200, 1720)
		new_orb.position.x = random_x
		new_orb.position.y = 0
		add_child(new_orb)
		var random_velocity_x = randf_range(-30, 30)
		new_orb.linear_velocity = Vector2(random_velocity_x, 800)
		orbs.append(new_orb)
		
	# Gravity switched off for each orb
	for orb in orbs:
		var timer_duration = randf_range(0.05, 0.3)
		set_orb_gravity_flip_timer(orb, timer_duration)
		
	# Wait for alert to finish
	await get_tree().create_timer(5.0).timeout
	$Label.visible = false
	
	# Move black hole to intended position
	black_hole.position = placed_black_hole_position
	
	
	# Switch gravity on for orbs and apply random velocity to make it look cool
	for orb in orbs:
		#await get_tree().create_timer(randf_range(0, 0.1)).timeout
		orb_gravity_flip(orb)
		var random_velocity = randf_range(-500, 500)
		orb.linear_velocity = Vector2(random_velocity, random_velocity)
	
	detector.monitoring = true


func _on_detector_body_entered(body):
	var new_explosion = PARTICLE_EXPLODE.instantiate()
	new_explosion.position = progress_bar.global_position
	#new_explosion.scale = circle.scale * 10
	progress_bar.add_child(new_explosion)
	new_explosion.emitting = true
	popper.play()
	body.queue_free()
	progress_bar.add_progress(1)
	sub_goal_updater()
	
func sub_goal_updater():
	sub_goal.text = "SUB GOAL " + str(progress_bar.value / 5) + "/10"
