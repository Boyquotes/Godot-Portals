extends RayCast

var holding = false
var heldBody : RigidBody

func _physics_process(delta):
	if Input.is_action_just_pressed("Pickup"):
		if !holding:
			var col = self.get_collider()
			if col is RigidBody:
				heldBody = col
				holding = true
		else:
			holding = false
	
	if holding:
		var targetPos = to_global(self.cast_to)
		var diff = targetPos - heldBody.global_transform.origin
		var drag = -heldBody.linear_velocity
		heldBody.add_central_force((diff * 200.0) + (drag * 1000.0) * delta)
	
	return
