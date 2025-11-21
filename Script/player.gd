extends CharacterBody3D

var currect_speed: float
var stamina = 0.0
@export var MAX_STAMIN: float = 100.0
@export var WALKING_SPEED: float = 7.0
@export var SPINTING_SPEED: float = 13.0

@export var sens: float = 0.25



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	currect_speed = WALKING_SPEED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * deg_to_rad(sens))
	
	if Input.is_action_pressed("sprint") and stamina != 0:
		currect_speed = SPINTING_SPEED

func _process(delta: float) -> void:
	if Input.is_action_pressed("sprint"):
		if stamina > 0:
			stamina -= 20 * delta
		elif stamina < 0:
			stamina = 0
		
	if Input.is_action_pressed("sprint") and stamina >= 0.1:
		currect_speed = SPINTING_SPEED
	if !Input.is_action_pressed("sprint") or stamina <= 0.1:
		currect_speed = WALKING_SPEED
	
	
	if stamina >= 0.0 and !Input.is_action_pressed("sprint"):
		if stamina < MAX_STAMIN:
			stamina += 25 * delta
		elif stamina > MAX_STAMIN:
			stamina = MAX_STAMIN
	
	
	print(stamina)


func _physics_process(_delta: float) -> void:
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * currect_speed
		velocity.z = direction.z * currect_speed
	else:
		velocity.x = move_toward(velocity.x, 0, currect_speed)
		velocity.z = move_toward(velocity.z, 0, currect_speed)

	move_and_slide()
