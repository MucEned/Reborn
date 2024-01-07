extends Area2D

signal hit

@export var speed = 400

var screen_size
var velocity = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	reset_velocity()
	input_checking()
	animation_checking()
	move(delta)

func reset_velocity():
	velocity = Vector2.ZERO

func input_checking():
	if Input.is_action_pressed("right_arrow"):
		velocity.x += 1
	if Input.is_action_pressed("left_arrow"):
		velocity.x -= 1
	if Input.is_action_pressed("down_arrow"):
		velocity.y += 1
	if Input.is_action_pressed("up_arrow"):
		velocity.y -= 1

func animation_checking():
	if velocity.x != 0:
		$Animator.animation = "walk"
		$Animator.flip_v = false
		$Animator.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$Animator.animation = "up"
		$Animator.flip_v = velocity.y > 0
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$Animator.play()
	else:
		$Animator.stop()

func move(delta):
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
func start(pos):
	position = pos
	show()
	$HurtBox.disabled = false

func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$HurtBox.set_deferred("disabled", true)
	pass # Replace with function body.
