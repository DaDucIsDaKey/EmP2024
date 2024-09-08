extends Area2D
var die=4 # Set the time that the laser can exist for


func _ready() -> void:
	get_child(2).playing=true


func _process(delta: float) -> void:
	if die<=0 or Input.is_action_just_released("right_mouse_button"):
		queue_free() #If you stop holding the button, the laser disappears.
	else:
		die-=delta #Tick down its lifetime.
		get_parent().fuel-=delta*20 #Reduce the amount of fuel the player has.
		for i in get_overlapping_bodies():
			if i.collision_layer==2:
				i.die=1 #Destroy all debris in the laser.
