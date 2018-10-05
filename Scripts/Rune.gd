extends Node2D

export(PackedScene) var spell

onready var global = get_node("/root/Global")
var _attack_range
var _fire_delta
var _damage
var _speed
var _spell_sprite
var _power_level
var _max_power_level
var _cost
var _debuff
var _details
var _color
var cursor_hovering = false
var fire_next = 0.0
var target = null
var spell_scale
var firing = false
var time = 0.0


func _ready():
	add_to_group("runes")


func init(d, power_level):
	get_node("Sprite").set_texture(load("res://Assets/" + d["rune_sprite"] + ".png"))
	_color = d["rune_color"]
	_speed =  d["speed"]
	_attack_range = d["attack_range"]
	_fire_delta = d["fire_delta"]
	_damage = d["damage"]
	_spell_sprite = d["spell_sprite"]
	_max_power_level = d["max_power_level"]
	_power_level = power_level
	_cost = d["cost"]
	_debuff = d["debuff"]
	_details = d
	modulate = Color(_color.r, _color.g, _color.b)


func _process(delta):
	time += delta #
	var target = choose_target()
	if target != null and !firing:
		_shoot(target)


func choose_target():
	var pos = get_global_position()
	
	# Check if existing target is still within range
	if target != null and target.get_ref() and pos.distance_to(target.get_ref().get_global_position()) <= _attack_range:
		return target
	else:
		target = null
	
	# If not, check if new enemy is in range, and choose closest one if multiple
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if pos.distance_to(enemy.get_global_position()) <= _attack_range:
			if (target == null 
				or !target.get_ref() 
				or pos.distance_to(enemy.get_global_position()) > get_global_position().distance_to(target.get_ref().get_global_position())):
					target = weakref(enemy)	
	return target


func _shoot(target):
	if time > fire_next:
		firing = true
		var new_spell = spell.instance()
		new_spell.get_node("Sprite").set_texture(load("res://Assets/" + _spell_sprite + ".png"))
		new_spell.set_scale(spell_scale)
		new_spell.target = target
		new_spell.rune = weakref(self)
		new_spell.position = get_global_position()
		fire_next = time + _fire_delta
		get_tree().get_root().add_child(new_spell)


func rearm():
	firing = false


func power_up():
	_power_level += 1
	global.mana -= _cost
	refresh_rune()


func power_down():
	_power_level -= 1
	global.mana += _cost
	refresh_rune()


func refresh_rune():
	_damage *= 1.0 + (_power_level / 10)
	global.mana_bar(global.mana)
	#_fire_delta = 1.0/(power - 10)
	#_speed *= 1.0 - (power / 10)
	#set_scale(Vector2(_power_level, _power_level))
	modulate = Color(_color.r / _power_level, _color.g / _power_level, _color.b / _power_level)
	spell_scale = Vector2(_power_level, _power_level)


func _input(event):
	if event.is_pressed():
		if cursor_hovering and event.button_index == BUTTON_WHEEL_UP and _power_level < _max_power_level and global.mana > _cost:
			power_up()
		if cursor_hovering and event.button_index == BUTTON_WHEEL_DOWN and _power_level > 1 and global.mana < global.mana_max:
			power_down()