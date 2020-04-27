extends KinematicBody


var velocity = Vector3()
var gravity = -9.8
var speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var jump = 3
var jumping = false

var has_key = false
var has_crate = false

var health = 100

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	if Input.is_action_pressed("jump"):
		jumping = true
	input_dir = input_dir.normalized()
	return input_dir


func _physics_process(delta):
	if health <= 0:
		return
	velocity.y += gravity * delta
	var desired_velocity = get_input() * speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	if jumping and is_on_floor():
		velocity.y = jump
	jumping = false
	velocity = move_and_slide(velocity, Vector3.UP, true)

func _unhandled_input(event):
	if health <= 0:
		return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)

onready var Camera = $Camera

var velocity = Vector3()
var speed = 10
var max_speed = 100
var turn_sensitivity = 2
var rot_sensitivity = 20

var turning = 0
var pitching = 0
var decay = 0.5

var rot_x = 0.0
var rot_y = 0.0
var rot_z = 0.0

func _ready():
	pass

func get_input(delta):
	if Input.is_action_pressed("Up"):
		rot_x += rot_sensitivity * delta
	if Input.is_action_pressed("Down"):
		rot_x -= rot_sensitivity * delta
	if Input.is_action_pressed("Left"):
		rot_y += rot_sensitivity * delta
		turning += turn_sensitivity
	if Input.is_action_pressed("Right"):
		rot_y -= rot_sensitivity * delta
		turning -= turn_sensitivity
	turning = clamp(turning, -30.0, 30.0)


func _physics_process(delta):
	get_input(delta)

	turning = sign(turning) * (abs(turning) - decay)
	if abs(turning) < decay: turning = 0
	
	rotation_degrees.x = rot_x
	rotation_degrees.y = rot_y
	rotation_degrees.z = turning
	
	translate(-$Reference.transform.basis.z * speed * delta)

