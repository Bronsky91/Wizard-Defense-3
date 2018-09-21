extends Node2D

export var speed = 450
export var damage = 25
var direction = Vector2(0, -1)
var target = null
var rune = null


func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if target and target.get_ref():
		var pos = get_global_position()
		if target.get_ref().get_global_position().distance_to(get_global_position()) < 10:
			target_hit()
			return
		direction = (target.get_ref().get_global_position() - pos).normalized()
		var rad_angle = atan2(-direction.x, direction.y)
		set_rotation(rad_angle)
		set_position(pos + (direction * speed * delta))
	else:
		# TODO: special animation or behavior for fireball whose target dies before reaching it?
		# TODO: extra logic to account for runes that may be destroyed before this part of the spell code is executed
		rune.get_ref().rearm()
		queue_free()


func target_hit():
	# TODO: extra logic to account for runes that may be destroyed before this part of the spell code is executed
	rune.get_ref().rearm()
	target.get_ref().take_damage(damage)
	var global = get_node("/root/Global")
	global.increase_ult_charge(damage)
	queue_free()