extends Control

@export var grid_container: GridContainer
@export var control_element_container: Control 
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
var btn_size: int = 55
var can_press: bool = true

#Database di tutti gli elementi
var elements: Dictionary = {
	# Periodo 1
	"H": {
		"name": "Idrogeno", 
		"number": 1, 
		"category": "Non metallo", 
		"group": 1, 
		"period": 1,
		"image": "res://Images/STEAM Women/Hodgin Dorothy.jpg",
		"scientist_name": "Hodgkin Dorothy",
		"profession": "Chimica",
		"brief_subtitle": "Pioniera cristallografa",
		"year": "1910 - 1994",
		"nationality": "Britannica",
		"description": "Scienziata britannica famosa per le sue ricerche sulla cristallografia a raggi X. Ha scoperto la struttura della vitamina B12, della penicillina (1° antibiotico) e dell'insulina. Per queste ricerche nel 1964 ha vinto il Premio Nobel per la Chimica. Il suo lavoro ha rivoluzionato la comprensione delle strutture molecolari e ha aperto la strada a importanti progressi in medicina.",
		"awards": "Premio Nobel per la Chimica (1964), Medaglia Copley (1976)",
		"quote": "Ci sono due momenti importanti. C'è il momento in cui sapete di poter trovare la risposta e il periodo in cui siete insonni prima di poter trovare qual è. Quando l'avete trovata e sapete qual è allora potete riposare tranquilli",
		"links": [
			"https://en.wikipedia.org/wiki/Dorothy_Hodgkin",
			"https://www.nobelprize.org/prizes/chemistry/1964/hodgkin/biographical/"
		]
	},
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
		"description": "Celebre per la sua carriera a Hollywood, considerata a lungo la donna più bella del mondo. Nessuno si rese conto che in realtà era un genio. Basandosi sull’accordatura del pianoforte, scoprì il salto di frequenza, che consentì di trasmettere segnali senza fili in modo sicuro. Questo principio divenne la base per Wi-Fi, Bluetooth e GPS. Il suo contributo scientifico venne riconosciuto solo in tarda età.",
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
		"profession": "Fisica",
		"brief_subtitle": "Madre della fissione nucleare",
		"year": "1878 - 1968",
		"nationality": "Austriaca",
		"description": "Fisica svedese di origine austriaca. Insieme a Otto Hahn, scoprì la fissione nucleare. A causa delle discriminazioni di genere e delle persecuzioni razziali non ricevette il premio Nobel come il suo compagno di laboratorio, ma le sue scoperte furono utilizzate per costruire la bomba atomica, attraverso il progetto Manhattan, a cui la scienziata si rifiutò di partecipare. Da quel momento in poi si dedicò all’uso pacifico dell’energia atomica. Scoprì il proattinio, elemento 91.",
		"awards": "Medaglia Max Planck (1949), Premio Enrico Fermi (1966)",
		"quote": "Penso che sia una bella scoperta, se non fosse per la guerra che piega anche la scienza alle sue atroci necessità.",
		"links": [
			"https://en.wikipedia.org/wiki/Lise_Meitner"
		]
	},
	"Be": {
		"name": "Berillio", 
		"number": 4, 
		"category": "Metallo alcalino-terroso", 
		"group": 2, 
		"period": 2,
		"image": "res://Images/Beatrice Shilling.jpg",
		"scientist_name": "Beatrice Shilling", 
		"profession": "Ingegnera aeronautica", 
		"brief_subtitle": "Pioniera dell'aeronautica", 
		"year": "1909 - 1990",
		"nationality": "Britannica",
		"description": "Pioniera dell'ingegneria aerospaziale britannica. Durante la WWII risolse un problema critico nei motori degli Spitfire inventando il celebre 'orifizio di Miss Shilling', un semplice dispositivo che impediva ai carburatori di bloccarsi durante le picchiate. Corridore motociclistico dilettante, sfidò gli stereotipi di genere in un settore totalmente maschile.",
		"awards": "Royal Aeronautical Society Silver Medal",
		"quote": "Se non puoi aggiustarlo, mettici le mani",
		"links": [
			"https://en.wikipedia.org/wiki/Beatrice_Shilling"
		]
	},
	"B": {
		"name": "Boro", 
		"number": 5, 
		"category": "Metalloide", 
		"group": 13, 
		"period": 2,
		"image": "res://Images/Alice_Augusta_Ball.jpg",
		"scientist_name": "Alice Augusta Ball", 
		"profession": "Chimica", 
		"brief_subtitle": "Sviluppò il trattamento per la lebbra", 
		"year": "1892 - 1916",
		"nationality": "Afroamericana",
		"description": "Una delle prime donne a laurearsi in chimica all’Università delle Hawaii. È famosa per aver sviluppato il 'metodo Ball', una tecnica che ha reso possibile l’uso dell’olio di chaulmoogra come trattamento per la lebbra, una malattia infettiva che colpiva molte persone all’epoca. Il suo contributo alla medicina è stato riconosciuto solo molti anni dopo la sua morte.",
		"awards": "Riconoscimento postumo dall'Università delle Hawaii",
		"quote": "Non importa quanto difficile sia il cammino, la scienza ha il potere di cambiare la vita e migliorare il destino dell'umanità.",
		"links": [
			"https://en.wikipedia.org/wiki/Alice_Augusta_Ball"
		]
	},
	"C": {
		"name": "Carbonio", 
		"number": 6, 
		"category": "Non metallo", 
		"group": 14, 
		"period": 2,
		"image": "res://Images/Cecilia_Payne-Gaposchkin.jpg",
		"scientist_name": "Cecilia Payne-Gaposchkin", 
		"profession": "Astrofisica", 
		"brief_subtitle": "Scoprì la composizione delle stelle", 
		"year": "1900 - 1979",
		"nationality": "Anglo-statunitense",
		"description": "Rivoluzionò l'astrofisica dimostrando nel 1925 che le stelle sono composte principalmente da idrogeno ed elio. Nonostante l'opposizione iniziale della comunità scientifica (all'epoca si credeva fossero simili alla Terra), la sua tesi divenne pietra miliare dell'astronomia. Prima donna a dirigere un dipartimento ad Harvard, aprì la strada alle scienziate nello studio del cosmo.",
		"awards": "Henry Norris Russell Lectureship (1976)",
		"quote": "L'unico uomo che non ha mai commesso un errore è quello che non ha mai fatto nulla.",
		"links": [
			"https://en.wikipedia.org/wiki/Cecilia_Payne-Gaposchkin"
		]
	},
	"N": {
		"name": "Azoto", 
		"number": 7, 
		"category": "Non metallo", 
		"group": 15, 
		"period": 2,
		"image": "res://Images/Francine_Ntoumi.jpg",
		"scientist_name": "Francine Ntoumi", 
		"profession": "Parassitologa", 
		"brief_subtitle": "Esperta nella lotta al paludismo", 
		"year": "1961 -",
		"nationality": "Congolese",
		"description": "Scienziata specializzata nella ricerca sul paludismo. È stata la prima donna africana a dirigere il segretariato dell'Iniziativa Multilaterale sul Paludismo. Ha contribuito alla creazione della rete CANTAM per la ricerca su tubercolosi, HIV/AIDS e paludismo, rafforzando la collaborazione scientifica in Africa centrale.",
		"awards": "Premio Christophe Mérieux (2016)",
		"quote": "Mio padre si è indebitato perché io potessi studiare.",
		"links": [
			"https://en.wikipedia.org/wiki/Francine_Ntoumi"
		]
	},
	"O": {
		"name": "Ossigeno",
		"number": 8,
		"category": "Non metallo",
		"group": 16,
		"period": 2,
		"image": "res://Images/STEAM Women/Olga Ladyzhenskaya.jpg",
		"scientist_name": "Olga Ladyzhenskaya",
		"profession": "Matematica",
		"brief_subtitle": "Esperta di equazioni differenziali",
		"year": "1922 - 2004",
		"nationality": "Russa",
		"description": "Matematica russa famosa per i suoi contributi all'analisi matematica, alle equazioni differenziali parziali e alla meccanica dei fluidi. I suoi studi sulle equazioni di Navier-Stokes hanno avuto un impatto enorme sulla fluidodinamica e sulla meteorologia.",
		"quote": "La matematica mi ha salvato.",
		"links": []
	},
	"F": {
		"name": "Fluoro",
		"number": 9,
		"category": "Non metallo",
		"group": 17,
		"period": 2,
		"image": "res://Images/STEAM Women/Françoise Barré-Sinoussi.jpg",
		"scientist_name": "Françoise Barré-Sinoussi",
		"profession": "Virologa",
		"brief_subtitle": "Scoprì il virus HIV",
		"year": "1947 -",
		"nationality": "Francese",
		"description": "Virologa francese nota per la scoperta del virus dell'HIV nel 1983. Il suo lavoro ha rivoluzionato la medicina e ha aperto la strada a test diagnostici e terapie efficaci.",
		"quote": "La scienza è una lotta costante contro l'ignoranza.",
		"links": []
	},
	"Ne": {
		"name": "Neon",
		"number": 10,
		"category": "Gas nobile",
		"group": 18,
		"period": 2,
		"image": "res://Images/STEAM Women/Nettie Stevens.jpg",
		"scientist_name": "Nettie Stevens",
		"profession": "Genetista",
		"brief_subtitle": "Scoprì il ruolo dei cromosomi sessuali",
		"year": "1861 - 1912",
		"nationality": "Statunitense",
		"description": "Genetista statunitense che nel 1905 scoprì che il sesso negli organismi è determinato dai cromosomi X e Y.",
		"quote": "La scienza è un viaggio verso la verità.",
		"links": []
	},


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
	"I": {
		"name": "Iodio", 
		"number": 53, 
		"category": "Alogeno", 
		"group": 17, 
		"period": 5,
		"image": "res://Images/STEAM Women/Ipazia.jpg",
		"scientist_name": "Ipazia",
		"profession": "Filosofa, Matematica e Astronoma",
		"brief_subtitle": "Luce del sapere antico",  # Alternativa: "Martire della scienza"
		"year": "360 ca. - 415 d.C.",
		"nationality": "Alessandrina (Egitto)",
		"description": "Figlia del matematico Teone di Alessandria, Ipazia fu pioniera nell'astronomia e nella filosofia neoplatonica. Progettò strumenti scientifici come l'astrolabio e il densimetro, fondamentali per misurare la posizione delle stelle e la densità dei liquidi. Simbolicamente, lo iodio (essenziale per la mente e la crescita) riflette il suo impegno per la conoscenza. Fu assassinata per le sue idee, diventando un'icona della libertà di pensiero e del femminismo scientifico.",
		"awards": "",  # Non applicabile, ma potresti usare "Icona eterna della scienza"
		"quote": "«Quando ti vedo mi prostro davanti a te e alle tue parole, vedendo la casa astrale della Vergine, infatti verso il cielo è rivolto ogni tuo atto Ipazia sacra, bellezza delle parole, astro incontaminato della sapiente cultura.»",
		"links": [
			"https://it.wikipedia.org/wiki/Ipazia",
			"https://www.britannica.com/biography/Hypatia"
	]
	},
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
	
	"Am": {
	"name": "Americio", 
	"number": 95, 
	"category": "Attinide", 
	"group": 9, 
	"period": 10,
	"image": "res://Images/STEAM Women/Amalie_Emmy_Noether.jpg",
	"scientist_name": "Amalie Emmy Noether", 
	"profession": "Matematica", 
	"brief_subtitle": "Pioniera dell'algebra astratta", 
	"year": "1882 - 1935", 
	"nationality": "Tedesca", 
	"description": 
		"Emmy Noether è stata una matematica tedesca nota per il suo contributo all'algebra astratta e alla fisica teorica. Il suo teorema ha rivoluzionato la comprensione delle simmetrie in fisica. Nonostante le difficoltà dovute alla discriminazione di genere, ha lasciato un'eredità fondamentale nella matematica e nella fisica.",
	"awards": "Premio Ackermann-Teubner (1932)",
	"quote": "La matematica non è solo un mezzo per risolvere problemi, ma un linguaggio attraverso cui possiamo comprendere la struttura profonda della realtà.",
	"links": [
		"https://en.wikipedia.org/wiki/Emmy_Noether",
		"https://mathshistory.st-andrews.ac.uk/Biographies/Noether/"
	]
	},

	"Cm": {
		"name": "Curio", 
		"number": 96, 
		"category": "Attinide", 
		"group": 10, 
		"period": 10,
		"image": "res://Images/STEAM Women/Maria Curie.jpg",
		"scientist_name": "Maria Curie", 
		"profession": "Fisica e Chimica", 
		"brief_subtitle": "Madre della radioattività", 
		"year": "1867 - 1934", 
		"nationality": "Polacca-Francese", 
		"description": 
			"Maria Skłodowska Curie è stata una scienziata rivoluzionaria, pioniera degli studi sulla radioattività. Prima persona a vincere due Premi Nobel in discipline scientifiche diverse, ha scoperto il radio e il polonio e ha contribuito allo sviluppo della medicina e della fisica nucleare.",
		"awards": "Premio Nobel per la Fisica (1903), Premio Nobel per la Chimica (1911)",
		"quote": "Niente nella vita è da temere, è solo da comprendere. Ora è il momento di comprendere di più, affinché possiamo temere di meno.",
		"links": [
			"https://en.wikipedia.org/wiki/Marie_Curie",
			"https://www.nobelprize.org/prizes/physics/1903/curie/biographical/"
		]
	},

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
	control_element_container.queue_free()
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
		group_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		group_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid_container.add_child(group_label)
		group_label.add_theme_font_size_override("font_size", 20)
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
				var element = elements[symbol]
				var btn = Button.new()
				var lbl = Label.new()
				var nm_lbl = Label.new()
				var element_container = Control.new()
				lbl.text = str(element["number"])
				lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
				lbl.vertical_alignment = VERTICAL_ALIGNMENT_TOP
				lbl.add_theme_font_size_override("font_size", 13)
				lbl.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
				lbl.z_index = 2
				nm_lbl.text = str(element["name"])
				nm_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				nm_lbl.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
				nm_lbl.add_theme_font_size_override("font_size", 9)
				nm_lbl.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
				nm_lbl.z_index = 3
				btn.text = symbol
				btn.custom_minimum_size = Vector2(btn_size, btn_size)
				btn.size = Vector2(btn_size, btn_size)
				btn.autowrap_mode = 2
				btn.pressed.connect(on_element_selected.bind(symbol, element_container))
				btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
				#btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
				btn.add_theme_font_size_override("font_size", 25)
				btn.pivot_offset = btn.size/2
				element_container.custom_minimum_size = Vector2(btn_size, btn_size)
				element_container.size = Vector2(btn_size, btn_size)
				element_container.scale = Vector2(0,0)
				element_container.add_child(lbl)
				element_container.add_child(nm_lbl)
				element_container.add_child(btn)
				element_container.pivot_offset = btn.size/2
				printerr(btn.size)
				var style = StyleBoxFlat.new()
				if style:
					style.corner_radius_bottom_left = 2
					style.corner_radius_bottom_right = 2
					style.corner_radius_top_left = 2
					style.corner_radius_top_right = 2
					btn.add_theme_stylebox_override("normal", style)
					style.bg_color = category_colors[element["category"]]  
					btn.add_theme_color_override("font_color", Color.GHOST_WHITE) # Applica lo stile al bottone
				var delay = (0.05)  
				await get_tree().create_timer(delay).timeout 
				grid_container.add_child(element_container)
				var stween = element_container.create_tween()
				stween.set_parallel(false)  # Fa sì che le animazioni vadano in sequenza
				stween.tween_property(element_container, "scale", Vector2(1.4, 1.4), 0.05)
				stween.tween_property(element_container, "scale", Vector2(1, 1), 0.05)
				
				btn.mouse_entered.connect(func():
					var tween = element_container.create_tween()
					tween.tween_property(element_container, "scale", Vector2(1.1, 1.1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT))
				btn.mouse_exited.connect(func():
					var tween = element_container.create_tween()
					tween.tween_property(element_container, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT))
				
func on_element_selected(symbol, button):
	if not can_press:
		return
	var element = elements[symbol]
	popup_name_label.text = "Nome: %s\nNumero: %d\nCategoria: %s" % [
		element["name"], element["number"], element["category"]
	]
	if "image" in element:
		var img_texture = load(element["image"])
		popup_image.texture = img_texture

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
	can_press = false
	calculate_popup_position(button)
	popup_animation(button) 
	await get_tree().create_timer(0.3).timeout
	can_press = true
	
	#forza feb sei un mitico scemo de best in de uorld ma come fai a essere cosi bravo ad essere scemo lucA mi ha detto di chiederti se vuoi fare sesso con lui e oliver taigher ti va???? sexting chilling 

func calculate_popup_position(button):
	var offset = 5
	
	popup_margin.reset_size()
	
	var popup_pos_x = button.global_position.x + button.size.x
	var popup_pos_y = button.global_position.y - button.size.y
	printerr(button.global_position.x)
	printerr(button.size.x)
	if popup_pos_x > screen_size.x / 2:
		popup_pos_x = popup_pos_x - button.size.x - popup_margin.size.x - offset
	else:
		popup_pos_x = popup_pos_x + offset

	if popup_pos_y > screen_size.y / 2 - button.size.y:
		popup_margin.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
		popup_pos_y = screen_size.y - popup_margin.size.y - offset
	else:
		popup_margin.set_anchors_preset(Control.PRESET_CENTER_TOP)
		popup_pos_y = offset
		
	var popup_pos = Vector2(popup_pos_x, popup_pos_y)

	popup_margin.global_position = popup_pos
	popup_panel.global_position = popup_pos

func popup_animation(button):
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1, 1), 0.01).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween.tween_property(button, "scale", Vector2(1.3, 1.3), 0.075).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", Vector2(1, 1), 0.05).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	popup_panel.size.y = (popup_margin.size.y)
	
	popup_margin.visible = true 
	popup_panel.visible = true 
