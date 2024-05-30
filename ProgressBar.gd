extends ProgressBar

@export var true_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_progress(progress_amount):
	#true_value += progress_amount
	#print(true_value)
	#if true_value > 50:
		#var foreground_theme = load("res://progressbar_foreground.tres")
		#var background_theme = load("res://progressbar_background.tres")
		#background_theme.bg_color = foreground_theme.bg_color
		#foreground_theme.bg_color = "fff"
		#value = 0
		#true_value = 0
	#
	#var tween = create_tween()
	#
	#tween.tween_property(self, "value", true_value, 1).set_trans(Tween.TRANS_LINEAR)
	#tween.finished.connect(_on_tween_finished)
	value += progress_amount
	color_updater()

func color_updater():
	var foreground_theme = load("res://progressbar_foreground.tres")
	var background_theme = load("res://progressbar_background.tres")
	var particle_colors = load("res://particle_process_material.tres")
	if value < 50:
		min_value = 0
		max_value = 50
		background_theme.bg_color = "#0D1520"
		foreground_theme.bg_color = "#0D2847"
		particle_colors.color = "0D2847"
	elif value < 100:
		min_value = 50
		max_value = 100
		background_theme.bg_color = "#0D2847"
		foreground_theme.bg_color = "#104D87"
		particle_colors.color = "#104D87"
	elif value < 150:
		min_value = 100
		max_value = 150
		background_theme.bg_color = "#104D87"
		foreground_theme.bg_color = "#0090FF"
		particle_colors.color = "#0090FF"
	elif value < 200:
		min_value = 150
		max_value = 200
		background_theme.bg_color = "#0090FF"
		foreground_theme.bg_color = "#5B5BD6"
		particle_colors.color = "#5B5BD6"
	elif value < 250:
		min_value = 200
		max_value = 250
		background_theme.bg_color = "#5B5BD6"
		foreground_theme.bg_color = "#8E4EC6"
		particle_colors.color = "#8E4EC6"
		
	
func _on_tween_finished():
	if value != true_value:
		add_progress(0)
	else:
		return
