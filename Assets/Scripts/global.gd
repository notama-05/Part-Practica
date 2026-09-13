extends Node

var record: int = 0
var sierra_skin: int = 0
var actual_score
var paso = 1

var save_path = "user://Save.txt"


func _ready():
	cargar_datos()


func save_data():
	var archivo = FileAccess.open(save_path, FileAccess.WRITE)

	if archivo:
		archivo.store_line(str(record))
		archivo.store_line(str(sierra_skin))
	else:
		print("No se ha podido abrir el archivo")


func cargar_datos():
	if not FileAccess.file_exists(save_path):
		return

	var archivo = FileAccess.open(save_path, FileAccess.READ)

	if archivo:
		var lineas = archivo.get_as_text().split("\n")

		if lineas.size() >= 1 and lineas[0] != "":
			record = int(lineas[0])

		if lineas.size() >= 2 and lineas[1] != "":
			sierra_skin = int(lineas[1])
