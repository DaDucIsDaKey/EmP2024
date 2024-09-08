extends ProgressBar
@export var player: Node2D #Accesses player variables

#Sets the length of the bar to the amount of fuel
func _process(delta):
	value=player.fuel
