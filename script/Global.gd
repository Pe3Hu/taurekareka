extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.supply = ["economy", "gladiator", "training"]
	arr.type = ["gladiator", "patron", "scheme", "income"]


func init_num() -> void:
	num.index = {}


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	init_supply()


func init_supply() -> void:
	dict.supply = {}
	dict.supply.basic = {}
	
	
	init_card()
	init_ability()


func init_card() -> void:
	dict.card = {}
	dict.card.title = {}
	var path = "res://asset/json/taurekareka_card.json"
	var array = load_data(path)
	
	for card in array:
		var data = {}
		
		for key in card:
			match typeof(card[key]):
				TYPE_FLOAT:
					card[key] = int(card[key])
					data[key] = card[key]
				TYPE_STRING:
					if card[key] != "no":
						data[key] = card[key]
			
			var words = key.split(" ")
			
			if words.size() > 1:
				for key_ in data:
					if words.has(key_):
						if !data[key_].has(words[1]):
							data[key_][words[1]] = {}
						
						data[key_][words[1]] = card[key]
		
		dict.card.title[data.title] = data
		dict.card.title[data.title].erase("title")


func init_ability() -> void:
	dict.ability = {}
	dict.ability.index = {}
	var path = "res://asset/json/taurekareka_ability.json"
	var array = load_data(path)
	
	for ability in array:
		var data = {}
		
		for key in ability:
			var words = key.split(" ")
			
			if words.size() > 1:
				if !data.has(words[0]):
					data[words[0]] = {}
				
				if ability[key] != "no":
					data[words[0]][words[1]] = ability[key]
			else:
				data[key] = ability[key]
		
		dict.ability.index[data.index] = data
		
		if data["return"].keys().is_empty():
			dict.ability.index[data.index].erase("return")
			
		dict.ability.index[data.index].erase("index")
	
	print(dict.ability.index)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.sketch = load("res://scene/0/sketch.tscn")
	pass


func init_vec():
	vec.size = {}
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	color.indicator = {}


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()
