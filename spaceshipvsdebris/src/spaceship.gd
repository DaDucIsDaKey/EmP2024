extends CharacterBody2D
var fuel=100 #Amount of Fuel
var hooks=3 #Amount of Hooks
var laser=preload("res://src/laser.tscn") #Laser
var harpoon=preload("res://src/harpoon.tscn") #Harpoon
var Audio:AudioStreamPlayer #The audio player.
var score=0 #Amount of Score
@export var HH: Node2D #The parent of the harpoons, so they don't move around
	#with the player
signal death_screen #Creates a new signal so that the game over screen exists.
const SPEED = 100 #The spaceship's speed

#Makes the spaceship go a little up at the beginning to make starting easier.
func _ready() -> void:
	velocity=Vector2(0,-10)
	
	Audio=get_child(2) #Gets the audio player.

#Manages Fuel and Shooting
func _process(delta: float) -> void:
	if fuel>100:
		fuel=100 #Fuel can't go past 100
		
	if Input.is_action_just_pressed("left_mouse_button"):
		if hooks>0: #If you have any hooks left,
			var nyw=harpoon.instantiate() #Make a new harpoon
			nyw.global_position=global_position #Move it to self
			nyw.par=self #Set the player to yourself
			nyw.velocity=Vector2(1000,0).rotated(rotation-PI/2)+velocity
			#Launch it
			HH.add_child(nyw) #Make it actually exist
			hooks-=1 #Reduce the amount of hooks that you have
			fuel-=2 #You use fuel to launch things
	if Input.is_action_just_pressed("right_mouse_button"):
		var nyw=laser.instantiate() #Create a new laser
		nyw.position=Vector2(0,-500) #Move it so that it's in front of you
		add_child(nyw) #Make it a child of you, so that you can wave it around

#Manages Movement
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position()) 
	rotation+=PI/2 #These two lines make the spaceship look at the cursor
	var direction=Input.get_axis("ui_up","ui_down") #Input from Keyboard
	if direction:
		fuel-=delta*2 #You use fuel to move
		Audio.playing=true #Start Audio
	else:
		Audio.playing=false #Stop Audio
	velocity.y+=0.5*delta*(direction*SPEED+(((2000-position.y)**2)/300000)) 
		#Adds gravity and movement

	var c=move_and_collide(velocity*delta*60) #This actually moves the player
		#It also returns anything that collides with the player
	if c and c.get_collider().collision_layer==2: #If it's a piece of debris,
		fuel-=20 #We lose fuel
		c.get_collider().queue_free() #And the debris disappears.
	elif c and c.get_collider().collision_layer==4: #If it's the earth,
		emit_signal("death_screen") #You die.
		get_tree().set_pause(true) #The game ends.
	elif c and c.get_collider().collision_layer==1: #If it's the ceiling,
		velocity=Vector2(0,0) #You stop moving.
	position.x = 640 # If you previously were pushed, return to where you are.

	if fuel<0: #If you run out of fuel, you die.
		emit_signal("death_screen")
		get_tree().set_pause(true)
