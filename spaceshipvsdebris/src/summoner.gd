extends Node2D
var cool=0 #Cooldown for creating a new piece of debris
var Deb = preload("res://src/debris.tscn") #Preloads Debris
var time = 0 #Timer
@export var player:Node #The player, so the debris knows what to give score to.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time+=delta #Tick timer
	
	if cool<=0: #If there should be another piece of debris,
		cool=1/(2+time/10) #Reset cooldown,
		var nextThing = Deb.instantiate() #Create a new piece of debris,
		nextThing.position=Vector2(0,randi()%800+200) #Randomly position it,
		var a = randi()%300+300 
		nextThing.velocity=Vector2(a,-a) #And generate a random velocity for it.
		if randf()>0.9: #10% of the time,
			nextThing.tipe=2 #It is a working satellite.
		else: #90% of the time,
			nextThing.tipe=1 #It is a piece of debris.
		nextThing.player=player #Set the player, for scoring purposes.
		add_child(nextThing) #Actually add the debris into the game.
	cool-=delta #Tick cooldown.
