extends Control

@export var grid_container: GridContainer
@export var panel: Panel
@export var label: Label 
@export var popup_margin: MarginContainer 
@export var popup_panel: Panel 
@export var popup_label: Label
@export var popup_date_label: Label
@export var popup_image: TextureRect

var periods: int = 7+3
var groups: int = 18
var btn_size: int = 50
var screen_size = get_viewport_rect().size

#Database di tutti gli elementi
var elements: Dictionary = {
	# Periodo 1
	"H":  {"name": "Idrogeno", "number": 1, "category": "Non metallo", "group": 1, "period": 1,
	 "scientist_name": "Hodgkin Dorothy", "image": "res://Images/images.jpeg", "description": "un giorno pisilla", "year": "1863"},
	
	"He": {"name": "Elio", "number": 2, "category": "Gas nobile", "group": 18, "period": 1},

	# Periodo 2
	"Li": {"name": "Litio", "number": 3, "category": "Metallo alcalino", "group": 1, "period": 2},
	"Be": {"name": "Berillio", "number": 4, "category": "Metallo alcalino-terroso", "group": 2, "period": 2},
	"B":  {"name": "Boro", "number": 5, "category": "Metalloide", "group": 13, "period": 2},
	"C":  {"name": "Carbonio", "number": 6, "category": "Non metallo", "group": 14, "period": 2},
	"N":  {"name": "Azoto", "number": 7, "category": "Non metallo", "group": 15, "period": 2},
	"O":  {"name": "Ossigeno", "number": 8, "category": "Non metallo", "group": 16, "period": 2},
	"F":  {"name": "Fluoro", "number": 9, "category": "Alogen", "group": 17, "period": 2},
	"Ne": {"name": "Neon", "number": 10, "category": "Gas nobile", "group": 18, "period": 2},

	# Periodo 3
	"Na": {"name": "Sodio", "number": 11, "category": "Metallo alcalino", "group": 1, "period": 3},
	"Mg": {"name": "Magnesio", "number": 12, "category": "Metallo alcalino-terroso", "group": 2, "period": 3},
	"Al": {"name": "Alluminio", "number": 13, "category": "Metallo post-transizionale", "group": 13, "period": 3},
	"Si": {"name": "Silicio", "number": 14, "category": "Metalloide", "group": 14, "period": 3},
	"P":  {"name": "Fosforo", "number": 15, "category": "Non metallo", "group": 15, "period": 3},
	"S":  {"name": "Zolfo", "number": 16, "category": "Non metallo", "group": 16, "period": 3},
	"Cl": {"name": "Cloro", "number": 17, "category": "Alogen", "group": 17, "period": 3},
	"Ar": {"name": "Argon", "number": 18, "category": "Gas nobile", "group": 18, "period": 3},

	# Periodo 4
	"K":  {"name": "Potassio", "number": 19, "category": "Metallo alcalino", "group": 1, "period": 4},
	"Ca": {"name": "Calcio", "number": 20, "category": "Metallo alcalino-terroso", "group": 2, "period": 4},
	"Sc": {"name": "Scandio", "number": 21, "category": "Metallo di transizione", "group": 3, "period": 4},
	"Ti": {"name": "Titanio", "number": 22, "category": "Metallo di transizione", "group": 4, "period": 4},
	"V":  {"name": "Vanadio", "number": 23, "category": "Metallo di transizione", "group": 5, "period": 4},
	"Cr": {"name": "Cromo", "number": 24, "category": "Metallo di transizione", "group": 6, "period": 4},
	"Mn": {"name": "Manganese", "number": 25, "category": "Metallo di transizione", "group": 7, "period": 4},
	"Fe": {"name": "Ferro", "number": 26, "category": "Metallo di transizione", "group": 8, "period": 4},
	"Co": {"name": "Cobalto", "number": 27, "category": "Metallo di transizione", "group": 9, "period": 4},
	"Ni": {"name": "Nichel", "number": 28, "category": "Metallo di transizione", "group": 10, "period": 4},
	"Cu": {"name": "Rame", "number": 29, "category": "Metallo di transizione", "group": 11, "period": 4},
	"Zn": {"name": "Zinco", "number": 30, "category": "Metallo di transizione", "group": 12, "period": 4},
	"Ga": {"name": "Gallio", "number": 31, "category": "Metallo post-transizionale", "group": 13, "period": 4},
	"Ge": {"name": "Germanio", "number": 32, "category": "Metalloide", "group": 14, "period": 4},
	"As": {"name": "Arsenico", "number": 33, "category": "Metalloide", "group": 15, "period": 4},
	"Se": {"name": "Selenio", "number": 34, "category": "Non metallo", "group": 16, "period": 4},
	"Br": {"name": "Bromo", "number": 35, "category": "Alogen", "group": 17, "period": 4},
	"Kr": {"name": "Kripton", "number": 36, "category": "Gas nobile", "group": 18, "period": 4},

	# Periodo 5
	"Rb": {"name": "Rubidio", "number": 37, "category": "Metallo alcalino", "group": 1, "period": 5},
	"Sr": {"name": "Stronzio", "number": 38, "category": "Metallo alcalino-terroso", "group": 2, "period": 5},
	"Y":  {"name": "Ittrio", "number": 39, "category": "Metallo di transizione", "group": 3, "period": 5},
	"Zr": {"name": "Zirconio", "number": 40, "category": "Metallo di transizione", "group": 4, "period": 5},
	"Nb": {"name": "Niobio", "number": 41, "category": "Metallo di transizione", "group": 5, "period": 5},
	"Mo": {"name": "Molibdeno", "number": 42, "category": "Metallo di transizione", "group": 6, "period": 5},
	"Tc": {"name": "Tecnezio", "number": 43, "category": "Metallo di transizione", "group": 7, "period": 5},
	"Ru": {"name": "Rutenio", "number": 44, "category": "Metallo di transizione", "group": 8, "period": 5},
	"Rh": {"name": "Rodio", "number": 45, "category": "Metallo di transizione", "group": 9, "period": 5},
	"Pd": {"name": "Palladio", "number": 46, "category": "Metallo di transizione", "group": 10, "period": 5},
	"Ag": {"name": "Argento", "number": 47, "category": "Metallo di transizione", "group": 11, "period": 5},
	"Cd": {"name": "Cadmio", "number": 48, "category": "Metallo di transizione", "group": 12, "period": 5},
	"In": {"name": "Indio", "number": 49, "category": "Metallo post-transizionale", "group": 13, "period": 5},
	"Sn": {"name": "Stagno", "number": 50, "category": "Metallo post-transizionale", "group": 14, "period": 5},
	"Sb": {"name": "Antimonio", "number": 51, "category": "Metalloide", "group": 15, "period": 5},
	"Te": {"name": "Tellurio", "number": 52, "category": "Metalloide", "group": 16, "period": 5},
	"I":  {"name": "Iodio", "number": 53, "category": "Alogen", "group": 17, "period": 5},
	"Xe": {"name": "Xeno", "number": 54, "category": "Gas nobile", "group": 18, "period": 5},

	# Periodo 6
	"Cs": {"name": "Cesio", "number": 55, "category": "Metallo alcalino", "group": 1, "period": 6},
	"Ba": {"name": "Bario", "number": 56, "category": "Metallo alcalino-terroso", "group": 2, "period": 6},
	
	#"57-71": {"name": "Vedi Lantanidi", "number": "Vedi Lantanidi", "category": "Vedi Lantanidi", "group": 3, "period": 6},
	
	#"Ce": {"name": "Cerio", "number": 58, "category": "Lantanide", "group": 3, "period": 6},
	#"Pr": {"name": "Praseodimio", "number": 59, "category": "Lantanide", "group": 3, "period": 6},
	#"Nd": {"name": "Neodimio", "number": 60, "category": "Lantanide", "group": 3, "period": 6},
	#"Pm": {"name": "Promezio", "number": 61, "category": "Lantanide", "group": 3, "period": 6},
	#"Sm": {"name": "Samario", "number": 62, "category": "Lantanide", "group": 3, "period": 6},
	#"Eu": {"name": "Europio", "number": 63, "category": "Lantanide", "group": 3, "period": 6},
	#"Gd": {"name": "Gadolinio", "number": 64, "category": "Lantanide", "group": 3, "period": 6},
	#"Tb": {"name": "Terbio", "number": 65, "category": "Lantanide", "group": 3, "period": 6},
	#"Dy": {"name": "Disprosio", "number": 66, "category": "Lantanide", "group": 3, "period": 6},
	#"Ho": {"name": "Olmio", "number": 67, "category": "Lantanide", "group": 3, "period": 6},
	#"Er": {"name": "Erbio", "number": 68, "category": "Lantanide", "group": 3, "period": 6},
	#"Tm": {"name": "Tulio", "number": 69, "category": "Lantanide", "group": 3, "period": 6},
	#"Yb": {"name": "Itterbio", "number": 70, "category": "Lantanide", "group": 3, "period": 6},
	#"Lu": {"name": "Lutezio", "number": 71, "category": "Lantanide", "group": 3, "period": 6},
	"Hf": {"name": "Hafnio", "number": 72, "category": "Metallo di transizione", "group": 4, "period": 6},
	"Ta": {"name": "Tantalio", "number": 73, "category": "Metallo di transizione", "group": 5, "period": 6},
	"W":  {"name": "Tungsteno", "number": 74, "category": "Metallo di transizione", "group": 6, "period": 6},
	"Re": {"name": "Renio", "number": 75, "category": "Metallo di transizione", "group": 7, "period": 6},
	"Os": {"name": "Osmio", "number": 76, "category": "Metallo di transizione", "group": 8, "period": 6},
	"Ir": {"name": "Iridio", "number": 77, "category": "Metallo di transizione", "group": 9, "period": 6},
	"Pt": {"name": "Platino", "number": 78, "category": "Metallo di transizione", "group": 10, "period": 6},
	"Au": {"name": "Oro", "number": 79, "category": "Metallo di transizione", "group": 11, "period": 6},
	"Hg": {"name": "Mercurio", "number": 80, "category": "Metallo di transizione", "group": 12, "period": 6},
	"Tl": {"name": "Tallio", "number": 81, "category": "Metallo post-transizionale", "group": 13, "period": 6},
	"Pb": {"name": "Piombo", "number": 82, "category": "Metallo post-transizionale", "group": 14, "period": 6},
	"Bi": {"name": "Bismuto", "number": 83, "category": "Metallo post-transizionale", "group": 15, "period": 6},
	"Po": {"name": "Polonio", "number": 84, "category": "Metalloide", "group": 16, "period": 6},
	"At": {"name": "Astato", "number": 85, "category": "Alogen", "group": 17, "period": 6},
	"Rn": {"name": "Radon", "number": 86, "category": "Gas nobile", "group": 18, "period": 6},

	# Periodo 7
	"Fr": {"name": "Francio", "number": 87, "category": "Metallo alcalino", "group": 1, "period": 7},
	"Ra": {"name": "Radio", "number": 88, "category": "Metallo alcalino-terroso", "group": 2, "period": 7},
	#"89-103": {"name": "Vedi attanidi", "number": "Vedi attanidi", "category": "Vedi attanidi", "group": 3, "period": 7},
	#"Th": {"name": "Torio", "number": 90, "category": "Attinide", "group": 3, "period": 7},
	#"Pa": {"name": "Protoattinio", "number": 91, "category": "Attinide", "group": 3, "period": 7},
	#"U":  {"name": "Uranio", "number": 92, "category": "Attinide", "group": 3, "period": 7},
	#"Np": {"name": "Nettunio", "number": 93, "category": "Attinide", "group": 3, "period": 7},
	#"Pu": {"name": "Plutonio", "number": 94, "category": "Attinide", "group": 3, "period": 7},
	#"Am": {"name": "Americio", "number": 95, "category": "Attinide", "group": 3, "period": 7},
	#"Cm": {"name": "Curio", "number": 96, "category": "Attinide", "group": 3, "period": 7},
	#"Bk": {"name": "Berkelio", "number": 97, "category": "Attinide", "group": 3, "period": 7},
	#"Cf": {"name": "Californio", "number": 98, "category": "Attinide", "group": 3, "period": 7},
	#"Es": {"name": "Einsteinio", "number": 99, "category": "Attinide", "group": 3, "period": 7},
	#"Fm": {"name": "Fermio", "number": 100, "category": "Attinide", "group": 3, "period": 7},
	#"Md": {"name": "Mendelevio", "number": 101, "category": "Attinide", "group": 3, "period": 7},
	#"No": {"name": "Nobelio", "number": 102, "category": "Attinide", "group": 3, "period": 7},
	#"Lr": {"name": "Laurenzio", "number": 103, "category": "Attinide", "group": 3, "period": 7},
	"Rf": {"name": "Rutherfordio", "number": 104, "category": "Metallo di transizione", "group": 4, "period": 7},
	"Db": {"name": "Dubnio", "number": 105, "category": "Metallo di transizione", "group": 5, "period": 7},
	"Sg": {"name": "Seaborgio", "number": 106, "category": "Metallo di transizione", "group": 6, "period": 7},
	"Bh": {"name": "Bohrio", "number": 107, "category": "Metallo di transizione", "group": 7, "period": 7},
	"Hs": {"name": "Hassio", "number": 108, "category": "Metallo di transizione", "group": 8, "period": 7},
	"Mt": {"name": "Meitnerio", "number": 109, "category": "Metallo di transizione", "group": 9, "period": 7},
	"Ds": {"name": "Darmstadtio", "number": 110, "category": "Metallo di transizione", "group": 10, "period": 7},
	"Rg": {"name": "Roentgenio", "number": 111, "category": "Metallo di transizione", "group": 11, "period": 7},
	"Cn": {"name": "Copernicio", "number": 112, "category": "Metallo di transizione", "group": 12, "period": 7},
	"Nh": {"name": "Nihonio", "number": 113, "category": "Metallo post-transizionale", "group": 13, "period": 7},
	"Fl": {"name": "Flerovio", "number": 114, "category": "Metallo post-transizionale", "group": 14, "period": 7},
	"Mc": {"name": "Moscovio", "number": 115, "category": "Metallo post-transizionale", "group": 15, "period": 7},
	"Lv": {"name": "Livermorio", "number": 116, "category": "Metallo post-transizionale", "group": 16, "period": 7},
	"Ts": {"name": "Tenessino", "number": 117, "category": "Alogen", "group": 17, "period": 7},
	"Og": {"name": "Oganesson", "number": 118, "category": "Gas nobile", "group": 18, "period": 7},

	# Lantanidi (periodo fittizio 9, gruppo 3-18)
	"La": {"name": "Lantanio", "number": 57, "category": "Lantanide", "group": 3, "period": 9},
	"Ce": {"name": "Cerio", "number": 58, "category": "Lantanide", "group": 4, "period": 9},
	"Pr": {"name": "Praseodimio", "number": 59, "category": "Lantanide", "group": 5, "period": 9},
	"Nd": {"name": "Neodimio", "number": 60, "category": "Lantanide", "group": 6, "period": 9},
	"Pm": {"name": "Promezio", "number": 61, "category": "Lantanide", "group": 7, "period": 9},
	"Sm": {"name": "Samario", "number": 62, "category": "Lantanide", "group": 8, "period": 9},
	"Eu": {"name": "Europio", "number": 63, "category": "Lantanide", "group": 9, "period": 9},
	"Gd": {"name": "Gadolinio", "number": 64, "category": "Lantanide", "group": 10, "period": 9},
	"Tb": {"name": "Terbio", "number": 65, "category": "Lantanide", "group": 11, "period": 9},
	"Dy": {"name": "Disprosio", "number": 66, "category": "Lantanide", "group": 12, "period": 9},
	"Ho": {"name": "Olmio", "number": 67, "category": "Lantanide", "group": 13, "period": 9},
	"Er": {"name": "Erbio", "number": 68, "category": "Lantanide", "group": 14, "period": 9},
	"Tm": {"name": "Tulio", "number": 69, "category": "Lantanide", "group": 15, "period": 9},
	"Yb": {"name": "Itterbio", "number": 70, "category": "Lantanide", "group": 16, "period": 9},
	"Lu": {"name": "Lutezio", "number": 71, "category": "Lantanide", "group": 17, "period": 9},

	# Attinidi (periodo fittizio 10, gruppo 3-18)
	"Ac": {"name": "Attinio", "number": 89, "category": "Attinide", "group": 3, "period": 10},
	"Th": {"name": "Torio", "number": 90, "category": "Attinide", "group": 4, "period": 10},
	"Pa": {"name": "Protoattinio", "number": 91, "category": "Attinide", "group": 5, "period": 10},
	"U":  {"name": "Uranio", "number": 92, "category": "Attinide", "group": 6, "period": 10},
	"Np": {"name": "Nettunio", "number": 93, "category": "Attinide", "group": 7, "period": 10},
	"Pu": {"name": "Plutonio", "number": 94, "category": "Attinide", "group": 8, "period": 10},
	"Am": {"name": "Americio", "number": 95, "category": "Attinide", "group": 9, "period": 10},
	"Cm": {"name": "Curio", "number": 96, "category": "Attinide", "group": 10, "period": 10},
	"Bk": {"name": "Berkelio", "number": 97, "category": "Attinide", "group": 11, "period": 10},
	"Cf": {"name": "Californio", "number": 98, "category": "Attinide", "group": 12, "period": 10},
	"Es": {"name": "Einsteinio", "number": 99, "category": "Attinide", "group": 13, "period": 10},
	"Fm": {"name": "Fermio", "number": 100, "category": "Attinide", "group": 14, "period": 10},
	"Md": {"name": "Mendelevio", "number": 101, "category": "Attinide", "group": 15, "period": 10},
	"No": {"name": "Nobelio", "number": 102, "category": "Attinide", "group": 16, "period": 10},
	"Lr": {"name": "Lawrencio", "number": 103, "category": "Attinide", "group": 17, "period": 10},

}
#Database colori degli elementi
var category_colors = {
	"Metallo alcalino": Color(1, 0.5, 0),       # Arancione
	"Metallo alcalino-terroso": Color(1, 1, 0), # Giallo
	"Metallo post-transizionale": Color(0.5, 0.5, 0.5), # Grigio
	"Metalloide": Color(0, 1, 0),        # Verde
	"Non metallo": Color(0, 1, 1),       # Azzurro
	"Alogeno": Color(1, 0, 1),           # Viola
	"Gas nobile": Color(0.6, 0, 1),      # Viola scuro
	"Metallo di transizione": Color(0.5, 0.5, 1), # Blu tenue
	"Lantanide": Color(0.8, 0.4, 1),     # Lilla
	"Attinide": Color(1, 0.2, 0.2)       # Rosso
}


func _ready():
	screen_size = get_viewport_rect().size
	create_periodic_table()
	popup_margin.visible = false 



func create_periodic_table():
	grid_container.columns = groups + 1  # +1 per la colonna dei periodi a sinistra

	# Prima riga: numeri dei gruppi (con uno spazio iniziale vuoto)
	grid_container.add_child(Control.new())  # Spazio vuoto per allineare i numeri dei gruppi
	for i in range(groups):
		var group_label = Label.new()
		group_label.text = str(i + 1)
		group_label.add_theme_font_size_override("font_size", 20)
		group_label.custom_minimum_size = Vector2(btn_size, btn_size)
		group_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid_container.add_child(group_label)
		group_label.add_theme_font_size_override("font_size", group_label.size.x * 0.5)
	# Inizializziamo la tabella solo con spazi vuoti
	var table_layout := []  
	for _i in range(periods):  # 7 periodi
		var row = []
		for _j in range(groups):
			row.append(null)
		table_layout.append(row)

	# Inseriamo gli elementi nelle loro posizioni
	for symbol in elements.keys():
		var element = elements[symbol]
		if "period" in element and "group" in element:
			var row = element["period"] - 1
			var col = element["group"] - 1

			table_layout[row][col] = symbol

	# Ora riempiamo la tabella
	for i in range(periods):
		# Prima colonna: numeri dei periodi
		var period_label = Label.new()
		if i < periods - 3:
			period_label.text = str(i + 1)
			period_label.custom_minimum_size = Vector2(btn_size, btn_size)
			period_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			period_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		grid_container.add_child(period_label)
		period_label.add_theme_font_size_override("font_size", period_label.size.y * 0.5)
		# Aggiungiamo gli elementi della riga
		for symbol in table_layout[i]:
			if symbol == null:
				# Spazio vuoto per mantenere la struttura della tavola
				var empty = Control.new()
				empty.custom_minimum_size = Vector2(btn_size, btn_size)
				grid_container.add_child(empty)
			else:
				# Crea il bottone per l'elemento
				var btn = Button.new()
				btn.text = symbol
				btn.custom_minimum_size = Vector2(btn_size, btn_size)
				btn.autowrap_mode = 2
				btn.pressed.connect(on_element_selected.bind(symbol, btn))
				btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
				grid_container.add_child(btn)
				btn.add_theme_font_size_override("font_size", btn.size.y * 0.7)  
				var element = elements[symbol]
				if "category" in element and element["category"] in category_colors:
					btn.modulate = category_colors[element["category"]]

func on_element_selected(symbol, button):
	var element = elements[symbol]
	# Imposta il testo
	popup_label.text = "Nome: %s\nNumero: %d\nCategoria: %s" % [
		element["name"], element["number"], element["category"]
	]
	# Carica l'immagine se disponibile
	if "image" in element:
		var img_texture = load(element["image"])
		popup_image.texture = img_texture
		
		# Imposta la dimensione dell'immagine (ad esempio 100x100)
		var img_size = Vector2(100, 100)
		popup_image.size = img_size 
		popup_image.custom_minimum_size = popup_image.size  # Imposta una dimensione minima per evitare che torni alla grandezza originale
		# Imposta la posizione in alto a destra
		var panel_size = popup_margin.size
		popup_image.position = Vector2(panel_size.x - img_size.x, 0)  # 10px di margine

	var button_global_pos = button.global_position  # Posizione globale del bottone
	var popup_pos = Vector2(button_global_pos.x + 100, (screen_size.y - popup_margin.size.y) / 2)
	popup_margin.set_position(popup_pos)
	# Mostra il popup
	popup_margin.visible = true  # Mostra il popup
	popup_margin.size = Vector2(btn_size, btn_size)  # Inizializza la scala più piccola
	popup_animation()  # Lancia l'animazione
	# Posiziona il label **dentro il pannello**

	if "scientist_name" in element:
		popup_label.text = element["scientist_name"]
		popup_date_label.text = element["year"]
		popup_label.position = popup_pos 
		popup_date_label.position = Vector2(0,popup_label.position.y + 20)
		popup_label.add_theme_font_size_override("font_size", 50)
		popup_date_label.add_theme_font_size_override("font_size", 20)

	
func popup_animation():
	var tween = get_tree().create_tween()
	screen_size = get_viewport_rect().size
	tween.tween_property(popup_margin, "size", Vector2(400, screen_size.y), 0.3)
	print(screen_size)
	#forza feb sei un mitico scemo de best in de uorld ma come fai a essere cosi bravo ad essere scemo lucA mi ha detto di chiederti se vuoi fare sesso con lui e oliver taigher ti va???? sexting chilling 
 	
