extends CharacterBody2D
var die=0 #This is so that it gives score in the correct scenarios.
var rot=0 #This makes the satellite spin.
var tipe=1 #This differentiates between the working and the broken satellites
var scorelist=[1,-2,2] #This is so that working and broken satellites give different scores
var player: Node #Who to give score to.

func _ready() -> void:
	rot=((randi()%200)-100)/20 #Randomly set rotation
	get_child(1).animation="tipe"+str(tipe) #Makes proper sprite

func _physics_process(delta: float) -> void:
	velocity+=delta*(Vector2(640,2000)-position).normalized()*((velocity.length()**2)/
	(position-Vector2(640,2000)).length()) #Gravity
	
	move_and_slide() #move
	rotation+=rot*delta
	if position.x>1400 or position.y>1200:
		queue_free() #Kills self if goes off-screen
	if die:
		player.score+=scorelist[tipe-1] #Gives score based on type
		queue_free() #Commits die
		
