extends Label
@export var player: Node2D

#Updates score
func _process(delta: float) -> void:
	text=str(player.score) 
