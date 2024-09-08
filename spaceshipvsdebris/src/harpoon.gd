extends CharacterBody2D
var phase=0 #Tells whether the harpoon is shooting or retracting.
var par:Node #The player to retract towards.
var rot=5 #Makes the harpoon spin
var anim:AnimatedSprite2D #The AnimatedSprite, so it can change how it looks.
var sc=0 #If you should get fuel back or not.

func _ready() -> void:
	anim=get_child(1) #Set anim to the actual AnimatedSprite of the harpoon

func _physics_process(delta: float) -> void:
	velocity+=2*delta*(Vector2(640,2000)-position).normalized()*((velocity.length()**2)/
	(position-Vector2(640,2000)).length()) # Gravity
	rotation+=rot*delta #Makes self rotate
	if phase==0: #If shooting,
		var C=move_and_collide(velocity*delta) #Move and check for debris
		if C: # If colliding with something,
			var c=C.get_collider() #get the thing colliding with self.
			if c.collision_layer==2: #If it's debris,
				c.die=1 #Kill it and get score,
				get_child(2).playing=true #Play a sound,
				phase=1 #Start retracting,
				collision_mask=1 #Make self collide w/ the player
				anim.animation="Phase1" #Change its sprite,
				sc=1 #And make sure to give back fuel to the player.
			else: #If it's not debris,
				par.hooks+=1 #Give back a hook to the player,
				queue_free() #And die.
	else: #If retracting,
		var C=move_and_collide((par.position-position).normalized()*1000*delta)
			#Move towards the player and look for the player
		if C and C.get_collider().name=="Spaceship": #If colliding with player,
			if sc: #Give back score if necessary
				par.fuel+=10
			par.hooks+=1 #Give back a hook,
			queue_free() #And die.
	if (par.position-position).length()>500: #If too far from the player,
		phase=1 #Return, but don't give score.
		collision_mask=1
