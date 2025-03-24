extends Control

@export var grid_container: GridContainer
@export var panel: Panel
@export var label: Label 
@export var popup_layer: CanvasLayer 
@export var popup_margin: MarginContainer 
@export var popup_panel: PanelContainer
@export var popup_name_label: Label
@export var popup_profession_label: Label
@export var popup_brief_label: Label
@export var popup_year_label: Label
@export var popup_nationality_label: Label
@export var popup_description_label: Label
@export var popup_awards_label: Label
@export var popup_quote_label: Label
@export var popup_links_label: Label
@export var popup_image: TextureRect
@onready var screen_size = get_viewport_rect().size
var periods: int = 7+3
var groups: int = 18
var btn_size: int = 50
var can_press: bool = true

#Database di tutti gli elementi
var elements: Dictionary = {
	# Periodo 1
	"H":  {
		"name": "Idrogeno", 
		"number": 1, 
		"category": "Non metallo", 
		"group": 1, 
		"period": 1,
		"image": "res://Images/STEAM Women/Hodgin Dorothy.jpg",
		"scientist_name": "Hodgkin Dorothy",
		"year": "1910 - 1994",
		"profession": "Chimica", 
		"description": "Scienziate britannica famosa per le sue ricerche sulla cristallografia a raggi X. Ha scoperto la struttura della vitamina B12, della penicellina (1° antibiotico) e dell’insulizna. Per queste ricerche nel 1964 ha vinto il Premio Nobel per la Chimica. ",
		"quote": "Ci sono due momenti importanti. C’è il momento in cui sapete di poter trovare la risposta e il periodo in cui siete insonni prima di poter trovare qual è. Quando l’avete trovata e sapere qual è allora potete riposare tranquilli"},

	"He": {
	"name": "Elio", 
	"number": 2, 
	"category": "Gas nobile", 
	"group": 18, 
	"period": 1,
	"image": "res://Images/STEAM Women/Hedy Lamarr.jpg",
	"scientist_name": "Hedy Lamarr", 
	"profession": "Attrice e Inventrice",
	"brief_subtitle": "Pioniera del wireless",
	"year": "1914 - 2000",
	"nationality": "Austriaca-Americana",
	"description": 
		"Celebre per la sua carriera a Hollywood, considerata a lungo la donna più bella del mondo. Nessuno si rese conto che in realtà era un genio. Basandosi sull’accordatura del pianoforte, scoprì il salto di frequenza, che consentì di trasmettere segnali senza fili in modo sicuro. Questo principio divenne la base per Wi-Fi, Bluetooth e GPS. Il suo contributo scientifico venne riconosciuto solo in tarda età.",
	"awards": "Premio della Electronic Frontier Foundation (EFF) nel 1997",
	"quote": "La speranza e la curiosità per il futuro sembrano migliori delle certezze. L’ignoto è sempre stato così attraente per me... e lo è ancora.",
	"links": [
		"https://en.wikipedia.org/wiki/Hedy_Lamarr",
		"https://www.women-inventors.com/Hedy-Lamarr.asp"
		]
	},

	"Li": {
		"name": "Litio", 
		"number": 3, 
		"category": "Metallo alcalino", 
		"group": 1, 
		"period": 2,
		"image": "res://Images/Lise Meitner.jpg",
		"scientist_name": "Lise Meitner", 
		"year": "1878 - 1968",
		"profession": "Fisica nucleare", 
		"description": "Co-scopritrice della fissione nucleare e del proattinio (elemento 91). Nonostante il fondamentale contributo alle scoperte atomiche, fu esclusa dal Premio Nobel per discriminazioni di genere e razziali (essendo ebrea). Rifiutò di partecipare al Progetto Manhattan, dedicandosi all'energia atomica pacifica. Il suo lavoro ispirò sia i reattori nucleari che le bombe atomiche, sebbene lei stessa condannasse l'uso bellico.",
		"quote": "Penso che sia una bella scoperta, se non fosse per la guerra che piega anche la scienza alle sue atroci necessità."
	},

	"Be": {
		"name": "Berillio", 
		"number": 4, 
		"category": "Metallo alcalino-terroso", 
		"group": 2, 
		"period": 2,
		"image": "res://Images/Beatrice Shilling.jpg",
		"scientist_name": "Beatrice Shilling", 
		"year": "1909 - 1990",
		"profession": "Ingegnera aeronautica", 
		"description": "Pioniera dell'ingegneria aerospaziale britannica. Durante la WWII risolse un problema critico nei motori degli Spitfire inventando il celebre 'orifizio di Miss Shilling', un semplice dispositivo che impediva ai carburatori di bloccarsi durante le picchiate. Corridore motociclistico dilettante, sfidò gli stereotipi di genere in un settore totalmente maschile.",
		"quote": "Se non puoi aggiustarlo, mettici le mani"
	},

	"B": {
		"name": "Boro", 
		"number": 5, 
		"category": "Metalloide", 
		"group": 13, 
		"period": 2,
		"image": "res://Images/Ildegarda di Bingen.jpg",
		"scientist_name": "Ildegarda di Bingen", 
		"year": "1098 - 1179",
		"profession": "Poliedrica medievale", 
		"description": "Genio rinascimentale ante litteram. Suora benedettina che rivoluzionò la medicina medievale con studi su erbe medicinali e anatomia femminile. Scrisse enciclopedie scientifiche come 'Physica', anticipando concetti moderni di ecologia. Compositrice di musica sacra e mistica visionaria, fu proclamata Dottore della Chiesa nel 2012.",
		"quote": "Guarda il cielo: Guarda il sole e le stelle. E adesso, rifletti. Quanto grande è il diletto che Dio dà all'umanità con tutte queste cose... Dobbiamo lavorare insieme a lei."
	},

	"C": {
		"name": "Carbonio", 
		"number": 6, 
		"category": "Non metallo", 
		"group": 14, 
		"period": 2,
		"image": "res://Images/Cecilia Payne-Gaposchkin.jpg",
		"scientist_name": "Cecilia Payne-Gaposchkin", 
		"year": "1900 - 1979",
		"profession": "Astrofisica pioniera", 
		"description": "Rivoluzionò l'astrofisica dimostrando nel 1925 che le stelle sono composte principalmente da idrogeno ed elio. Nonostante l'opposizione iniziale della comunità scientifica (all'epoca si credeva fossero simili alla Terra), la sua tesi divenne pietra miliare dell'astronomia. Prima donna a dirigere un dipartimento ad Harvard, aprì la strada alle scienziate nello studio del cosmo.",
		"quote": "L'unico uomo che non ha mai commesso un errore è quello che non ha mai fatto nulla."
	},

	"N": {
		"name": "Azoto", 
		"number": 7, 
		"category": "Non metallo", 
		"group": 15, 
		"period": 2,
		"image": "res://Images/Francine Ntoumi.jpg",
		"scientist_name": "Francine Ntoumi", 
		"year": "1961 - Presente",
		"profession": "Ricercatrice sul paludismo", 
		"description": "Leader nella lotta alle malattie tropicali. Fondatrice della rete CANTAM che coordina la ricerca su malaria, HIV e tubercolosi in Africa Centrale. Pioniera nell'approccio integrato tra ricerca scientifica e sviluppo sanitario locale. Simbolo dell'emancipazione scientifica africana, combatte per formare una nuova generazione di ricercatori nel continente.",
		"quote": "Mio padre si è indebitato perché io potessi studiare."
	},
	"O":  {"name": "Ossigeno", "number": 8, "category": "Non metallo", "group": 16, "period": 2},
	"F":  {"name": "Fluoro", "number": 9, "category": "Alogeno", "group": 17, "period": 2},
	"Ne": {"name": "Neon", "number": 10, "category": "Gas nobile", "group": 18, "period": 2},

	# Periodo 3
	"Na": {"name": "Sodio", "number": 11, "category": "Metallo alcalino", "group": 1, "period": 3},
	"Mg": {"name": "Magnesio", "number": 12, "category": "Metallo alcalino-terroso", "group": 2, "period": 3},
	"Al": {"name": "Alluminio", "number": 13, "category": "Metallo post-transizionale", "group": 13, "period": 3},
	"Si": {"name": "Silicio", "number": 14, "category": "Metalloide", "group": 14, "period": 3},
	"P":  {"name": "Fosforo", "number": 15, "category": "Non metallo", "group": 15, "period": 3},
	"S":  {"name": "Zolfo", "number": 16, "category": "Non metallo", "group": 16, "period": 3},
	"Cl": {"name": "Cloro", "number": 17, "category": "Alogeno", "group": 17, "period": 3},
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
	"Br": {"name": "Bromo", "number": 35, "category": "Alogeno", "group": 17, "period": 4},
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
	"I":  {"name": "Iodio", "number": 53, "category": "Alogeno", "group": 17, "period": 5},
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
	"At": {"name": "Astato", "number": 85, "category": "Alogeno", "group": 17, "period": 6},
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
	"Ts": {"name": "Tenessino", "number": 117, "category": "Alogeno", "group": 17, "period": 7},
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
	"Metallo alcalino": Color.CORAL,  
	"Metallo alcalino-terroso": Color.SADDLE_BROWN,
	"Metallo di transizione": Color.BROWN, 
	"Metallo post-transizionale": Color.DARK_SLATE_BLUE,  
	"Metalloide": Color.TEAL, 
	"Non metallo": Color.SEA_GREEN,  
	"Alogeno": Color.VIOLET,  
	"Gas nobile": Color.LIGHT_SKY_BLUE, 
	"Lantanide": Color.WEB_PURPLE, 
	"Attinide": Color.LIME_GREEN, 
}


func _ready():
	screen_size = get_viewport_rect().size
	create_periodic_table()
	popup_panel.visible = false 
	popup_margin.visible = false 


func create_periodic_table():
	grid_container.columns = groups + 1  # +1 per la colonna dei periodi a sinistra

	# Prima riga: numeri dei gruppi (con uno spazio iniziale vuoto)
	grid_container.add_child(Control.new())  # Spazio vuoto per allineare i numeri dei gruppi
	for i in range(groups):
		var group_label = Label.new()
		group_label.text = str(i + 1)
		group_label.custom_minimum_size = Vector2(btn_size, btn_size)
		group_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid_container.add_child(group_label)
		group_label.add_theme_font_size_override("font_size",20)
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
		period_label.add_theme_font_size_override("font_size",20)
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
				btn.add_theme_font_size_override("font_size", 25)

				var element = elements[symbol]
				var style = StyleBoxFlat.new()
				if style:
					btn.add_theme_stylebox_override("normal", style)
					style.bg_color = category_colors[element["category"]]  
					btn.add_theme_color_override("font_color", Color.GHOST_WHITE) # Applica lo stile al bottone

func on_element_selected(symbol, button):
	if not can_press:
		return
	var element = elements[symbol]
	# Imposta il testo
	popup_name_label.text = "Nome: %s\nNumero: %d\nCategoria: %s" % [
		element["name"], element["number"], element["category"]
	]
	# Carica l'immagine se disponibile
	if "image" in element:
		var img_texture = load(element["image"])
		popup_image.texture = img_texture

		# Imposta la dimensione dell'immagine (ad esempio 100x100)
		var img_size = Vector2(110, 110)
		#popup_image.size = img_size
	
	var button_global_pos = button.global_position 
	var offset_x = 5
	var popup_pos = Vector2(button_global_pos.x + button.size.x + offset_x, (screen_size.y - popup_margin.size.y) / 2)

	
	if popup_pos.x > screen_size.x / 2:
		popup_margin.set_position(Vector2(button_global_pos.x - popup_margin.size.x - offset_x, popup_pos.y))
		popup_panel.set_position(Vector2(button_global_pos.x - popup_panel.size.x - offset_x, popup_pos.y))
	else:
		popup_margin.set_position(popup_pos)
		popup_panel.set_position(popup_pos)
	# Mostra il popup
	if "links" in element:
		popup_name_label.text = element["scientist_name"]
		popup_profession_label.text =  element["profession"]
		popup_year_label.text = element["year"]
		popup_description_label.text = element["description"]
		popup_quote_label.text = element["quote"]
		popup_brief_label.text = element["brief_subtitle"]
		popup_nationality_label.text = element["nationality"]
		popup_awards_label.text =  element["awards"]
		popup_links_label.text = "\n".join(element["links"]) if "links" in element else ""
		#popup_name_label.position = Vector2(10,0)
		#popup_profession_label.position = Vector2(10,35)
		#popup_year_label.position = Vector2(10,60)
		#popup_description_label.position = Vector2(10,100)
		#popup_quote_label.position = Vector2(10,460)
		#popup_name_label.add_theme_font_size_override("font_size", 30)
		#popup_year_label.add_theme_font_size_override("font_size", 20)
	can_press = false
	popup_animation() 
	await get_tree().create_timer(0.3).timeout
	can_press = true

func popup_animation():
	var tween = get_tree().create_tween()
	screen_size = get_viewport_rect().size
	#popup_margin.size = Vector2(400, screen_size.y)
	popup_margin.visible = true 
	popup_panel.visible = true 
	#tween.tween_property(popup_margin, "size", Vector2(400+2, screen_size.y+2), 0.2)
	#tween.tween_property(popup_margin, "size", Vector2(400, screen_size.y), 0.1)
	#tween.tween_property(popup_panel, "scale", Vector2(1.05,0.95), 0.08)
	popup_panel.self_modulate = Color(1,1,1,0)
	
	tween.tween_property(popup_panel, "self_modulate", Color(1,1,1,1), 0.1)
	await get_tree().process_frames
	popup_panel.size = Vector2(420, popup_links_label.global_position.y + popup_links_label.size.y - popup_margin.global_position.y + 5)
	#tween.tween_property(popup_panel, "scale", Vector2(1, 1), 0.08)
	print(popup_panel.position)
	print(popup_panel.size)
	#forza feb sei un mitico scemo de best in de uorld ma come fai a essere cosi bravo ad essere scemo lucA mi ha detto di chiederti se vuoi fare sesso con lui e oliver taigher ti va???? sexting chilling 
 	
		#print(popup_image.position)

	
