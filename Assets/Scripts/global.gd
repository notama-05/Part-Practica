extends Node

var record: int = 0
var sierra_skin: int = 0
var actual_score: int = 0
var paso: int = 1

var MusicVolume: int = 80.0
var EffectsVolume: int = 80.0

var save_path := "user://Save.txt"


func _ready():
	cargar_datos()


func save_data():
	var archivo = FileAccess.open(save_path, FileAccess.WRITE)

	if archivo:
		archivo.store_line(str(record))
		archivo.store_line(str(sierra_skin))
		archivo.store_line(str(MusicVolume))
		archivo.store_line(str(EffectsVolume))
	else:
		print("No se ha podido abrir el archivo")


func cargar_datos():
	if not FileAccess.file_exists(save_path):
		return

	var archivo = FileAccess.open(save_path, FileAccess.READ)

	if archivo:
		var record_line = archivo.get_line()
		var skin_line = archivo.get_line()
		var music_line = archivo.get_line()
		var effects_line = archivo.get_line()

		if record_line != "":
			record = int(record_line)

		if skin_line != "":
			sierra_skin = int(skin_line)

		if music_line != "":
			MusicVolume = float(music_line)

		if effects_line != "":
			EffectsVolume = float(effects_line)
