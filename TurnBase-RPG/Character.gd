extends Node2D
class_name Character

@export var is_player : bool
@export var cur_hp : int = 25
@export var max_hp : int = 25

@export var combat_action : Array[CombatAction]
@export var opponent : Node

@onready var health_bar : ProgressBar = get_node("HealthBar")
@onready var health_text : Label = get_node("HealthBar/HealthText")

@export var visual : Texture2D
@export var flip_visual : bool

func _ready():
	$Sprite2D.texture = visual
	$Sprite2D.flip_h = flip_visual
	
	get_node("/root/BattleScene").character_begin_turn.connect(on_character_begin_turn)
	health_bar.max_value = max_hp
	update_health_bar()

func take_damage(damage):
	cur_hp -= damage
	update_health_bar()
	
	#If the dragon die then destroy him
	if cur_hp <= 0:
		get_node("/root/BattleScene").character_died(self)
		queue_free()

func heal(amount):
	cur_hp += amount
	update_health_bar()
	
	#if current hp is greater than max hp, then current hp is equal at max hp
	if cur_hp > max_hp:
		cur_hp = max_hp

func update_health_bar():
	health_bar.value = cur_hp
	health_text.text = str(cur_hp, " / ", max_hp)

func on_character_begin_turn(character):
	if character == self and is_player == false:
		decide_combat_action()

func cast_combat_action(action):
	if action.damage > 0:
		opponent.take_damage(action.damage)
	elif action.heal > 0:
		heal(action.heal)
	
	get_node("/root/BattleScene").end_current_turn()

func decide_combat_action():
	var health_percent = float (cur_hp) / float (max_hp)
	
	for i in combat_action:
		var action = i as CombatAction
		
		if action.heal > 0:
			if randf() > health_percent + 0.2:
				cast_combat_action(action)
				return
			else:
				continue
		else:
			cast_combat_action(action)
			return
