extends Node2D

@onready var record = $Record
@onready var score = $VBoxContainer/Score
@onready var score_label = $VBoxContainer/Score_text
@onready var rank = $VBoxContainer/Rank

var rank_value
var ranks = ["noobie", "amateur", "professional", "wow, that was good!", 
"are you cheating?", "you are definitely cheating"]

func _ready():
	score.text = str(Global.actual_score)
	if Global.actual_score > Global.record:
		Global.record = Global.actual_score
		score_label.text = "New Highscore"
	else:
		score_label.text = "Score"
	rank_value = floor(Global.actual_score/10)
	rank.text = ranks[rank_value]
	record.text = str(Global.record)
	Global.save_data()

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/main.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/init_menu.tscn")

func _on_exit_pressed():
	get_tree().quit()
