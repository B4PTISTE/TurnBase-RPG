extends VBoxContainer

@export var buttons : Array[NodePath]


func _ready():
	get_node("/root/BattleScene").character_begin_turn.connect(on_character_begin_turn)
	get_node("/root/BattleScene").character_end_turn.connect(on_character_end_turn)

func on_character_begin_turn(character):
	visible = character.is_player
	
	if character.is_player:
		display_combat_action(character.combat_action)

func on_character_end_turn(character):
	visible = false

func display_combat_action(combat_actions):
	for i in len(buttons):
		var button = get_node(buttons[i])
		
		if i < len(combat_actions):
			button.visible = true
			button.text = combat_actions[i].display_name
			button.combat_action = combat_actions[i]
		else:
			button.visible = false
