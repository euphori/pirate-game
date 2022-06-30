extends Camera2D


var default_zoom = Vector2(1,1)
var target_zoom = Vector2(.5,.5)


const ZOOM_SPEED = Vector2(1.5,1.5)
const PAN_SPEED = 3

var in_dialogue = false

func _physics_process(delta):
	if in_dialogue:
		zoom_in(delta)
	else:
		zoom_out(delta)
		
func zoom_in(delta):
	
	if zoom > target_zoom:
		zoom -= ZOOM_SPEED * delta
	
	if position.y < -30:
		position.y += PAN_SPEED
	
func zoom_out(delta):
	if zoom < default_zoom:
		zoom += ZOOM_SPEED * delta
	if position.y > -60:
		position.y -= PAN_SPEED
