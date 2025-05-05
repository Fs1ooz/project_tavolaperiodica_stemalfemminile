extends Control

@export var default_theme = "default"

@export var periodic_table_layer: CanvasLayer
@export var element_hovering_audio: AudioStreamPlayer2D
@export var category_hovering_audio: AudioStreamPlayer2D
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
@export var popup_awards_panel: PanelContainer 
@export var popup_quote_label: Label
@export var popup_links_label: Label
@export var popup_image: TextureRect
@export var title_label: RichTextLabel

@export var solid_bg: ColorRect
@export var moving_bg: Parallax2D

@onready var screen_size = get_viewport_rect().size
@onready var current_theme = themes[default_theme]

@onready var theme_names = themes.keys()
@onready var timer: Timer = $Timer

var radius: int = 2
var border: int = 2
var margin: float = 0.3

var scale_factor: float = 1.0
var default_font_color := Color.GHOST_WHITE
var selected_category_symbol := ""
var selected_button: Control = null
var periods: int = 7+3
var groups: int = 18
var btn_size: int = 60
var can_press: bool = true
var animation_finished: bool = false
var category_counter: int = 0
var piano_key = 0

var current_theme_index = 0

#Database di tutti gli elementi
@onready var elements: Dictionary = {
	## Periodo 1-2 Gruppo 4-11 Fittizio
	"Phy": {
		"name": "Fisica", 
		"category": "Category", 
		"group": 4, 
		"period": 2,
	},
	"Astro": {
		"name": "Astronomia", 
		"category": "Category", 
		"group": 5, 
		"period": 2,
	},
	"Chem": {
		"name": "Chimica", 
		"category": "Category", 
		"group": 6, 
		"period": 2,
	},
	"Bio": {
		"name": "Biologia", 
		"category": "Category", 
		"group": 7, 
		"period": 2,
	},
	"Mat": {
		"name": "Matematica", 
		"category": "Category", 
		"group": 8, 
		"period": 2,
	},
	"Eng": {
		"name": "Ingegneria", 
		"category": "Category", 
		"group": 9, 
		"period": 2,
	},
	"Med": {
		"name": "Medicina", 
		"category": "Category", 
		"group": 10, 
		"period": 2,
	},
	"Hum": {
		"name": "Umanistica", 
		"category": "Category", 
		"group": 11, 
		"period": 2,
	},
	
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
		],
		"profession_keys": ["Chem"],
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
		],
		"profession_keys": ["Eng", "Hum"]
	},
	"Li": {
		"name": "Litio", 
		"number": 3, 
		"category": "Metallo alcalino", 
		"group": 1, 
		"period": 2,
		"image": "res://Images/STEAM Women/Lise Meitner.jpg",
		"scientist_name": "Lise Meitner",
		"profession": "Fisica",
		"brief_subtitle": "Madre della fissione nucleare",
		"year": "1878 - 1968",
		"nationality": "Austriaca",
		"description": "Fisica svedese di origine austriaca. Insieme a Otto Hahn, scoprì la fissione nucleare. A causa delle discriminazioni di genere e delle persecuzioni razziali non ricevette il premio Nobel come il suo compagno di laboratorio, ma le sue scoperte furono utilizzate per costruire la bomba atomica, attraverso il progetto Manhattan, a cui la scienziata si rifiutò di partecipare. Da quel momento in poi si dedicò all’uso pacifico dell’energia atomica. Scoprì il proattinio, elemento 91.",
		"awards": "Medaglia Max Planck (1949), Premio Enrico Fermi (1966)",
		"quote": "Penso che sia una bella scoperta, se non fosse per la guerra che piega anche la scienza alle sue atroci necessità.",
		"links": ["https://en.wikipedia.org/wiki/Lise_Meitner"],
		"profession_keys": ["Phy"],
	},
	"Be": {
		"name": "Berillio", 
		"number": 4, 
		"category": "Metallo alcalino-terroso", 
		"group": 2, 
		"period": 2,
		"image": "res://Images/STEAM Women/Beatrice Shilling.jpg",
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
		],
		"profession_keys": ["Eng"],
	},
	"B": {
		"name": "Boro", 
		"number": 5, 
		"category": "Metalloide", 
		"group": 13, 
		"period": 2,
		"image": "res://Images/STEAM Women/Ball Alice Agusta.jpg",
		"scientist_name": "Ball Alice Augusta", 
		"profession": "Chimica", 
		"brief_subtitle": "Sviluppò il trattamento per la lebbra", 
		"year": "1892 - 1916",
		"nationality": "Afroamericana",
		"description": "Una delle prime donne a laurearsi in chimica all’Università delle Hawaii. È famosa per aver sviluppato il 'metodo Ball', una tecnica che ha reso possibile l’uso dell’olio di chaulmoogra come trattamento per la lebbra, una malattia infettiva che colpiva molte persone all’epoca. Il suo contributo alla medicina è stato riconosciuto solo molti anni dopo la sua morte.",
		"awards": "Riconoscimento postumo dall'Università delle Hawaii",
		"quote": "Non importa quanto difficile sia il cammino, la scienza ha il potere di cambiare la vita e migliorare il destino dell'umanità.",
		"links": [
			"https://en.wikipedia.org/wiki/Alice_Augusta_Ball"
		],
		"profession_keys":["Chem"],
	},
	"C": {
		"name": "Carbonio", 
		"number": 6, 
		"category": "Non metallo", 
		"group": 14, 
		"period": 2,
		"image": "res://Images/STEAM Women/Cecilia Payne-Gaposchkin.jpg",
		"scientist_name": "Cecilia Payne", 
		"profession": "Astrofisica", 
		"brief_subtitle": "Rivelatrice della natura stellare", 
		"year": "1900 - 1979",
		"nationality": "Anglo-statunitense",
		"description": "Rivoluzionò l'astrofisica dimostrando nel 1925 che le stelle sono composte principalmente da idrogeno ed elio. Nonostante l'opposizione iniziale della comunità scientifica (all'epoca si credeva fossero simili alla Terra), la sua tesi divenne pietra miliare dell'astronomia. Prima donna a dirigere un dipartimento ad Harvard, aprì la strada alle scienziate nello studio del cosmo.",
		"awards": "Henry Norris Russell Lectureship (1976)",
		"quote": "L'unico uomo che non ha mai commesso un errore è quello che non ha mai fatto nulla.",
		"links": [
			"https://en.wikipedia.org/wiki/Cecilia_Payne-Gaposchkin"
		],
		"profession_keys": ["Phy", "Astro"],
	},
	"N": {
		"name": "Azoto",
		"number": 7,
		"category": "Non metallo",
		"group": 15,
		"period": 2,
		"image": "res://Images/STEAM Women/Mary Anning.png",
		"scientist_name": "Mary Anning",
		"profession": "Paleontologa",
		"brief_subtitle": "Pioniera della paleontologia",
		"year": "1799–1847",
		"nationality": "Inglese",
		"description": "È stata una paleontologa e fossilista inglese autodidatta. Visse a Lyme Regis, sulla costa meridionale dell'Inghilterra, un'area ricca di fossili marini del Giurassico. Fin da giovane raccolse fossili, contribuendo con scoperte fondamentali come il primo scheletro completo di ittiosauro e importanti esemplari di plesiosauri e pterosauri. Nonostante il suo contributo alla scienza, fu inizialmente ignorata dalla comunità scientifica perché donna e di umili origini. Solo più tardi fu riconosciuta per il suo lavoro. Mary Anning è oggi considerata una pioniera della paleontologia.",
		"awards": "",
		"quote": "Il mondo mi ha trattata così duramente che temo mi abbia resa sospettosa verso tutti.",
		"links": [
			"https://en.wikipedia.org/wiki/Mary_Anning"
		],
		"profession_keys": ["Bio"],
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
		"awards": "Premio Lomonosov (2002), Membro dell'Accademia delle Scienze Russa",
		"quote": "La matematica mi ha salvato.",
		"links": [
			"https://en.wikipedia.org/wiki/Olga_Ladyzhenskaya",
			"https://mathshistory.st-andrews.ac.uk/Biographies/Ladyzhenskaya/"
		],
		"profession_keys": ["Mat"]
	},
	"F": {
		"name": "Fluoro",
		"number": 9,
		"category": "Alogeno",
		"group": 17,
		"period": 2,
		"image": "res://Images/STEAM Women/Françoise Barré-Sinoussi.jpg",
		"scientist_name": "Françoise Barré-Sinoussi",
		"profession": "Virologa",
		"brief_subtitle": "Scoprì il virus HIV",
		"year": "1947 -",
		"nationality": "Francese",
		"description": "Virologa francese nota per la scoperta del virus dell'HIV nel 1983. Ha lavorato presso l'Istituto Pasteur di Parigi, dove ha guidato il team che isolò per la prima volta il virus. La scoperta dell'HIV come agente causale dell'AIDS è stata rivoluzionaria nel campo della medicina e ha aperto la strada allo sviluppo di test diagnostici e terapie antiretrovirali efficaci. Questo ha trasformato l'AIDS da una malattia mortale a una condizione cronica gestibile. Il suo lavoro ha rivoluzionato la medicina e ha aperto la strada a test diagnostici e terapie efficaci.",
		"awards": "Premio Nobel per la Medicina (2008), Légion d'honneur (2013)",
		"quote": "La scienza è una lotta costante contro l'ignoranza.",
		"links": [
			"https://en.wikipedia.org/wiki/Françoise_Barré-Sinoussi",
			"https://www.nobelprize.org/prizes/medicine/2008/barre-sinoussi/facts/"
		],
		"profession_keys": ["Med", "Bio"],
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
		"brief_subtitle": "Madre della genetica moderna",
		"year": "1861 - 1912",
		"nationality": "Statunitense",
		"description": "Genetista statunitense che nel 1905 scoprì che il sesso negli organismi è determinato dai cromosomi X e Y. Studiando gli insetti, identificò che i maschi possedevano un cromosoma più piccolo (poi chiamato cromosoma Y), mentre le femmine avevano due cromosomi X. Questa scoperta fu fondamentale per comprendere il meccanismo genetico della determinazione sessuale. ",
		"quote": "La scienza è un viaggio verso la verità.",
		"awards": "",
		"links": [
			"https://en.wikipedia.org/wiki/Nettie_Stevens",
			"https://www.britannica.com/biography/Nettie-Stevens"
		],
		"profession_keys": ["Bio"],
	},

	# Periodo 3
	"Na": {
	  "name": "Sodio",
	  "number": 11,
	  "category": "Metallo alcalino",
	  "group": 1,
	  "period": 3,
	  "image": "res://Images/STEAM Women/Nancy Grace Roman.jpg",
	  "scientist_name": "Nancy Grace Roman",
	  "profession": "Astronoma",
	  "brief_subtitle": "Madre del telescopio spaziale Hubble",
	  "year": "1925–2018",
	  "nationality": "Statunitense",
	  "description": "Conosciuta come la 'Madre di Hubble' per il suo ruolo fondamentale nello sviluppo del telescopio spaziale Hubble. È stata una delle prime donne a ricoprire posizioni dirigenziali alla NASA, promuovendo la ricerca spaziale e l’astronomia. Nonostante le difficoltà incontrate come donna nella scienza, contribuì alla pianificazione di missioni pionieristiche per lo studio dello spazio profondo. Il suo lavoro ha influenzato generazioni di scienziati e ha aperto la strada a importanti scoperte cosmologiche.",
	  "awards": "",
	  "quote": "Lavorate sodo in qualcosa che vi appassiona e non lasciate che nessuno vi scoraggi.",
	  "links": [],
	"profession_keys": ["Astro"],
	},
	"Mg": {
	  "name": "Magnesio",
	  "number": 12,
	  "category": "Metallo alcalino-terroso",
	  "group": 2,
	  "period": 3,
	  "image": "",
	  "scientist_name": "Marguerite Perey",
	  "profession": "Chimica",
	  "brief_subtitle": "Scopritrice del francio",
	  "year": "1909–1975",
	  "nationality": "Francese",
	  "description": "Nota per aver scoperto il francio nel 1939. Lavorò come assistente di Marie Curie all'Istituto del Radio di Parigi, specializzandosi nello studio degli elementi radioattivi. La sua scoperta del francio, l'ultimo elemento naturale individuato, fu cruciale per la chimica nucleare. Fu la prima donna ammessa all'Académie des Sciences di Francia. Il suo lavoro contribuì allo sviluppo della fisica atomica, nonostante le conseguenze sulla sua salute dovute all'esposizione alle radiazioni.",
	  "awards": "",
	  "quote": "La scoperta del francio non è stata il risultato di un colpo di genio, ma di un paziente e meticoloso lavoro di ricerca.",
	  "links": [],
		"profession_keys": ["Chem"],
	},
	"Al": {
	  "name": "Alluminio",
	  "number": 13,
	  "category": "Metallo post-transizionale",
	  "group": 13,
	  "period": 3,
	  "image": "res://Images/STEAM Women/Ada Lovelace.jpg",
	  "scientist_name": "Ada Lovelace",
	  "profession": "Matematica e scrittrice",
	  "brief_subtitle": "Prima programmatrice",
	  "year": "1815–1852",
	  "nationality": "Britannica",
	  "description": "È considerata la prima programmatrice della storia. È nota per il suo lavoro sulla macchina analitica di Charles Babbage, un prototipo di computer meccanico. Lovelace non solo tradusse un articolo sull’argomento, ma aggiunse anche delle note in cui descrisse un algoritmo per calcolare i numeri di Bernoulli, considerato il primo programma informatico della storia. Nonostante il suo contributo pionieristico, Ada Lovelace non ricevette premi durante la sua vita, poiché il suo lavoro fu riconosciuto solo molti anni dopo la sua morte. Oggi, però, è celebrata come una figura fondamentale nella storia dell’informatica.",
	  "awards": "",
	  "quote": "Quel cervello mio è qualcosa di più che meramente mortale, come il tempo dimostrerà.",
	  "links": [],
		"profession_keys": ["Mat", "Eng"],
	},
	"Si": {
		"name": "Silicio",
		"number": 14,
		"category": "Metalloide",
		"group": 14,
		"period": 3,
		"image": "",
		"scientist_name": "Sibylla Maria Merian",
		"profession": "Naturalista e illustratrice",
		"brief_subtitle": "Pioniera dell'entomologia moderna",
		"year": "1647–1717",
		"nationality": "Tedesca",
		"description": "Famosa per i suoi studi sugli insetti e la loro metamorfosi. Ha viaggiato in Suriname, un’area tropicale, dove ha studiato la fauna e la flora locali, documentando il ciclo di vita degli insetti in modo straordinariamente preciso e dettagliato. Le sue illustrazioni, pubblicate in opere come *Metamorphosis insectorum Surinamensium* (1705), sono ancora oggi considerate capolavori di arte scientifica.",
		"awards": "",
		"quote": "La natura è un libro che ci insegna continuamente, se solo abbiamo occhi per guardare.",
		"links": [],
		"profession_keys": ["Med", "Bio"],
	},
	"P": {
	  "name": "Fosforo",
	  "number": 15,
	  "category": "Non metallo",
	  "group": 15,
	  "period": 3,
	  "image": "",
	  "scientist_name": "Pardis Sabeti",
	  "profession": "Biologa",
	  "brief_subtitle": "Esperta di malattia infettive",
	  "year": "1975-",
	  "nationality": "Iraniano-Americana",
	  "description": "Pardis Sabeti è una genetista e biologa computazionale iraniano-americana, nota per il suo lavoro sull'evoluzione dei patogeni e la risposta alle epidemie. Professoressa ad Harvard e membro del Broad Institute, ha sviluppato algoritmi per studiare la selezione naturale nel DNA umano. Durante l'epidemia di Ebola del 2014, il suo team ha sequenziato rapidamente il virus, contribuendo alla comprensione della sua diffusione. Oltre alla ricerca, è anche musicista e ha ricevuto numerosi riconoscimenti scientifici.",
	  "awards": "",
	  "quote": "Abbiamo la capacità di cambiare, adattarci ed essere resilienti. Ed è questo che fa la scienza: trovare soluzioni e andare avanti.",
	  "links": [],
	"profession_keys": ["Bio"],
	},
	"S": {
		"name": "Zolfo",
		"number": 16,
		"category": "Non metallo",
		"group": 16,
		"period": 3,
		"image": "",
		"scientist_name": "Henrietta Swan Leavitt",
		"profession": "Astronoma",
		"brief_subtitle": "Scoprì la relazione periodo-luminosità delle Cefeidi",
		"year": "1868-1921",
		"nationality": "Statunitense",
		"description": "Henrietta Swan Leavitt è stata un'astronoma statunitense. Ha lavorato presso l'Osservatorio di Harvard come \"computer umano\", analizzando le lastre fotografiche del cielo. La sua scoperta più importante riguarda la relazione tra il periodo e la luminosità delle variabili Cefeidi, che ha permesso di misurare le distanze cosmiche e rivoluzionato l'astronomia. Questa scoperta è stata fondamentale per Edwin Hubble nella dimostrazione dell’espansione dell’universo.",
		"awards": "",
		"quote": "A tutti coloro che studiano le stelle, spero che il mio lavoro possa essere utile.",
		"links": [],
		"profession_keys": ["Astro"],
		},
	"Cl": {
	  "name": "Cloro",
	  "number": 17,
	  "category": "Alogeno",
	  "group": 17,
	  "period": 3,
	  "image": "res://Images/STEAM Women/Claudia Alexander.png",
	  "scientist_name": "Claudia Alexander",
	  "profession": "Scienziata e ingegnera",
	  "brief_subtitle": "Manager della Missione Galileo",
	  "year": "1961–2015",
	  "nationality": "Americana",
	  "description": "Claudia Alexander è conosciuta per il suo lavoro nel campo dell’astrofisica e dell’esplorazione spaziale. È stata una delle scienziate di punta nella NASA, contribuendo in modo significativo a progetti di missioni spaziali, in particolare alla missione Galileo, che ha studiato Giove e le sue lune. Nel corso della sua carriera, Claudia Alexander ha lavorato instancabilmente per promuovere la scienza tra i giovani, in particolare le ragazze, cercando di abbattere le barriere di genere nelle scienze STEM.",
	  "awards": "",
	  "quote": "La scienza non ha confini, e se continuiamo a guardare in alto, possiamo scoprire sempre qualcosa di nuovo.",
	  "links": [],
	"profession_keys": ["Eng","Phy", "Astro"],
	},
	"Ar": {
	  "name": "Argon",
	  "number": 18,
	  "category": "Gas nobile",
	  "group": 18,
	  "period": 3,
	  "image": "res://Images/STEAM Women/Artemisia Gentileschi.png",
	  "scientist_name": "Artemisia Gentileschi",
	  "profession": "Artista",
	  "brief_subtitle": "Prima pittrice femminista",
	  "year": "1593-1653",
	  "nationality": "Italiana",
	  "description": "Artemisia Gentileschi è stata una pittrice italiana del periodo barocco, tra le prime donne a ottenere successo nel mondo dell'arte. Formata dal padre Orazio, sviluppò uno stile drammatico e realistico influenzato da Caravaggio. Le sue opere spesso raffigurano eroine bibliche e mitologiche con grande forza espressiva, come Giuditta che decapita Oloferne. Il suo lavoro è considerato un simbolo della resilienza femminile e del talento artistico.",
	  "awards": "",
	  "quote": "L’opera d’arte è il riflesso dell’anima di chi la crea.",
	  "links": [],
	"profession_keys": ["Hum"],
	},

	# Periodo 4
	"K": {
		"name": "Potassio",
		"number": 19,
		"category": "Metallo alcalino",
		"group": 1,
		"period": 4,
		"image": "res://Images/STEAM Women/Katherine Johnson.jpg",
		"scientist_name": "Katherine Johnson",
		"profession": "Matematica e scienziata",
		"brief_subtitle": "Pioniera della scienza spaziale",
		"year": "1918 - 2020",
		"nationality": "Statunitense",
		"description": "Matematica e scienziata statunitense fondamentale per il successo delle missioni NASA. Esperta nei calcoli di traiettorie, contribuì alle missioni Mercury, Apollo 11 e allo Space Shuttle. Il suo lavoro fu cruciale per il primo volo orbitale di John Glenn (1962). Superò discriminazioni razziali e di genere in un campo dominato dagli uomini. La sua storia ha ispirato il film *Il diritto di contare*.",
		"awards": "Medaglia Presidenziale della Libertà (2015)",
		"quote": "La matematica è la lingua con cui Dio ha scritto l’universo.",
		"links": [
			"<https://en.wikipedia.org/wiki/Katherine_Johnson>"
		],
		"profession_keys": ["Astro", "Mat"],
	},
	"Ca": {
		"name": "Calcio",
		"number": 20,
		"category": "Metallo alcalino-terroso",
		"group": 2,
		"period": 4,
		"image": "res://Images/STEAM Women/Caroline Herschel.jpg",
		"scientist_name": "Caroline Herschel",
		"profession": "Astronoma",
		"brief_subtitle": "Prima donna astronoma stipendiata",
		"year": "1750 - 1848",
		"nationality": "Tedesca-Britannica",
		"description": "Astronoma tedesca-britannica, famosa per i suoi contributi significativi all'astronomia. Scoprì 8 comete e catalogò 2.500 nuove stelle. Collaborò con il fratello William Herschel, contribuendo alla preparazione delle osservazioni per il suo telescopio riflettore, uno degli strumenti più avanzati dell'epoca.",
		"awards": "",
		"quote": "La passione per la scienza è la sola che possa essere veramente senza fine.",
		"links": [
			"<https://en.wikipedia.org/wiki/Caroline_Herschel>"
		],
		"profession_keys": ["Astro"]
	},
	"Sc": {
		"name": "Scandio",
		"number": 21,
		"category": "Metallo di transizione",
		"group": 3,
		"period": 4,
		"image": "res://Images/STEAM Women/Caterina Scarpelli.jpg",
		"scientist_name": "Caterina Scarpelli",
		"profession": "Astronoma e meteorologa",
		"brief_subtitle": "Pioniera della meteorologia italiana",
		"year": "1808 - 1873",
		"nationality": "Italiana",
		"description": "Astronoma e meteorologa italiana. Collaborò con l'Osservatorio del Collegio Romano e scoprì una cometa nel 1854. Pioniera nella divulgazione scientifica e nelle osservazioni meteorologiche, contribuì alla nascita della meteorologia moderna in Italia. Ottenne una medaglia d'oro da Pio IX.",
		"awards": "Medaglia d'oro da Pio IX",
		"quote": "Dedicare la vita all’osservazione del cielo è comprendere i segreti dell’universo.",
		"links": ["<https://it.wikipedia.org/wiki/Caterina_Scarpelli>"],
		"profession_keys": ["Astro"]
	},
	"Ti": {
		"name": "Titanio",
		"number": 22,
		"category": "Metallo di transizione",
		"group": 4,
		"period": 4,
		"image": "res://Images/STEAM Women/Tina M. Henkin.jpg",
		"scientist_name": "Tina M. Henkin",
		"profession": "Microbiologa",
		"brief_subtitle": "Esperta in regolazione genica batterica",
		"year": "1956 - ",
		"nationality": "Statunitense",
		"description": "Microbiologa statunitense specializzata nella regolazione dell'espressione genica nei batteri. Ha scoperto nuovi meccanismi di regolazione tramite RNA (come i riboswitches), aprendo la strada a nuovi trattamenti antibiotici per infezioni batteriche.",
		"awards": "",
		"quote": "La scienza è come un codice da decifrare: ogni scoperta apre una nuova porta alla comprensione della vita.",
		"links": [
			"<https://en.wikipedia.org/wiki/Tina_M._Henkin>"
		],
		"profession_keys": ["Bio"]
	},
	"V": {
		"name": "Vanadio",
		"number": 23,
		"category": "Metallo di transizione",
		"group": 5,
		"period": 4,
		"image": "res://Images/STEAM Women/Virginia Apgar.jpg",
		"scientist_name": "Virginia Apgar",
		"profession": "Dottoressa e anestesiologa",
		"brief_subtitle": "Pioniera della medicina neonatale",
		"year": "1909 - 1974",
		"nationality": "Statunitense",
		"description": "Medica statunitense che rivoluzionò la neonatologia con il punteggio Apgar (1952), sistema standardizzato per valutare la salute dei neonati. Studiò gli effetti dell’anestesia su madri e bambini, migliorando la sicurezza del parto. Negli ultimi anni si dedicò alla prevenzione delle malformazioni congenite.",
		"awards": "",
		"quote": "Un buon medico è colui che non solo cura, ma anche comprende, educa e dà speranza.",
		"links": ["<https://en.wikipedia.org/wiki/Virginia_Apgar>"],
		"profession_keys": ["Med"],
	},
	"Cr": {
		"name": "Cromo",
		"number": 24,
		"category": "Metallo di transizione",
		"group": 6,
		"period": 4,
		"image": "res://Images/STEAM Women/Cristina Alberini.jpg",
		"scientist_name": "Cristina Alberini",
		"profession": "Neuroscienziata",
		"brief_subtitle": "Esperta nei meccanismi della memoria",
		"year": "",
		"nationality": "Italiana",
		"description": "Neuroscienziata italiana specializzata nello studio della memoria. Professoressa alla Mount Sinai School of Medicine di New York, indaga i processi molecolari alla base dell’apprendimento e della codifica delle esperienze emotive nel cervello.",
		"awards": "",
		"quote": "La memoria non è un contenitore di informazioni, ma un processo dinamico che cambia nel tempo.",
		"links": ["<https://en.wikipedia.org/wiki/Cristina_Alberini>"],
		"profession_keys": ["Med"],
	},
	"Mn": {
		"name": "Manganese",
		"number": 25,
		"category": "Metallo di transizione",
		"group": 7,
		"period": 4,
		"image": "res://Images/STEAM Women/Maria Montessori.png",
		"scientist_name": "Maria Montessori",
		"profession": "Educatrice e Medica",
		"brief_subtitle": "Educatrice rivoluzionaria",
		"year": "1870 - 1952",
		"nationality": "Italiana",
		"description": "Medica e pedagogista italiana, prima donna a laurearsi in medicina in Italia. Sviluppò il metodo Montessori, basato su indipendenza e sviluppo naturale del bambino, adottato globalmente.",
		"awards": "",
		"quote": "Aiutami a fare da solo.",
		"links": ["<https://en.wikipedia.org/wiki/Maria_Montessori>"],
		"profession_keys": ["Med", "Hum"],
	},
	"Fe": {
		"name": "Ferro",
		"number": 26,
		"category": "Metallo di transizione",
		"group": 8,
		"period": 4,
		"image": "res://Images/STEAM Women/Felisa Wolfe-Simon.jpg",
		"scientist_name": "Felisa Wolfe-Simon",
		"profession": "Microbiologa",
		"brief_subtitle": "Esploratrice della chimica della vita",
		"year": "",
		"nationality": "Statunitense",
		"description": "Microbiologa nota per la scoperta (2010) di batteri che sostituiscono il fosforo con l’arsenico. La sua ricerca suggerisce possibilità di vita in ambienti estremi con biochimiche alternative.",
		"awards": "",
		"quote": "",
		"links": ["<https://en.wikipedia.org/wiki/Felisa_Wolfe-Simon>"],
		"profession_keys": ["Bio"],
	},
	"Co": {
		"name": "Cobalto",
		"number": 27,
		"category": "Metallo di transizione",
		"group": 9,
		"period": 4,
		"image": "res://Images/STEAM Women/Odile Speed.jpg",
		"scientist_name": "Odile Speed",
		"profession": "Artista",
		"brief_subtitle": "Ritrattista della doppia elica",
		"year": "1920 - 2007",
		"nationality": "Britannica",
		"description": "Artista britannica che realizzò i disegni della struttura del DNA per l’articolo di Crick e Watson su Nature (1953). Contribuì a rendere iconica la doppia elica nel panorama scientifico.",
		"awards": "",
		"quote": "L'arte e la scienza si intrecciano come i filamenti del DNA, rivelando la bellezza intrinseca della vita.",
		"links": ["<https://en.wikipedia.org/wiki/Odile_Crick>"],
		"profession_keys": ["Hum"],
	},
	"Ni": {
		"name": "Nichel",
		"number": 28,
		"category": "Metallo di transizione",
		"group": 10,
		"period": 4,
		"image": "res://Images/STEAM Women/Florence Nightingale.jpg",
		"scientist_name": "Florence Nightingale",
		"profession": "Infermiera",
		"brief_subtitle": "Fondatrice dell'infermieristica moderna",
		"year": "1820 - 1910",
		"nationality": "Britannica",
		"description": "Infermiera inglese che rivoluzionò l’assistenza sanitaria durante la guerra di Crimea. Introdusse l’uso della statistica per dimostrare l’efficacia dell’igiene nella riduzione della mortalità.",
		"awards": "",
		"quote": "La professione infermieristica è l’arte di servire e aiutare l’umanità, ed è più di un semplice compito, è una vocazione.",
		"links": ["<https://en.wikipedia.org/wiki/Florence_Nightingale>"],
		"profession_keys": ["Med"],
	},
	"Cu": {
		"name": "Rame",
		"number": 29,
		"category": "Metallo di transizione",
		"group": 11,
		"period": 4,
		"image": "res://Images/STEAM Women/Colette Guillaum.jpg",
		"scientist_name": "Colette Guillaumin",
		"profession": "Sociologa",
		"brief_subtitle": "Teorica delle disuguaglianze sociali",
		"year": "1934 - 2017",
		"nationality": "Francese",
		"description": "Sociologa francese pioniera negli studi su genere e razza. Analizzò i meccanismi strutturali delle disuguaglianze, contribuendo alla sociologia critica del lavoro e dei ruoli sociali.",
		"awards": "",
		"quote": "Le disuguaglianze non sono il frutto di differenze naturali, ma di una costruzione sociale.",
		"links": ["<https://en.wikipedia.org/wiki/Colette_Guillaumin>"],
		"profession_keys": ["Hum"],
	},
	"Zn": {
		"name": "Zinco",
		"number": 30,
		"category": "Metallo di transizione",
		"group": 12,
		"period": 4,
		"image": "res://Images/STEAM Women/Zhenan Bao.jpg",
		"scientist_name": "Zhenan Bao",
		"profession": "Scienziata e ingegnera",
		"brief_subtitle": "Pioniera della pelle elettronica",
		"year": "1970 - ",
		"nationality": "Cinese",
		"description": "Ingegnera chimica cinese, professoressa a Stanford. Sviluppa materiali elettronici flessibili che imitano la pelle umana, con applicazioni in sensori e tecnologie mediche.",
		"awards": "",
		"quote": "L’innovazione è la capacità di vedere le opportunità nei problemi e di trasformarli in soluzioni che possano migliorare la vita quotidiana.",
		"links": ["<https://en.wikipedia.org/wiki/Zhenan_Bao>"],
		"profession_keys": ["Eng"],
	},
	"Ga": {
		"name": "Gallio",
		"number": 31,
		"category": "Metallo post-transizionale",
		"group": 13,
		"period": 4,
		"image": "res://Images/STEAM Women/Jane Goodall.jpg",
		"scientist_name": "Jane Goodall",
		"profession": "Etologa e antropologa",
		"brief_subtitle": "Voce degli scimpanzé",
		"year": "1934 - ",
		"nationality": "Britannica",
		"description": "Etologa britannica rivoluzionaria, Jane Goodall trascorse anni tra gli scimpanzé in Tanzania, documentando comportamenti complessi come l’uso di strumenti e la caccia organizzata. Le sue scoperte hanno ridefinito il confine tra umani e animali e ispirato un attivismo globale per la conservazione e i diritti degli esseri viventi.",
		"awards": "",
		"quote": "Ciò che fai fa la differenza, e devi decidere che tipo di differenza vuoi fare.",
		"links": ["<https://en.wikipedia.org/wiki/Jane_Goodall>"],
		"profession_keys": ["Bio","Hum"],
	},
	"Ge": {
		"name": "Germanio",
		"number": 32,
		"category": "Metalloide",
		"group": 14,
		"period": 4,
		"image": "res://Images/STEAM Women/Gerty Cori.jpg",
		"scientist_name": "Gerty Cori",
		"profession": "Biochimica",
		"brief_subtitle": "Decifratrice del metabolismo umano",
		"year": "1896 - 1957",
		"nationality": "Ceco-americana",
		"description": "Prima donna a vincere il Nobel per la medicina (1947), Gerty Cori scoprì insieme al marito Carl il ciclo che porta il loro nome, fondamentale per comprendere come il corpo converte e immagazzina l’energia. La sua ricerca aprì nuove strade nello studio delle malattie metaboliche, rompendo al contempo barriere di genere nella scienza.",
		"awards": "Premio Nobel per la Fisiologia o Medicina (1947)",
		"quote": "I momenti indimenticabili sono le pietre miliari della conoscenza.",
		"links": ["<https://en.wikipedia.org/wiki/Gerty_Cori>"],
		"profession_keys": ["Chem", "Bio"],
	},
	"As": {
		"name": "Arsenico",
		"number": 33,
		"category": "Metalloide",
		"group": 15,
		"period": 4,
		"image": "res://Images/STEAM Women/Asima Chatterjee.jpg",
		"scientist_name": "Asima Chatterjee",
		"profession": "Chimica",
		"brief_subtitle": "Pioniera della chemioterapia naturale",
		"year": "1917 - 2006",
		"nationality": "Indiana",
		"description": "Chimica indiana pioniera: studiò alcaloidi della vinca per sviluppare farmaci contro cancro ed epilessia. Prima donna indiana a ottenere un dottorato in scienze.",
		"awards": "",
		"quote": "Desidero dedicare la mia vita, per quanto possibile, alla causa dell'umanità sofferente.",
		"links": ["<https://en.wikipedia.org/wiki/Asima_Chatterjee>"],
		"profession_keys": ["Chem"],
	},
	"Se": {
		"name": "Selenio",
		"number": 34,
		"category": "Non metallo",
		"group": 16,
		"period": 4,
		"image": "res://Images/STEAM Women/Florence Seibert.jpg",
		"scientist_name": "Florence Seibert",
		"profession": "Biochimica",
		"brief_subtitle": "Combattente contro la tubercolosi",
		"year": "1897 - 1991",
		"nationality": "Statunitense",
		"description": "Biochimica statunitense che sviluppò il test PPD per diagnosticare la tubercolosi. Migliorò la sterilizzazione delle soluzioni endovenose, rendendo le trasfusioni più sicure.",
		"awards": "National Women’s Hall of Fame (1990)",
		"quote": "Sono sempre stata felice in laboratorio e mi sono sentita più a casa lì.",
		"links": ["<https://en.wikipedia.org/wiki/Florence_Seibert>"],
		"profession_keys": ["Chem", "Bio"],
	},
	"Br": {
		"name": "Bromo",
		"number": 35,
		"category": "Alogeno",
		"group": 17,
		"period": 4,
		"image": "res://Images/STEAM Women/Jocelyn Bell Burnell.png",
		"scientist_name": "Jocelyn Bell Burnell",
		"profession": "Astrofisica",
		"brief_subtitle": "Scopritrice delle prime pulsar",
		"year": "1943-",
		"nationality": "Britannica",
		"description": "È celebre per aver scoperto le prime pulsar nel 1967, quando era ancora una studentessa di dottorato. La scoperta fu fondamentale per l’astrofisica e portò al premio Nobel del 1974, ma fu assegnato solo al suo supervisore, non a lei. La sua esclusione suscitò ampie critiche. Nonostante ciò, Bell Burnell ha avuto una carriera brillante ed è diventata un simbolo per le donne nella scienza. Ha ricevuto numerosi riconoscimenti e ha donato un importante premio in denaro per finanziare borse di studio per studenti sottorappresentati nella fisica.",
		"awards": "",
		"quote": "La scienza non è un gioco da maschi, non è un gioco da femmine. È il gioco di tutti.",
		"links": [
			"https://en.wikipedia.org/wiki/Jocelyn_Bell_Burnell"
		],
		"profession_keys": ["Astro", "Phy"],
	},
	"Kr": {
		"name": "Kripton",
		"number": 36,
		"category": "Gas nobile",
		"group": 18,
		"period": 4,
		"image": "res://Images/STEAM Women/Kristina M. Johnson.jpg",
		"scientist_name": "Kristina M. Johnson",
		"profession": "Ingegnera",
		"brief_subtitle": "Innovatrice in ottica ed energia",
		"year": "1957 - ",
		"nationality": "Statunitense",
		"description": "Ingegnera statunitense specializzata in fotonica ed energie rinnovabili. Ex rettore della Ohio State University e Segretaria dell’Energia USA. Co-fondatrice di aziende green-tech.",
		"awards": "",
		"quote": "L’innovazione consiste nel vedere il mondo in modo diverso e fare la differenza.",
		"links": ["<https://en.wikipedia.org/wiki/Kristina_M._Johnson>"],
		"profession_keys": ["Eng"],
	},

	# Periodo 5
	"Rb": {
		"name": "Rubidio",
		"number": 37,
		"category": "Metallo alcalino",
		"group": 1,
		"period": 5,
		"image": "res://Images/STEAM Women/Ruby Payne-Scott.jpg",
		"scientist_name": "Ruby Payne-Scott",
		"profession": "Fisica",
		"brief_subtitle": "Pioniera della radioastronomia solare",
		"year": "1912 - 1981",
		"nationality": "Australiana",
		"description": "Fisica e radioastronoma australiana, tra le prime a utilizzare le onde radio per studiare il Sole. Contribuì alla scoperta delle tempeste solari radio e sviluppò tecniche fondamentali per l'interferometria radioastronomica. La sua carriera fu interrotta a causa delle restrizioni contro le donne sposate nel servizio pubblico, ma il suo lavoro gettò le basi per la moderna radioastronomia.",
		"awards": "",
		"quote": "La scoperta scientifica è un viaggio, non una destinazione.",
		"links": ["<https://en.wikipedia.org/wiki/Ruby_Payne-Scott>"],
		"profession_keys": ["Phy"],
	},

	"Sr": {
		"name": "Stronzio",
		"number": 38,
		"category": "Metallo alcalino-terroso",
		"group": 2,
		"period": 5,
		"image": "res://Images/STEAM Women/Sophie Taeuber-Arp.jpg",
		"scientist_name": "Sophie Taeuber-Arp",
		"profession": "Pittrice e designer",
		"brief_subtitle": "Icona del movimento Dada",
		"year": "1889 - 1943",
		"nationality": "Svizzera",
		"description": "Artista poliedrica svizzera, figura centrale del movimento Dada. Sperimentò l'arte astratta attraverso pittura, scultura, tessuti e design, con un approccio geometrico innovativo. Il suo lavoro influenzò profondamente l'evoluzione dell'arte astratta del XX secolo, sfidando le convenzioni artistiche dell'epoca.",
		"awards": "",
		"quote": "L'arte non è qualcosa che fai, è qualcosa che vivi.",
		"links": ["<https://en.wikipedia.org/wiki/Sophie_Taeuber-Arp>"],
		"profession_keys": ["Hum"],
	},

	"Y": {
		"name": "Ittrio",
		"number": 39,
		"category": "Metallo di transizione",
		"group": 3,
		"period": 5,
		"image": "res://Images/STEAM Women/Yonath Ada.jpg",
		"scientist_name": "Ada Yonath",
		"profession": "Chimica e cristallografa",
		"brief_subtitle": "Decifratrice dei ribosomi",
		"year": "1939 - ",
		"nationality": "Israeliana",
		"description": "Cristallografa israeliana premio Nobel per la Chimica nel 2009 per aver svelato la struttura dei ribosomi mediante cristallografia a raggi X. Le sue scoperte hanno rivoluzionato la comprensione della sintesi proteica e sono alla base dello sviluppo di nuovi antibiotici. Prima donna israeliana a vincere un Nobel scientifico.",
		"awards": "Premio Nobel per la Chimica (2009)",
		"quote": "Non ho mai pensato al genere o alla fama, amo semplicemente la scienza.",
		"links": ["<https://en.wikipedia.org/wiki/Ada_Yonath>"],
		"profession_keys": ["Chem"],
	},

	"Zr": {
		"name": "Zirconio",
		"number": 40,
		"category": "Metallo di transizione",
		"group": 4,
		"period": 5,
		"image": "res://Images/STEAM Women/Maria Zuber.jpg",
		"scientist_name": "Maria Zuber",
		"profession": "Scienziata planetaria",
		"brief_subtitle": "Esploratrice di Marte",
		"year": "1959 - ",
		"nationality": "Statunitense",
		"description": "Scienziata planetaria statunitense, prima donna a dirigere il dipartimento di scienze planetarie al MIT. Ha mappato la topografia e la struttura interna di Marte attraverso missioni come il Mars Global Surveyor. Il suo lavoro è fondamentale per la comprensione dell'evoluzione geologica del sistema solare.",
		"awards": "",
		"quote": "La scienza non riguarda il dimostrare di avere ragione, ma nel fare le domande giuste.",
		"links": ["<https://en.wikipedia.org/wiki/Maria_T._Zuber>"],
		"profession_keys": ["Astro", "Phy"]
	},
	"Nb": {
		"name": "Niobio",
		"number": 41,
		"category": "Metallo di transizione",
		"group": 5,
		"period": 5,
		"image": "res://Images/STEAM Women/Nina Byers.png",
		"scientist_name": "Nina Byers",
		"profession": "Fisica teorica",
		"brief_subtitle": "Pioniera delle simmetrie nella fisica fondamentale",
		"year": "1930 - 2014",
		"nationality": "Americana",
		"description": "Fisica teorica americana che ha contribuito allo studio delle interazioni elettrodeboli e della fisica delle particelle. Il suo lavoro sulle simmetrie ha influenzato la comprensione della fisica fondamentale. Attivista per la documentazione storica del ruolo delle donne nella scienza, ha dedicato parte della sua carriera a valorizzare il loro contributo spesso dimenticato.",
		"awards": "",
		"quote": "Molte donne hanno contribuito in modo sostanziale alla scienza, anche se la loro storia è stata spesso trascurata.",
		"links": ["<https://en.wikipedia.org/wiki/Nina_Byers>"],
		"profession_keys": ["Phy", "Hum"],
	},

	"Mo": {
		"name": "Molibdeno",
		"number": 42,
		"category": "Metallo di transizione",
		"group": 6,
		"period": 5,
		"image": "res://Images/STEAM Women/Rita Levi-Montalcini.png",
		"scientist_name": "Rita Levi-Montalcini",
		"profession": "Neurologa",
		"brief_subtitle": "Scopritrice del fattore di crescita nervoso (NGF)",
		"year": "1909 - 2012",
		"nationality": "Italiana",
		"description": "Neuroscienziata italiana Premio Nobel per la Medicina nel 1986 per la scoperta del NGF, proteina cruciale per lo sviluppo e la sopravvivenza dei neuroni. La sua ricerca ha aperto nuove strade nello studio delle malattie neurodegenerative. Senatrice a vita, ha lottato per i diritti delle donne nella scienza e per la libertà accademica durante il fascismo.",
		"awards": "Premio Nobel per la Medicina (1986)",
		"quote": "Meglio aggiungere vita ai giorni, che non giorni alla vita.",
		"links": ["<https://en.wikipedia.org/wiki/Rita_Levi-Montalcini>"],
		"profession_keys": ["Med"],
	},

	"Tc": {
		"name": "Tecnezio",
		"number": 43,
		"category": "Metallo di transizione",
		"group": 7,
		"period": 5,
		"image": "res://Images/STEAM Women/Tatyana Chernigovskaya.png",
		"scientist_name": "Tatyana Chernigovskaya",
		"profession": "Neuroscienziata e linguista",
		"brief_subtitle": "Esploratrice del cervello e del linguaggio",
		"year": "1950 - ",
		"nationality": "Russa",
		"description": "Neuroscienziata e linguista russa specializzata nello studio della neurobiologia della coscienza e dell’elaborazione del linguaggio nel cervello. Il suo lavoro interdisciplinare unisce neuroscienze cognitive, intelligenza artificiale e filosofia della mente, esplorando come il cervello genera pensiero, creatività e percezione del mondo.",
		"awards": "",
		"quote": "Non siamo noi a pensare con il cervello, è il cervello che pensa con noi.",
		"links": ["<https://en.wikipedia.org/wiki/Tatiana_Chernigovskaya>"],
		"profession_keys": ["Med","Hum"],
	},

	"Ru": {
		"name": "Rutenio",
		"number": 44,
		"category": "Metallo di transizione",
		"group": 8,
		"period": 5,
		"image": "res://Images/STEAM Women/Vera Rubin.png",
		"scientist_name": "Vera Rubin",
		"profession": "Astronoma",
		"brief_subtitle": "Rivelatrice della materia oscura",
		"year": "1928 - 2016",
		"nationality": "Americana",
		"description": "Astronoma americana che ha rivoluzionato l’astrofisica dimostrando l’esistenza della materia oscura attraverso lo studio delle curve di rotazione delle galassie. Le sue osservazioni hanno rivelato che la maggior parte della massa dell’universo è invisibile, ridefinendo i modelli cosmologici. Icona femminile in un campo dominato dagli uomini, ha aperto la strada alle scienziate del XX secolo.",
		"awards": "",
		"quote": "La scienza non ha genere. C’è solo la scienza che deve essere fatta, e ci sono persone che la fanno.",
		"links": ["<https://en.wikipedia.org/wiki/Vera_Rubin>"],
		"profession_keys": ["Astro"],
	},

	"Rh": {
		"name": "Rodio",
		"number": 45,
		"category": "Metallo di transizione",
		"group": 9,
		"period": 5,
		"image": "res://Images/STEAM Women/Rashika El Ridi.jpg",
		"scientist_name": "Rashika El Ridi",
		"profession": "Immunologa",
		"brief_subtitle": "Combattente contro le malattie parassitarie",
		"year": "",
		"nationality": "Egiziana",
		"description": "Immunologa egiziana pioniera nella ricerca sulla schistosomiasi, malattia parassitaria tropicale. Professoressa all’Università del Cairo, ha dedicato la sua carriera allo sviluppo di un vaccino e alla comprensione della biochimica dei parassiti. Il suo lavoro ha avuto un impatto globale nella lotta contro le malattie trascurate dei Paesi in via di sviluppo.",
		"awards": "Numerosi riconoscimenti accademici per la ricerca sulle malattie parassitarie",
		"quote": "La scienza è la chiave per risolvere i problemi che minacciano la salute umana, e dedicare la mia vita alla ricerca è il modo migliore per fare la differenza.",
		"links": ["<https://en.wikipedia.org/wiki/Rashika_El_Ridi>"],
		"profession_keys": ["Med", "Bio"],
	},
	"Pd": {
		"name": "Palladio",
		"number": 46,
		"category": "Metallo di transizione",
		"group": 10,
		"period": 5,
		"image": "res://Images/STEAM Women/Patricia Goldman-Rakic.png",
		"scientist_name": "Patricia S. Goldman-Rakic",
		"profession": "Neuroscienziata",
		"brief_subtitle": "Pioniera della memoria di lavoro",
		"year": "1937 - 2003",
		"nationality": "Americana",
		"description": "Neuroscienziata americana che rivoluzionò lo studio della corteccia prefrontale e della memoria di lavoro. I suoi studi hanno gettato le basi per terapie contro l'Alzheimer, la schizofrenia e l'ADHD. Integrò neuroscienze cognitive e neurobiologia, ridefinendo la comprensione delle funzioni cerebrali superiori.",
		"awards": "",
		"quote": "Capire la mente significa capire la nostra essenza più profonda.",
		"links": ["<https://en.wikipedia.org/wiki/Patricia_Goldman-Rakic>"],
		"profession_keys": ["Med"],
	},

	"Ag": {
		"name": "Argento",
		"number": 47,
		"category": "Metallo di transizione",
		"group": 11,
		"period": 5,
		"image": "res://Images/STEAM Women/Agnes Pockels.png",
		"scientist_name": "Agnes Pockels",
		"profession": "Chimica",
		"brief_subtitle": "Innovatrice della chimica delle superfici",
		"year": "1862 - 1935",
		"nationality": "Tedesca",
		"description": "Chimica tedesca autodidatta che sviluppò tecniche pionieristiche per studiare la tensione superficiale dei liquidi, nonostante la mancanza di un'istruzione formale. I suoi esperimenti domestici influenzarono la ricerca in chimica colloidale e ispirarono futuri scienziati come Irving Langmuir.",
		"awards": "",
		"quote": "Non bisogna essere in un laboratorio per fare scienza, basta la passione per la scoperta.",
		"links": ["<https://en.wikipedia.org/wiki/Agnes_Pockels>"],
		"profession_keys": ["Chem"],
	},

	"Cd": {
		"name": "Cadmio",
		"number": 48,
		"category": "Metallo di transizione",
		"group": 12,
		"period": 5,
		"image": "res://Images/STEAM Women/Candace Pert.png",
		"scientist_name": "Candace Pert",
		"profession": "Neuroscienziata e Farmacologa",
		"brief_subtitle": "Scopritrice dei recettori degli oppioidi",
		"year": "1946 - 2013",
		"nationality": "Americana",
		"description": "Farmacologa americana che scoprì i recettori degli oppioidi nel cervello, rivoluzionando la comprensione del dolore e delle emozioni. Il suo lavoro ha ispirato lo sviluppo di farmaci per disturbi neurologici e ha esplorato il legame tra neurochimica e medicina mente-corpo.",
		"awards": "",
		"quote": "Le emozioni parlano al nostro corpo attraverso la biochimica.",
		"links": ["<https://en.wikipedia.org/wiki/Candace_Pert>"],
		"profession_keys": ["Med","Chem", "Bio"],
	},

	"In": {
		"name": "Indio",
		"number": 49,
		"category": "Metallo post-transizionale",
		"group": 13,
		"period": 5,
		"image": "res://Images/STEAM Women/Indira Nath.png",
		"scientist_name": "Indira Nath",
		"profession": "Immunologa",
		"brief_subtitle": "Combattente contro la lebbra",
		"year": "1938 - 2021",
		"nationality": "Indiana",
		"description": "Immunologa indiana pioniera nella ricerca sulla lebbra. I suoi studi sulla risposta immunitaria hanno migliorato i trattamenti per questa malattia, riducendo lo stigma sociale. È stata un faro per la scienza nei Paesi in via di sviluppo.",
		"awards": "Numerosi premi per la ricerca sulle malattie infettive",
		"quote": "La scienza non riguarda solo la conoscenza, ma il miglioramento della vita umana.",
		"links": ["<https://en.wikipedia.org/wiki/Indira_Nath>"],
		"profession_keys": ["Med"],
	},

	"Sn": {
		"name": "Stagno",
		"number": 50,
		"category": "Metallo post-transizionale",
		"group": 14,
		"period": 5,
		"image": "res://Images/STEAM Women/Sara Negri.jpg",
		"scientist_name": "Sara Negri",
		"profession": "Matematica e Logica",
		"brief_subtitle": "Esperta in logica costruttiva",
		"year": "1970 - ",
		"nationality": "Italiana",
		"description": "Matematica italiana specializzata in logica costruttiva e sistemi deduttivi. I suoi lavori hanno applicazioni nell'informatica teorica e nell'intelligenza artificiale, ponendo ponti tra filosofia della logica e tecnologia avanzata.",
		"awards": "",
		"quote": "La logica è il ponte tra il pensiero e la conoscenza.",
		"links": ["<https://en.wikipedia.org/wiki/Sara_Negri>"],
		"profession_keys": ["Mat"],
	},

	"Sb": {
		"name": "Antimonio",
		"number": 51,
		"category": "Metalloide",
		"group": 15,
		"period": 5,
		"image": "res://Images/STEAM Women/Sara Borrel Ruiz.png",
		"scientist_name": "Sara Borrel Ruiz",
		"profession": "Farmacista e Biochimica",
		"brief_subtitle": "Pioniera degli ormoni steroidei",
		"year": "1917 - 1999",
		"nationality": "Spagnola",
		"description": "Biochimica spagnola che introdusse tecniche avanzate per l'analisi degli ormoni steroidei. Direttrice della Sezione Steroidi all'Istituto Gregorio Marañón e membro fondatore della SEBBM, ha contribuito alla crescita della biochimica in Spagna.",
		"awards": "",
		"quote": "La scienza non è solo una raccolta di conoscenze, ma un modo di pensare, di esplorare, e di cercare risposte per migliorare la nostra comprensione del mondo.",
		"links": ["<https://es.wikipedia.org/wiki/Sara_Borrel_Ruiz>"],
		"profession_keys": ["Med", "Chem", "Bio"]
	},

	"Te": {
		"name": "Tellurio",
		"number": 52,
		"category": "Metalloide",
		"group": 16,
		"period": 5,
		"image": "res://Images/STEAM Women/Tereshkova Valentina.png",
		"scientist_name": "Valentina Tereshkova",
		"profession": "Cosmonauta e Politica",
		"brief_subtitle": "Prima donna nello spazio",
		"year": "1937 - ",
		"nationality": "Russa",
		"description": "Cosmonauta sovietica che nel 1963 completò 48 orbite terrestri a bordo della Vostok 6, diventando la prima donna nello spazio. Dopo il volo, ricoprì ruoli politici nel Partito Comunista e nel Parlamento russo, promuovendo il ruolo delle donne nella scienza.",
		"awards": "Eroe dell'Unione Sovietica",
		"quote": "Un uccello non può volare con una sola ala. Il volo spaziale umano non può progredire ulteriormente senza la partecipazione attiva delle donne.",
		"links": ["<https://en.wikipedia.org/wiki/Valentina_Tereshkova>"],
		"profession_keys": ["Astro", "Hum"]
	},
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
		"description": "Figlia del matematico Teone di Alessandria, Ipazia fu pioniera nell'astronomia e nella filosofia neoplatonica. Progettò strumenti scientifici come l'astrolabio e il densimetro, fondamentali per misurare la posizione delle stelle e la densità dei liquidi.Fu assassinata per le sue idee, diventando un'icona della libertà di pensiero e del femminismo scientifico.",
		"awards": "",  # Non applicabile, ma potresti usare "Icona eterna della scienza"
		"quote": "Quando ti vedo mi prostro davanti a te e alle tue parole, vedendo la casa astrale della Vergine, infatti verso il cielo è rivolto ogni tuo atto Ipazia sacra, bellezza delle parole, astro incontaminato della sapiente cultura.",
		"links": ["https://it.wikipedia.org/wiki/Ipazia", "https://www.britannica.com/biography/Hypatia"],
		"profession_keys": ["Astro", "Mat", "Hum"],
	},
	"Xe": {
		"name": "Xenon",
		"number": 54,
		"category": "Gas nobile",
		"group": 18,
		"period": 5,
		"image": "res://Images/STEAM Women/Xiaowei Zhuang.png",
		"scientist_name": "Xiaowei Zhuang",
		"profession": "Biofisica",
		"brief_subtitle": "Pioniera della microscopia super-risoluzione",
		"year": "1972 - ",
		"nationality": "Cinese-Americana",
		"description": "Biofisica e nanotecnologa cinese-americana che ha rivoluzionato la biologia cellulare con lo sviluppo della microscopia STORM, superando il limite di diffrazione della luce. La sua tecnica permette di osservare strutture cellulari a livello nanometrico, rivelando dettagli molecolari prima invisibili. I suoi studi includono anche le interazioni biomolecolari e l’analisi del cervello.",
		"awards": "",
		"quote": "La scienza è un'opportunità per esplorare e scoprire i misteri più profondi della vita, e ogni piccolo progresso ci porta più vicino alla comprensione dei fenomeni che ci circondano.",
		"links": ["<https://en.wikipedia.org/wiki/Xiaowei_Zhuang>"],
		"profession_keys": ["Phy", "Bio"],
	},

	"Cs": {
		"name": "Cesio",
		"number": 55,
		"category": "Metallo alcalino",
		"group": 1,
		"period": 6,
		"image": "res://Images/STEAM Women/Samantha Cristoforetti.jpg",
		"scientist_name": "Samantha Cristoforetti",
		"profession": "Astronauta e Ingegnere",
		"brief_subtitle": "Prima italiana nello spazio",
		"year": "1977 - ",
		"nationality": "Italiana",
		"description": "Astronauta italiana dell’ESA e pilota militare, prima donna europea a stabilire il record di permanenza nello spazio (199 giorni) durante la missione Futura sulla ISS (2014-2015). Promuove l’educazione STEM e la parità di genere. Icona globale delle scienze aerospaziali e ambasciatrice dell’esplorazione spaziale.",
		"awards": "",
		"quote": "Quando guardi la Terra dallo spazio, ti rendi conto che siamo tutti sulla stessa barca.",
		"links": ["<https://en.wikipedia.org/wiki/Samantha_Cristoforetti>"],
		"profession_keys": ["Astro", "Eng"],
	},

	"Ba": {
		"name": "Bario",
		"number": 56,
		"category": "Metallo alcalino-terroso",
		"group": 2,
		"period": 6,
		"image": "res://Images/STEAM Women/Barbara Liskov.png",
		"scientist_name": "Barbara Liskov",
		"profession": "Informatica",
		"brief_subtitle": "Innovatrice della programmazione a oggetti",
		"year": "1939 - ",
		"nationality": "Statunitense",
		"description": "Informatica statunitense vincitrice del Premio Turing (2008) per il Principio di Sostituzione di Liskov (LSP), pilastro della programmazione a oggetti. Sviluppò il linguaggio CLU negli anni ’70, introducendo concetti rivoluzionari come la tipizzazione forte e la gestione automatica della memoria, anticipando linguaggi moderni come Java e Python.",
		"awards": "Premio Turing (2008)",
		"quote": "La chiarezza e la semplicità nel design del software non sono solo una questione di estetica, ma un mezzo per garantire che il sistema funzioni in modo affidabile e scalabile.",
		"links": ["<https://en.wikipedia.org/wiki/Barbara_Liskov>"],
		"profession_keys": ["Eng", "Mat"]
	},
	
	" . ": {
		"name": "Lantanidi", 
		"number": "57-71",
		"category": "F-Block", 
		"group": 3, 
		"period": 6,
	},
	
	" .. ": {
		"name": "Attinidi", 
		"number": "89-103",
		"category": "F-Block", 
		"group": 3, 
		"period": 7,
	},
	
	"Hf": {
		"name": "Afnio",
		"number": 72,
		"category": "Metallo di transizione",
		"group": 4,
		"period": 6,
		"image": "res://Images/STEAM Women/Stefanie Horovitz.jpg",
		"scientist_name": "Stefanie Horovitz",
		"profession": "Chimica",
		"brief_subtitle": "Pioniera degli isotopi radioattivi",
		"year": "1887 - 1942",
		"nationality": "Polacca",
		"description": "Chimica polacca di origine ebraica che contribuì alla scoperta degli isotopi lavorando con Otto Hönigschmid all'Istituto per la Ricerca sul Radio di Vienna. Determinò il peso atomico del piombo derivante dal decadimento dell'uranio, dimostrando l'esistenza degli isotopi. Dopo la Prima Guerra Mondiale, abbandonò la carriera scientifica per fondare una casa di accoglienza per bambini. Durante l'Olocausto, si consegnò volontariamente ai nazisti per proteggere altri ebrei, morendo a Treblinka. Il suo lavoro, a lungo dimenticato, è oggi riconosciuto come fondamentale per la chimica nucleare.",
		"awards": "",
		"quote": "",
		"links": ["<https://de.wikipedia.org/wiki/Stefanie_Horovitz>"],
		"profession_keys": ["Chem"],
	},

	"Ta": {
		"name": "Tantalio",
		"number": 73,
		"category": "Metallo di transizione",
		"group": 5,
		"period": 6,
		"image": "res://Images/STEAM Women/Tania A. Baker.jpg",
		"scientist_name": "Tania A. Baker",
		"profession": "Biochimica",
		"brief_subtitle": "Esperta in replicazione del DNA",
		"year": "",
		"nationality": "Statunitense",
		"description": "Biochimica statunitense e professoressa al MIT, specializzata nei meccanismi di replicazione del DNA e degradazione proteica. Ha studiato gli enzimi Clp/Hsp100, cruciali per la risposta cellulare allo stress. Vincitrice del Premio Arthur Kornberg e Paul Berg, è membro della National Academy of Sciences. La sua ricerca ha influenzato profondamente la biologia molecolare moderna.",
		"awards": "Premio Arthur Kornberg, Premio Paul Berg",
		"quote": "",
		"links": ["<https://en.wikipedia.org/wiki/Tania_Baker>"],
		"profession_keys": ["Chem", "Bio"],
	},

	"W": {
		"name": "Tungsteno",
		"number": 74,
		"category": "Metallo di transizione",
		"group": 6,
		"period": 6,
		"image": "res://Images/STEAM Women/Mary Winston Jackson.jpg",
		"scientist_name": "Mary Winston Jackson",
		"profession": "Matematica e Ingegnera aerospaziale",
		"brief_subtitle": "Pioniera dell'inclusione alla NASA",
		"year": "1921–2005",
		"nationality": "Statunitense",
		"description": "È stata la prima donna afroamericana a lavorare come ingegnere alla NASA. Iniziò come calcolatrice umana al Langley Research Center, superando barriere razziali e di genere. Dopo anni di lavoro tecnico, passò alle risorse umane per promuovere l'inclusione e supportare donne e minoranze nelle carriere scientifiche. La sua storia è raccontata nel libro e film 'Il diritto di contare'. Ha lasciato un'eredità di lotta per l'uguaglianza e l'accesso equo alle opportunità.",
		"awards": "",
		"quote": "Dobbiamo fare qualcosa del genere per farli interessare alla scienza. A volte devono solo vedere un volto femminile.",
		"links": ["<https://en.wikipedia.org/wiki/Mary_Jackson_(engineer)>"],
		"profession_keys": ["Mat", "Eng"]
	},


	"Re": {
		"name": "Renio",
		"number": 75,
		"category": "Metallo di transizione",
		"group": 7,
		"period": 6,
		"image": "res://Images/STEAM Women/Renata Kallosh.jpg",
		"scientist_name": "Renata Kallosh",
		"profession": "Fisica teorica",
		"brief_subtitle": "Esperta in supergravità e cosmologia",
		"year": "1943 - ",
		"nationality": "Russo-Americana",
		"description": "Fisica teorica russa-americana pioniera nella supergravità e nella teoria delle stringhe. Professoressa a Stanford, ha sviluppato modelli per spiegare l'espansione accelerata dell'universo. Vincitrice del Lise Meitner Award (2009) e membro dell'American Academy of Arts and Sciences. Collabora con il marito Andrei Linde, celebre per i suoi studi sull'inflazione cosmica.",
		"awards": "Lise Meitner Award (2009), Cattedra Lorentz (2017)",
		"quote": "Ogni teoria è come una finestra che ci permette di guardare il mondo in un modo diverso.",
		"links": ["<https://en.wikipedia.org/wiki/Renata_Kallosh>"],
		"profession_keys": ["Phy"],
	},

	"Os": {
		"name": "Osmio",
		"number": 76,
		"category": "Metallo di transizione",
		"group": 8,
		"period": 6,
		"image": "res://Images/STEAM Women/Olga Taussky-Todd.jpg",
		"scientist_name": "Olga Taussky-Todd",
		"profession": "Chimica e Matematica",
		"brief_subtitle": "Innovatrice della chimica inorganica",
		"year": "1906 - 1995",
		"nationality": "Austriaca-Statunitense",
		"description": "Chimica e matematica austriaca naturalizzata statunitense. Pioniera nello studio dei composti di transizione e nella teoria dei legami chimici al Caltech. Vincitrice del Perkin Medal (1977) e Lavoisier Medal, fu tra le prime donne a ottenere riconoscimenti in un campo dominato dagli uomini. Il suo lavoro sui metalli di transizione ha influenzato generazioni di ricercatori.",
		"awards": "Perkin Medal (1977), Lavoisier Medal",
		"quote": "La matematica è una lingua universale che ci permette di comprendere la bellezza intrinseca dell'universo.",
		"links": ["<https://en.wikipedia.org/wiki/Olga_Taussky-Todd>"],
		"profession_keys": ["Chem", "Mat"]
	},
	"Ir": {  
		"name": "Iridio",  
	   "number": 77,  
	   "category": "Metallo di transizione",  
	   "group": 9,  
	   "period": 6,  
	   "image": "res://Images/STEAM Women/Irène Joliot-Curie.jpg",  
	   "scientist_name": "Irène Joliot-Curie",  
	   "profession": "Chimica e Fisica",  
	   "brief_subtitle": "Scopritrice della radioattività artificiale",  
	   "year": "1897 - 1956",  
	   "nationality": "Francese",  
		   "description": "Chimica e fisica francese, figlia di Marie e Pierre Curie. Nel 1934, con il marito Frédéric Joliot-Curie, scoprì la radioattività artificiale, vincendo il Nobel per la Chimica nel 1935. Continuò gli studi sulla radioattività e i radioisotopi, rivoluzionando la medicina nucleare. Morì di leucemia nel 1956, probabilmente a causa dell'esposizione alle radiazioni. La sua eredità scientifica influenzò la ricerca nucleare e le applicazioni mediche.",  
		   "awards": "Premio Nobel per la Chimica (1935)",  
		   "quote": "Se la scienza è la chiave per il progresso, è essenziale che la sua applicazione venga guidata dalla morale.",  
		   "links": ["<https://en.wikipedia.org/wiki/Ir%C3%A8ne_Joliot-Curie>"],
		"profession_keys": ["Phy","Chem"],
	},
	"Pt": {  
		"name": "Platino",  
		"number": 78,  
		"category": "Metallo di transizione",  
		"group": 10,  
		"period": 6,  
		"image": "res://Images/STEAM Women/Patricia Bath.jpg",  
		"scientist_name": "Patricia Bath",  
		"profession": "Oftalmologa e Inventrice",  
		"brief_subtitle": "Pioniera della chirurgia della cataratta",  
		"year": "1942 - 2019",  
		"nationality": "Americana",  
		"description": "Oftalmologa e inventrice americana, prima donna afroamericana a ottenere un brevetto medico (1988) per la sonda Laserphaco, che rivoluzionò la chirurgia della cataratta. Fondò l’American Institute for the Prevention of Blindness e fu la prima donna nera a dirigere un programma di specializzazione in oftalmologia negli USA. Il suo lavoro migliorò l’accesso alle cure oculistiche per le comunità svantaggiate.",  
		"awards": "Brevetto per la Laserphaco (1988), Fondatrice dell’American Institute for the Prevention of Blindness (1976)",  
		"quote": "La capacità di ripristinare la vista è la ricompensa finale.",  
		"links": ["<https://en.wikipedia.org/wiki/Patricia_Bath>"],
		"profession_keys": ["Med"],
	},
	"Au": {
		"name": "Oro",
		"number": 79,
		"category": "Metallo di transizione",
		"group": 11,
		"period": 6,
		"image": "res://Images/STEAM Women/Audrey Tang.jpg",
		"scientist_name": "Audrey Tang",
		"profession": "Programmatrice e Politica",
		"brief_subtitle": "Innovatrice della democrazia digitale",
		"year": "1981-",
		"nationality": "Cinese (Taiwanese)",
		"description": "Audrey Tang, nata a Taiwan, è una programmatrice, attivista e politica nota per il suo lavoro nel campo della tecnologia e della democrazia digitale. È diventata il ministro digitale di Taiwan, ed è la prima persona transgender ad assumere una carica ministeriale nel paese. Sebbene non sia una chimica, ha avuto un impatto significativo nel migliorare la trasparenza governativa e il coinvolgimento civico attraverso l'uso delle tecnologie digitali. Tang è riconosciuta per le sue innovazioni nel promuovere la democrazia partecipativa e per il suo impegno verso una società più equa e inclusiva.",
		"awards": "",
		"quote": "La tecnologia è solo uno strumento. La vera innovazione nasce quando lo utilizziamo per costruire una società più equa e inclusiva.",
		"links": ["https://en.wikipedia.org/wiki/Audrey_Tang"],
		"profession_keys": ["Eng"]
	},
	"Hg": {  
		"name": "Mercurio",  
		"number": 80,  
		"category": "Metallo di transizione",  
		"group": 12,  
		"period": 6,  
		"image": "res://Images/STEAM Women/Margerita Hack.jpg",  
		"scientist_name": "Margherita Hack",  
		"profession": "Astronoma e Divulgatrice",  
		"brief_subtitle": "Icona dell'astronomia italiana",  
		"year": "1922 - 2013",  
		"nationality": "Italiana",  
		"description": "Astronoma e fisica italiana, prima donna a dirigere l’Osservatorio Astronomico di Trieste. Studiò l’evoluzione stellare e la radiazione cosmica, diventando un simbolo della divulgazione scientifica e dei diritti civili. Membro dell’Accademia dei Lincei, ha ispirato generazioni di scienziati con il suo impegno per la scienza libera e l’inclusione delle donne nella ricerca.",  
		"awards": "Membro dell'Accademia dei Lincei",  
		"quote": "Nella vita non c’è nulla da temere, solo da capire.",  
		"links": ["<https://en.wikipedia.org/wiki/Margherita_Hack>"],
		"profession_keys": ["Phy","Astro"],
	},  

	"Tl": {  
		"name": "Tallio",  
		"number": 81,  
		"category": "Metallo post-transizionale",  
		"group": 13,  
		"period": 6,  
		"image": "res://Images/STEAM Women/Tilly Edinger.jpg",  
		"scientist_name": "Tilly Edinger",  
		"profession": "Paleontologa",  
		"brief_subtitle": "Fondatrice della paleoneurobiologia",  
		"year": "1897 - 1967",  
		"nationality": "Tedesca",  
		"description": "Paleontologa tedesca pioniera nello studio dell’evoluzione del cervello attraverso i fossili. Analizzando i calchi endocranici di rettili preistorici come il *Nothosaurus*, integrò anatomia comparata e stratigrafia, creando la paleoneurobiologia. Il suo lavoro rivoluzionò la comprensione dello sviluppo cerebrale nei vertebrati.",  
		"awards": "",  
		"quote": "Il cervello non si fossilizza, ma le sue tracce si.",  
		"links": ["<https://en.wikipedia.org/wiki/Tilly_Edinger>"],
		"profession_keys": ["Bio"]
	},  

	"Pb": {  
		"name": "Piombo",  
		"number": 82,  
		"category": "Metallo post-transizionale",  
		"group": 14,  
		"period": 6,  
		"image": "res://Images/STEAM Women/Paola Bonfante.jpg",  
		"scientist_name": "Paola Bonfante",  
		"profession": "Biologa",  
		"brief_subtitle": "Esperta di simbiosi micorriziche",  
		"year": "1947 - ",  
		"nationality": "Italiana",  
		"description": "Biologa italiana, professoressa emerita all’Università di Torino. Ha studiato le micorrize, simbiosi tra funghi e piante che coinvolgono il 90% delle specie vegetali. La sua ricerca ha implicazioni cruciali per l’agricoltura sostenibile e la salute degli ecosistemi.",  
		"awards": "",  
		"quote": "Una pianta non è un’isola.",  
		"links": ["<https://en.wikipedia.org/wiki/Paola_Bonfante>"]  ,
		"profession_keys": ["Bio"],
	},  

	"Bi": {  
		"name": "Bismuto",  
		"number": 83,  
		"category": "Metallo post-transizionale",  
		"group": 15,  
		"period": 6,  
		"image": "res://Images/STEAM Women/Bice Fubini.jpg",  
		"scientist_name": "Bice Fubini",  
		"profession": "Chimica",  
		"brief_subtitle": "Studiosa degli effetti degli inquinanti",  
		"year": "1943 - ",  
		"nationality": "Italiana",  
		"description": "Chimica italiana, socia corrispondente dell’Accademia delle Scienze di Torino e Presidente del Centro per lo studio degli Amianti. Si è dedicata alla tossicità delle particelle inquinanti e al ruolo delle donne nella scienza, promuovendo l’uguaglianza di genere nella ricerca.",  
		"awards": "",  
		"quote": "L’unica rivoluzione compiuta nel secolo passato è quella delle donne.",  
		"links": ["<https://it.wikipedia.org/wiki/Bice_Fubini>"],
		"profession_keys": ["Chem"],
	},  

	"Po": {  
		"name": "Polonio",  
		"number": 84,  
		"category": "Metalloide",  
		"group": 16,  
		"period": 6,  
		"image": "res://Images/STEAM Women/Polly Matzinger.jpg",  
		"scientist_name": "Polly Matzinger",  
		"profession": "Immunologa",  
		"brief_subtitle": "Teorica del modello di pericolo",  
		"year": "1947 - ",  
		"nationality": "Francese",  
		"description": "Immunologa francese nota per la teoria del modello di pericolo, che spiega come il sistema immunitario risponda a segnali di danno cellulare piuttosto che al semplice riconoscimento di agenti esterni. La sua teoria ha rivoluzionato la comprensione delle allergie e delle malattie autoimmuni.",  
		"awards": "",  
		"quote": "Il sistema immunitario non distingue tra sé e non-sé, ma tra ciò che è pericoloso e ciò che non lo è.",  
		"links": ["<https://en.wikipedia.org/wiki/Polly_Matzinger>"],
		"profession_keys": ["Med"],
	},  

	"At": {  
		"name": "Astato",  
		"number": 85,  
		"category": "Alogeno",  
		"group": 17,  
		"period": 6,  
		"image": "res://Images/STEAM Women/Astrid Cleve.jpg",  
		"scientist_name": "Astrid Cleve",  
		"profession": "Botanica e Chimica",  
		"brief_subtitle": "Pioniera svedese della chimica organica",  
		"year": "1875 - 1968",  
		"nationality": "Svedese",  
		"description": "Botanica e chimica svedese, prima donna nel suo Paese a ottenere un dottorato in scienze. Collaborò con il marito Hans von Euler-Chelpin nella sintesi di alcoli e composti azotati. I suoi studi sul plancton delle acque di Stoccolma sono un riferimento storico per la ricerca ecologica.",  
		"awards": "",  
		"quote": "La scienza è un viaggio attraverso il tempo e la natura: chi la segue lascia tracce che ispirano generazioni future.",  
		"links": ["<https://en.wikipedia.org/wiki/Astrid_Cleve>"],
		"profession_keys": ["Bio","Chem"],
	},  

	"Rn": {  
		"name": "Radon",  
		"number": 86,  
		"category": "Gas nobile",  
		"group": 18,  
		"period": 6,  
		"image": "res://Images/STEAM Women/Ruth Nussenzweig.png",  
		"scientist_name": "Ruth Nussenzweig",  
		"profession": "Immunologa",  
		"brief_subtitle": "Combattente contro la malaria",  
		"year": "1928 - 2018",  
		"nationality": "Austro-Brasiliana",  
		"description": "Immunologa austro-brasiliana che sviluppò i primi vaccini sperimentali contro la malaria. Identificò proteine chiave del parassita *Plasmodium* come bersagli per la vaccinazione, aprendo la strada a strategie preventive globali. Il suo lavoro ha salvato milioni di vite nelle regioni endemiche.",  
		"awards": "",  
		"quote": "La ricerca scientifica è una battaglia incessante contro le malattie che affliggono l'umanità; con passione e determinazione, possiamo sconfiggerle.",  
		"links": ["<https://en.wikipedia.org/wiki/Ruth_Nussenzweig>"],
		"profession_keys": ["Bio"],
	},

	# Periodo 7
	"Fr": {  
		"name": "Francio",  
		"number": 87,  
		"category": "Metallo alcalino",  
		"group": 1,  
		"period": 7,  
		"image": "res://Images/STEAM Women/Rosalind Franklin.jpg",  
		"scientist_name": "Rosalind Franklin",  
		"profession": "Chimica e Cristallografa",  
		"brief_subtitle": "Colei che svelò il DNA",  
		"year": "1920 - 1958",  
		"nationality": "Britannica",  
		"description": "Cristallografa britannica che catturò la celebre *Foto 51*, dimostrando la struttura a doppia elica del DNA. Il suo lavoro fu utilizzato senza riconoscimento da Watson, Crick e Wilkins, che vinsero il Nobel nel 1962. Morì a 37 anni per tumore, probabilmente causato dall’esposizione alle radiazioni durante gli esperimenti. Il suo contributo fu rivalutato postumo, rendendola un simbolo delle donne nella scienza.",  
		"awards": "Riconoscimento postumo per la scoperta del DNA",  
		"quote": "La scienza e la vita quotidiana non possono e non devono essere separate.",  
		"links": ["<https://en.wikipedia.org/wiki/Rosalind_Franklin>"],
		"profession_keys": ["Bio", "Chem"],
	},  

	"Ra": {  
		"name": "Radio",  
		"number": 88,  
		"category": "Metallo alcalino-terroso",  
		"group": 2,  
		"period": 7,  
		"image": "res://Images/STEAM Women/Rachel Carson.jpg",  
		"scientist_name": "Rachel Carson",  
		"profession": "Biologa e Ambientalista",  
		"brief_subtitle": "Madre del movimento ambientalista",  
		"year": "1907 - 1964",  
		"nationality": "Statunitense",  
		"description": "Biologa marina e zoologa statunitense, autrice di *Primavera Silenziosa* (1962), libro che denunciò gli effetti devastanti del DDT sugli ecosistemi, innescando il movimento ambientalista globale. Lavorò per il Dipartimento della Pesca USA, combinando scienza e scrittura per sensibilizzare sull’inquinamento degli oceani e i rischi dei pesticidi.",  
		"awards": "Medaglia Presidenziale della Libertà (postuma, 1980)",  
		"quote": "L'uomo fa parte della natura e la sua guerra contro la natura è inevitabilmente una guerra contro se stesso.",  
		"links": ["<https://en.wikipedia.org/wiki/Rachel_Carson>"],
		"profession_keys": ["Bio", "Hum"],
	},
	"Rf": {
		"name": "Rutherfordio",
		"number": 104,
		"category": "Metallo di transizione",
		"group": 4,
		"period": 7,
		"image": "res://Images/STEAM Women/Rachel Fuller Brown.jpg",
		"scientist_name": "Rachel Fuller Brown",
		"profession": "Biochimica",
		"brief_subtitle": "Scopritrice della nistatina",
		"year": "1898 - 1980",
		"nationality": "Statunitense",
		"description": "Chimica statunitense che, insieme a Elizabeth Lee Hazen, scoprì la nistatina (1948), primo antibiotico antifungino efficace e non tossico per l’uomo. La loro invenzione rivoluzionò il trattamento delle infezioni da lieviti, donando i diritti d’autore alla ricerca scientifica.",
		"awards": "",
		"quote": "Non abbiamo mai pensato di arricchirci con la nostra scoperta. Il nostro obiettivo era aiutare le persone.",
		"links": ["<https://en.wikipedia.org/wiki/Rachel_Fuller_Brown>"],
		"profession_keys": ["Bio", "Chem"],
	},

	"Db": {
		"name": "Dubnio",
		"number": 105,
		"category": "Metallo di transizione",
		"group": 5,
		"period": 7,
		"scientist_name": "Ildegarda di Bingen",
		"profession": "Naturalista",
		"brief_subtitle": "Fondatrice della ginecologia e studiosa del mondo naturale",
		"year": "1098-1179",
		"nationality": "Tedesca",
		"description": "Naturalista, guaritrice, scienziata, filosofa, poeta e compositrice del Medioevo. Gettò le basi per lo studio della ginecologia e della salute delle donne. Fu ordinata suora sotto la regola benedettina. Ha scritto opere di botanica e medicina. Nel volume *Physica*, descrisse gli elementi del mondo naturale, indicandone le proprietà utili per gli esseri umani. È stata canonizzata Santa dalla Chiesa nel 2012 da papa Benedetto XVI.",
		"awards": "",
		"quote": "Guarda il cielo: Guarda il sole e le stelle. E adesso, rifletti. Quanto grande è il diletto che Dio dà all'umanità con tutte queste cose.. Dobbiamo lavorare insieme a lei.",
		"links": [
			"https://it.wikipedia.org/wiki/Ildegarda_di_Bingen"
		],
		"profession_keys": ["Hum", "Med"]
	},
	"Sg": {
		"name": "Seaborgio", 
		"number": 106,
		"category": "Metallo di transizione", 
		"group": 6,
		"period": 7,
		"image": "res://Images/STEAM Women/Segener Kelemu.jpg",
		"scientist_name": "Segenet Kelemu",
		"profession": "Scienziata agricola",
		"brief_subtitle": "Pioniera dell'agricoltura sostenibile in Africa",
		"year": "1957 - ",
		"nationality": "Etiope",
		"description": "Scienziata etiope, prima donna africana a dirigere l’ICIPE in Kenya. Ha sviluppato metodi per combattere le malattie delle piante e migliorare la resa dei raccolti in condizioni climatiche estreme, sostenendo gli agricoltori subsahariani.",
		"awards": "Premio L’Oréal-UNESCO per le Donne e la Scienza (2014)",
		"quote": "Voglio fare la differenza in Africa, aiutare gli agricoltori e migliorare l'agricoltura attraverso la scienza e l'innovazione.",
		"links": ["<https://en.wikipedia.org/wiki/Segenet_Kelemu>"],
		"profession_keys": ["Bio"],
	},
	"Bh": {
		"name": "Bohrio",
		"number": 107,
		"category": "Metallo di transizione",
		"group": 7,
		"period": 7,
		"image": "res://Images/STEAM Women/Beatrice Hicks.jpg",
		"scientist_name": "Beatrice Hicks",
		"profession": "Ingegnera aerospaziale",
		"brief_subtitle": "Pioniera delle donne in ingegneria",
		"year": "1919 - 1979",
		"nationality": "Statunitense",
		"description": "Ingegnera statunitense, tra le prime donne nel settore aerospaziale. Progettò sensori di gas per la NASA e co-fondò la Society of Women Engineers (SWE) per promuovere l’uguaglianza di genere in un campo dominato dagli uomini.",
		"awards": "National Inventors Hall of Fame (2019, postuma)",
		"quote": "Ho sempre sentito di dover lavorare più duramente e più a lungo di un uomo per dimostrare il mio valore.",
		"links": ["<https://en.wikipedia.org/wiki/Beatrice_Hicks>"],
		"profession_keys": ["Eng","Astro"],
	},
	"Hs": {
		"name": "Hassio",
		"number": 108,
		"category": "Metallo di transizione",
		"group": 8,
		"period": 7,
		"image": "res://Images/STEAM Women/Helen Sawyer.jpg",
		"scientist_name": "Helen Sawyer Hogg",
		"profession": "Astronoma",
		"brief_subtitle": "Mappatrice delle Cefeidi",
		"year": "1905 - 1993",
		"nationality": "Statunitense-Canadese",
		"description": "Astronoma pioniera nello studio delle stelle variabili Cefeidi negli ammassi globulari. Professoressa all’Università di Toronto, unì ricerca accademica e divulgazione, scrivendo una rubrica di astronomia per il pubblico per oltre 30 anni.",
		"awards": "Order of Canada (1976)",
		"quote": "Le stelle appartengono a tutti.",
		"links": ["<https://en.wikipedia.org/wiki/Helen_Sawyer_Hogg>"],
		"profession_keys": ["Astro"],
	},
	"Mt": {
		"name": "Meitnerio",
		"number": 109,
		"category": "Sconosciuto",
		"group": 9,
		"period": 7,
		"image": "res://Images/STEAM Women/Martha Chase.jpg",
		"scientist_name": "Martha Chase",
		"profession": "Genetista",
		"brief_subtitle": "Confermatrice del ruolo del DNA",
		"year": "1927 - 2003",
		"nationality": "Statunitense",
		"description": "Genetista statunitense nota per l’*esperimento di Hershey-Chase* (1952), che dimostrò che il DNA (non le proteine) è il materiale genetico. Il suo lavoro fu fondamentale per la scoperta della doppia elica da parte di Watson e Crick.",
		"awards": "",
		"quote": "Credo che la scienza sia qualcosa che deve essere fatta con passione.",
		"links": ["<https://en.wikipedia.org/wiki/Martha_Chase>"],
		"profession_keys": ["Bio"]
	},
	"Ds": {
		"name": "Darmstadio",
		"number": 110,
		"category": "Sconosciuto",
		"group": 10,
		"period": 7,
		"image": "res://Images/STEAM Women/Doris Taylor.jpg",
		"scientist_name": "Doris Taylor",
		"profession": "Biologa della rigenerazione",
		"brief_subtitle": "Pioniera degli organi bioartificiali",
		"year": "1956 - ",
		"nationality": "Statunitense",
		"description": "Biologa statunitense pioniera nella medicina rigenerativa. Nel 2008 rigenerò un cuore di ratto funzionante utilizzando una matrice decellularizzata, aprendo la strada alla creazione di organi per trapianti su misura.",
		"awards": "",
		"quote": "Credo che il futuro della medicina risieda nella creazione di soluzioni per i pazienti che siano su misura per loro, non una soluzione universale.",
		"links": ["<https://en.wikipedia.org/wiki/Doris_Taylor_(scientist)>"],
		"profession_keys": ["Med", "Bio"],
	},
	"Rg": {
		"name": "Roentgenio",
		"number": 111,
		"category": "Sconosciuto",
		"group": 11,
		"period": 7,
		"image": "res://Images/STEAM Women/Regina Kapeller-Adler.jpg",
		"scientist_name": "Regina Kapeller-Adler",
		"profession": "Biochimica",
		"brief_subtitle": "Pioniera dei test di gravidanza",
		"year": "1900 - 1991",
		"nationality": "Austriaca",
		"description": "Biochimica austriaca che sviluppò il primo test rapido per la diagnosi precoce della gravidanza (1933), rilevando l’istidina nelle urine in sole 4 ore. Il suo metodo sostituì procedure lunghe e invasive, rivoluzionando la medicina prenatale.",
		"awards": "",
		"quote": "La ricerca è un viaggio di scoperta che può cambiare la vita di milioni di persone, un passo alla volta.",
		"links": ["<https://en.wikipedia.org/wiki/Regina_Kapeller-Adler>"],
		"profession_keys": ["Chem", "Bio"],
	},
	"Cn": {
		"name": "Copernicio",
		"number": 112,
		"category": "Metallo di transizione",
		"group": 12,
		"period": 7,
		"image": "res://Images/STEAM Women/Caroline Herschel.jpg",
		"scientist_name": "Caroline Herschel",
		"profession": "Astronoma",
		"brief_subtitle": "Prima donna stipendiata",
		"year": "1750 - 1848",
		"nationality": "Tedesca-Britannica",
		"description": "Astronoma tedesca-britannica, è celebre per essere stata la prima donna astronoma stipendiata, un riconoscimento fondamentale per l'epoca. Collaborò strettamente con il fratello William Herschel nelle osservazioni ma si distinse per le sue scoperte autonome, tra cui 8 comete e il catalogo di 2.500 nuove stelle. Ricevette importanti riconoscimenti per il suo lavoro, inclusa la Medaglia d'oro della Royal Astronomical Society nel 1828. La sua passione per la scienza era profonda.",
		"awards": "Medaglia d'oro della Royal Astronomical Society (1828)",
		"quote": "Non ho cercato nulla al di fuori del lavoro che mio fratello mi ha affidato.",
		"links": ["<https://en.wikipedia.org/wiki/Caroline_Herschel>"],
		"profession_keys": ["Astro"],
	},
	"Nh": {
		"name": "Nihonio",
		"number": 113,
		"category": "Sconosciuto",
		"group": 13,
		"period": 7,
		"image": "res://Images/STEAM Women/Nucharin Songsasen.jpg",
		"scientist_name": "Nucharin Songsasen",
		"profession": "Biologa della conservazione",
		"brief_subtitle": "Salvatrice delle specie a rischio",
		"year": "",
		"nationality": "Thailandese",
		"description": "Biologa thailandese che ha rivoluzionato la crioconservazione di embrioni animali. Guidò il team che realizzò la prima fecondazione in vitro nei cani, aprendo nuove strade per la conservazione delle specie selvatiche in via di estinzione.",
		"awards": "",
		"quote": "Ogni specie che salviamo è una storia che continuiamo a raccontare, un legame che preserviamo per il futuro del nostro pianeta.",
		"links": ["<https://nationalzoo.si.edu/staff/nucharin-songsasen>"],
		"profession_keys": ["Bio"],
	},
	"Fl": {
		"name": "Flerovio",
		"number": 114,
		"category": "Sconosciuto",
		"group": 14,
		"period": 7,
		"image": "res://Images/STEAM Women/Filomena Nitti.jpg",
		"scientist_name": "Filomena Nitti",
		"profession": "Chimica e Farmacologa",
		"brief_subtitle": "Pioniera degli antibiotici",
		"year": "1909 - 1994",
		"nationality": "Italiana",
		"description": "Chimica italiana che collaborò con Daniel Bovet (Premio Nobel 1957) alla ricerca su sulfamidici e penicillina durante la Seconda Guerra Mondiale. Il suo lavoro contribuì alla produzione di sieri antitetanici salvavita per i soldati.",
		"awards": "",
		"quote": "La scienza non è solo una ricerca di risposte, ma un viaggio continuo verso una comprensione più profonda del nostro mondo e di noi stessi.",
		"links": ["<https://it.wikipedia.org/wiki/Filomena_Nitti>"],
		"profession_keys": ["Chem","Med"],
	},
	"Mc": {
		"name": "Moscovio",
		"number": 115,
		"category": "Sconosciuto",
		"group": 15,
		"period": 7,
		"image": "res://Images/STEAM Women/Mae Carol Jemison.jpg",
		"scientist_name": "Mae Carol Jemison",
		"profession": "Medico e astronauta",
		"brief_subtitle": "Prima donna afroamericana nello spazio",
		"year": "1956-",
		"nationality": "Statunitense",
		"description": "Mae Carol Jemison è un medico, ingegnere e astronauta statunitense, celebre per essere stata la prima donna afroamericana nello spazio. Volò a bordo dello Space Shuttle Endeavour nel 1992. Laureata in ingegneria chimica e medicina, ha lavorato come medico in Africa con i Peace Corps prima di entrare alla NASA. Oltre alla carriera scientifica, ha promosso attivamente l’educazione STEM e l’inclusione delle minoranze. Dopo la NASA, ha fondato aziende e progetti educativi per connettere scienza, arte e innovazione. Mae Jemison è anche comparsa in un episodio di Star Trek, realizzando un sogno d’infanzia.",
		"awards": "",
		"quote": "Non lasciarti mai limitare dalle immaginazioni limitate degli altri.",
		"links": [
			"https://en.wikipedia.org/wiki/Mae_Jemison"
		],
		"profession_keys": ["Med","Astro"]
	},

	"Lv": {
		"name": "Livermorio",
		"number": 116,
		"category": "Sconosciuto",
		"group": 16,
		"period": 7,
		"image": "res://Images/STEAM Women/Lydia Villa-Komaroff.jpg",
		"scientist_name": "Lydia Villa-Komaroff",
		"profession": "Biologa molecolare",
		"brief_subtitle": "Pioniera dell'insulina sintetica",
		"year": "1947 - ",
		"nationality": "Statunitense",
		"description": "Biologa molecolare che dimostrò nel 1978 come produrre insulina umana usando batteri geneticamente modificati. La sua scoperta rivoluzionò il trattamento del diabete, rendendo possibile la produzione industriale di farmaci biotecnologici.",
		"awards": "",
		"quote": "La scienza non ha genere, razza o etnia: è per tutti.",
		"links": ["<https://en.wikipedia.org/wiki/Lydia_Villa-Komaroff>"],
		"profession_keys": ["Bio"],
	},
	"Ts": {
		"name": "Tennesso",
		"number": 117,
		"category": "Sconosciuto",
		"group": 17,
		"period": 7,
		"image": "res://Images/STEAM Women/Donna Theo Strickland.jpg",
		"scientist_name": "Donna Theo Strickland",
		"profession": "Fisica",
		"brief_subtitle": "Pioniera dei laser ad alta intensità",
		"year": "1959-",
		"nationality": "Canadese",
		"description": "Donna Theo Strickland è una fisica canadese, nata nel 1959, specializzata in ottica e laser. Ha vinto il Premio Nobel per la Fisica nel 2018 per lo sviluppo della chirped pulse amplification (CPA), una tecnica che ha rivoluzionato i laser ad alta intensità. Il premio lo ha condiviso con Gérard Mourou, con cui ha sviluppato la tecnica durante il dottorato. La CPA è oggi usata in applicazioni come la chirurgia oculare e la fisica dei plasmi. È stata la terza donna nella storia a ricevere il Nobel per la fisica, dopo Marie Curie e Maria Goeppert Mayer. Strickland è anche professoressa all’Università di Waterloo ed è nota per la sua passione per l’insegnamento e la scienza accessibile.",
		"awards": "",
		"quote": "Ho sempre pensato che fosse semplicemente ciò che fanno i fisici: costruiscono laser.",
		"links": [
			"https://en.wikipedia.org/wiki/Donna_Strickland"
		],
		"profession_keys": ["Phy"]
	},

	"Og": {
		"name": "Oganesson",
		"number": 118,
		"category": "Sconosciuto",
		"group": 18,
		"period": 7,
		"image": "res://Images/STEAM Women/Olga Kennard.jpg",
		"scientist_name": "Olga Kennard",
		"profession": "Cristallografa",
		"brief_subtitle": "Archivista della struttura molecolare",
		"year": "1924 - 2023",
		"nationality": "Britannica",
		"description": "Cristallografa britannica, fondatrice del Cambridge Crystallographic Data Centre (CCDC). Creò un database globale di strutture molecolari, strumento essenziale per la ricerca farmaceutica e la chimica moderna.",
		"awards": "Order of the British Empire (1987)",
		"quote": "La scienza è un viaggio collettivo: la conoscenza condivisa è la chiave del progresso.",
		"links": ["<https://en.wikipedia.org/wiki/Olga_Kennard>"],
		"profession_keys": ["Chem"],
	},

	# Lantanidi (periodo fittizio 9, gruppo 3-18)
	"La": {
		"name": "Lantanio",
		"number": 57,
		"category": "Lantanide",
		"group": 3,
		"period": 9,
		"image": "res://Images/STEAM Women/Laura Bassi.png",
		"scientist_name": "Laura Bassi",
		"profession": "Fisica e Accademica",
		"brief_subtitle": "Prima donna europea con un dottorato in scienze",
		"year": "1711 - 1778",
		"nationality": "Italiana",
		"description": "Fisica italiana pioniera, prima donna in Europa a ottenere un dottorato in filosofia (1732) e cattedratica di fisica sperimentale a Bologna (1776). Diffuse le teorie newtoniane e condusse esperimenti su elettricità e meccanica in un’epoca dominata dagli uomini.",
		"awards": "",
		"quote": "La scienza è il linguaggio della verità, e il mio impegno è nel rivelarla attraverso la curiosità e la dedizione, senza limiti di genere.",
		"links": ["<https://en.wikipedia.org/wiki/Laura_Bassi>"],
		"profession_keys": ["Phy"],
	},
	"Ce": {
		"name": "Cerio",
		"number": 58,
		"category": "Lantanide",
		"group": 4,
		"period": 9,
		"image": "res://Images/STEAM Women/Celeste Saulo.png",
		"scientist_name": "Celeste Saulo",
		"profession": "Meteorologa",
		"brief_subtitle": "Pioniera della meteorologia globale",
		"year": "1964 - ",
		"nationality": "Argentina",
		"description": "Meteorologa argentina, prima donna a dirigere il Servizio Meteorologico Nazionale Argentino (2014) e Prima Vicepresidente dell’Organizzazione Meteorologica Mondiale (2018). Promuove tecnologie avanzate per previsioni climatiche precise e accessibili.",
		"awards": "",
		"quote": "La scienza è il nostro strumento più potente per comprendere e affrontare le sfide globali...",
		"links": ["<https://en.wikipedia.org/wiki/Celeste_Saulo>"],
		"profession_keys": ["Phy"],
	},
	"Pr": {
		"name": "Praseodimio",
		"number": 59,
		"category": "Lantanide",
		"group": 5,
		"period": 9,
		"image": "res://Images/STEAM Women/Pratibha Gai.png",
		"scientist_name": "Pratibha Gai",
		"profession": "Chimica e Ricercatrice",
		"brief_subtitle": "Rivoluzionaria della microscopia atomica",
		"year": "",
		"nationality": "Britannica",
		"description": "Chimica britannica che ha rivoluzionato la microscopia elettronica (TEM), permettendo l’osservazione diretta di atomi singoli. Le sue innovazioni hanno accelerato progressi in nanotecnologia e scienza dei materiali.",
		"awards": "Premio L’Oréal-UNESCO (2013), Medaglia Hughes della Royal Society (2020)",
		"quote": "La scienza è una finestra sul mondo microscopico...",
		"links": ["<https://en.wikipedia.org/wiki/Pratibha_Gai>"],
		"profession_keys": ["Phy", "Chem"]
	},
	"Nd": {
		"name": "Neodimio",
		"number": 60,
		"category": "Lantanide",
		"group": 6,
		"period": 9,
		"image": "res://Images/STEAM Women/Ida Noddack.jpg",
		"scientist_name": "Ida Noddack",
		"profession": "Chimica e Fisica",
		"brief_subtitle": "Pioniera della chimica nucleare",
		"year": "1896-1978",
		"nationality": "Tedesca",
		"description": "Ida Noddack è stata una chimica e fisica tedesca nota per la scoperta del renio nel 1925 insieme a suo marito, Walter Noddack. Nel 1934, intuì che il nucleo dell'uranio poteva spezzarsi in elementi più leggeri, anticipando la fissione nucleare, ma la sua teoria fu inizialmente ignorata. Nonostante le difficoltà dovute ai pregiudizi di genere, continuò a contribuire alla ricerca scientifica, lasciando un'eredità importante nella chimica nucleare.",
		"awards": "",
		"quote": "La scienza non è una questione di semplici esperimenti, ma di intuizioni che richiedono coraggio e perseveranza per essere espresse.",
		"links": ["https://en.wikipedia.org/wiki/Ida_Noddack"],
		"profession_keys": ["Phy", "Chem"]
	},
	"Pm": {
		"name": "Promezio",
		"number": 61,
		"category": "Lantanide",
		"group": 7,
		"period": 9,
		"image": "res://Images/STEAM Women/Patricia Medici.jpg",
		"scientist_name": "Patricia Medici",
		"profession": "Biologa della conservazione",
		"brief_subtitle": "Protettrice dei tapiri sudamericani",
		"year": "",
		"nationality": "Brasiliana",
		"description": "Biologa brasiliana fondatrice del Lowland Tapir Conservation Initiative. Il suo lavoro ha protetto habitat critici in Amazzonia, salvando il tapiro e preservando la biodiversità.",
		"awards": "Premio Whitley per la Conservazione (2008)",
		"quote": "Salvare i tapiri significa salvare i loro habitat...",
		"links": ["<https://en.wikipedia.org/wiki/Patricia_Medici>"],
		"profession_keys": ["Bio"],
	},
	"Sm": {
		"name": "Samario",
		"number": 62,
		"category": "Lantanide",
		"group": 8,
		"period": 9,
		"image": "res://Images/STEAM Women/Susan Murphy.jpg",
		"scientist_name": "Susan Murphy",
		"profession": "Statistica",
		"brief_subtitle": "Innovatrice della medicina personalizzata",
		"year": "1958 - ",
		"nationality": "Americana",
		"description": "Statistica americana, professoressa ad Harvard. Ha creato i SMART trials per ottimizzare terapie in tempo reale, rivoluzionando il trattamento di malattie croniche come diabete e depressione.",
		"awards": "MacArthur Fellowship (2013), Medaglia Nazionale della Scienza (2021)",
		"quote": "Amo la statistica e mi piace che permetta così tanta libertà.",
		"links": ["<https://en.wikipedia.org/wiki/Susan_Murphy_(statistician)>"],
		"profession_keys": ["Med", "Mat"],
	},
	"Eu": {
		"name": "Europio",
		"number": 63,
		"category": "Lantanide",
		"group": 9,
		"period": 9,
		"image": "res://Images/STEAM Women/Eugenie Clark.jpg",
		"scientist_name": "Eugenie Clark",
		"profession": "Biologa marina",
		"brief_subtitle": "La Signora degli Squali",
		"year": "1922 - 2015",
		"nationality": "Americana",
		"description": "Biologa marina americana, pioniera nello studio degli squali. Fondò il Mote Marine Laboratory e dimostrò l’intelligenza di questi predatori, sfatando miti e promuovendo la conservazione degli oceani. Scoprì nuove specie e scrisse libri per avvicinare il pubblico alla vita marina.",
		"awards": "",
		"quote": "Anche la più piccola creatura sulla Terra ha uno scopo. Non esiste una vita insignificante.",
		"links": ["<https://en.wikipedia.org/wiki/Eugenie_Clark>"],
		"profession_keys": ["Bio"],
	},

	"Gd": {
		"name": "Gadolinio",
		"number": 64,
		"category": "Lantanide",
		"group": 10,
		"period": 9,
		"image": "res://Images/STEAM Women/Gertrude Elion.jpg",
		"scientist_name": "Gertrude Elion",
		"profession": "Chimica e Farmacologa",
		"brief_subtitle": "Nobel per i farmaci salva-vita",
		"year": "1918 - 1999",
		"nationality": "Americana",
		"description": "Chimica americana vincitrice del Nobel per la Medicina (1988). Sviluppò farmaci rivoluzionari come l’azatioprina (per trapianti) e l’aciclovir (antivirale), utilizzando un approccio razionale che ha trasformato la farmacologia moderna.",
		"awards": "Premio Nobel per la Medicina (1988)",
		"quote": "Non aver paura del duro lavoro. Nulla di valido arriva facilmente.",
		"links": ["<https://en.wikipedia.org/wiki/Gertrude_B._Elion>"],
		"profession_keys": ["Med", "Chem"]
	},

	"Tb": {
		"name": "Terbio",
		"number": 65,
		"category": "Lantanide",
		"group": 11,
		"period": 9,
		"image": "res://Images/STEAM Women/Tatiana Birshtein.jpg",
		"scientist_name": "Tatiana Birshtein",
		"profession": "Scienziata dei polimeri",
		"brief_subtitle": "Pioniera della fisica macromolecolare",
		"year": "1928 - 2022",
		"nationality": "Russa",
		"description": "Scienziata russa specializzata nello studio di DNA, micelle e polimeri. Lavorò all’Istituto dei Composti Macromolecolari di San Pietroburgo, contribuendo a definire i principi strutturali delle macromolecole. Vincitrice del Premio L’Oréal-UNESCO (2007).",
		"awards": "Premio L’Oréal-UNESCO per le Donne nella Scienza (2007)",
		"quote": "La scienza dei polimeri è un filo invisibile che lega il mondo materiale alla comprensione profonda della natura.",
		"links": ["<https://en.wikipedia.org/wiki/Tatiana_Birshtein>"],
		"profession_keys": ["Bio"]
	},

	"Dy": {
		"name": "Disprosio",
		"number": 66,
		"category": "Lantanide",
		"group": 12,
		"period": 9,
		"image": "res://Images/STEAM Women/Dian Fossey.jpg",
		"scientist_name": "Dian Fossey",
		"profession": "Primatologa",
		"brief_subtitle": "Protettrice dei gorilla di montagna",
		"year": "1932 - 1985",
		"nationality": "Americana",
		"description": "Primatologa americana che dedicò la vita allo studio e alla protezione dei gorilla in Ruanda. Fondò il Karisoke Research Center (1967) e combatté il bracconaggio fino al suo assassinio nel 1985. Il suo lavoro ispirò il film *Gorilla nella nebbia*.",
		"awards": "",
		"quote": "Quando ti rendi conto del valore di tutta la vita, ti concentri sulla conservazione del futuro.",
		"links": ["<https://en.wikipedia.org/wiki/Dian_Fossey>"],
		"profession_keys": ["Bio", "Hum"]
	},

	"Ho": {
		"name": "Olmio",
		"number": 67,
		"category": "Lantanide",
		"group": 13,
		"period": 9,
		"image": "res://Images/STEAM Women/Hope Jahren.jpg",
		"scientist_name": "Hope Jahren",
		"profession": "Geobiologa",
		"brief_subtitle": "Voce della crisi climatica",
		"year": "1969 - ",
		"nationality": "Americana",
		"description": "Geobiologa americana, autrice di *Lab Girl* (2016) e *The Story of More* (2020). Studia l’impatto umano sul clima attraverso l’analisi degli isotopi nelle piante, unendo ricerca scientifica e divulgazione accessibile.",
		"awards": "",
		"quote": "Lavorare in un laboratorio significa ogni giorno chiedere al mondo qualcosa che non ha mai chiesto prima...",
		"links": ["<https://en.wikipedia.org/wiki/Hope_Jahren>"],
		"profession_keys": ["Bio"],
	},
	"Er": {
		"name": "Erbio",
		"number": 68,
		"category": "Lantanide",
		"group": 14,
		"period": 9,
		"image": "res://Images/STEAM Women/Erika Cremer.jpg",
		"scientist_name": "Erika Cremer",
		"profession": "Chimica e Fisica",
		"brief_subtitle": "Pioniera della cromatografia a gas",
		"year": "1900 - 1996",
		"nationality": "Tedesca",
		"description": "Chimica fisica tedesca che sviluppò la cromatografia a gas nel 1944, tecnica rivoluzionaria per l'analisi chimica. Nonostante il suo lavoro sia stato inizialmente ignorato a causa del genere, è oggi riconosciuta come una delle figure chiave della chimica analitica del XX secolo. Professoressa all'Università di Innsbruck, dedicò la vita alla ricerca scientifica.",
		"awards": "",
		"quote": "La scienza avanza grazie alla perseveranza di chi osa esplorare l'invisibile.",
		"links": ["<https://en.wikipedia.org/wiki/Erika_Cremer>"],
		"profession_keys": ["Phy", "Chem"],
	},

	"Tm": {
		"name": "Tulio",
		"number": 69,
		"category": "Lantanide",
		"group": 15,
		"period": 9,
		"image": "res://Images/STEAM Women/Margaret Todd.jpg",
		"scientist_name": "Margaret Todd",
		"profession": "Medica e Scrittrice",
		"brief_subtitle": "Ideatrice del termine 'isotopo'",
		"year": "1859 - 1918",
		"nationality": "Scozzese",
		"description": "Medica e scrittrice scozzese che coniò il termine *isotopo* nel 1913, suggerendolo a Frederick Soddy durante i suoi studi sulla radioattività. Autrice del romanzo *Mona Maclean, Medical Student* (1892), ispirato alla sua esperienza in medicina. Fu una figura poliedrica, impegnata anche per i diritti delle donne nella scienza.",
		"awards": "",
		"quote": "La scoperta della verità non è nelle mani di uno solo, ma nella collaborazione di molti.",
		"links": ["<https://en.wikipedia.org/wiki/Margaret_Todd_(doctor)>"],
		"profession_keys": ["Med", "Hum"],
	},

	"Yb": {
		"name": "Itterbio",
		"number": 70,
		"category": "Lantanide",
		"group": 16,
		"period": 9,
		"image": "res://Images/STEAM Women/Yvonne Choquet-Bruhat.jpg",
		"scientist_name": "Yvonne Choquet-Bruhat",
		"profession": "Matematica e Fisica",
		"brief_subtitle": "Decifratrice delle equazioni di Einstein",
		"year": "1923 - 2023",
		"nationality": "Francese",
		"description": "Matematica e fisica francese, prima donna eletta all'Académie des Sciences (1979). Risolse le equazioni di Einstein della relatività generale, dimostrando l'esistenza di soluzioni per lo spazio-tempo. Insegnò a Princeton e all'IHÉS, influenzando la cosmologia e la fisica matematica moderna.",
		"awards": "Premio Dannie Heineman (2003), Grande Médaille de l'Académie des Sciences (2015)",
		"quote": "Volevo comprendere le leggi fondamentali della fisica con rigore matematico.",
		"links": ["<https://en.wikipedia.org/wiki/Yvonne_Choquet-Bruhat>"],
		"profession_keys": ["Phy", "Mat"],
	},
	"Lu": {
		"name": "Lutezio",
		"number": 71,
		"category": "Lantanide",
		"group": 17,
		"period": 9,
		"image": "res://Images/STEAM Women/Lynn Margulis.jpg",
		"scientist_name": "Lynn Margulis",
		"profession": "Biologa evoluzionista",
		"brief_subtitle": "Teorica dell'endosimbiosi",
		"year": "1938 - 2011",
		"nationality": "Statunitense",
		"description": "Biologa americana rivoluzionaria, propose la teoria endosimbiotica (1967), dimostrando che mitocondri e cloroplasti derivano da batteri antichi. Collaborò con James Lovelock sulla teoria di Gaia e sfidò il paradigma darwiniano, enfatizzando la cooperazione nell'evoluzione. Vincitrice del Premio Darwin-Wallace (1999).",
		"awards": "Premio Darwin-Wallace (1999), National Medal of Science (1999)",
		"quote": "L’essere umano si crede invincibile, invulnerabile. Niente di più lontano dalla realtà.",
		"links": ["<https://en.wikipedia.org/wiki/Lynn_Margulis>"],
		"profession_keys": ["Bio"],
	},

	# Attinidi (periodo fittizio 10, gruppo 3-18)
	"Ac": {
		"name": "Attinio",
		"number": 89,
		"category": "Attinide",
		"group": 3,
		"period": 10,
		"image": "res://Images/STEAM Women/Alice Catherine Evans.jpg",
		"scientist_name": "Alice Catherine Evans",
		"profession": "Microbiologa",
		"brief_subtitle": "Salvatrice del latte sicuro",
		"year": "1881 - 1975",
		"nationality": "Statunitense",
		"description": "Microbiologa statunitense che identificò il Bacillus abortus come causa della brucellosi, portando alla pastorizzazione obbligatoria del latte. Prima donna a ottenere una borsa di studio in batteriologia all’Università del Wisconsin, rivoluzionò la sicurezza alimentare globale.",
		"awards": "",
		"quote": "La rotta che era aperta per la navigazione della mia nave era nel complesso gratificante. Il percorso a volte è stato difficile, ma c'erano tratti di navigazione libera.",
		"links": ["<https://en.wikipedia.org/wiki/Alice_Catherine_Evans>"],
		"profession_keys": ["Bio"],
	},
	"Th": {
		"name": "Torio",
		"number": 90,
		"category": "Attinide",
		"group": 4,
		"period": 10,
		"image": "res://Images/STEAM Women/Thelma Estrin.jpg",
		"scientist_name": "Thelma Estrin",
		"profession": "Informatica e Ingegnere biomedica",
		"brief_subtitle": "Pioniera dell’informatica medica",
		"year": "1924 - 2014",
		"nationality": "Americana",
		"description": "Informatica americana che integrò l’IA nell’assistenza sanitaria, sviluppando sistemi esperti per analisi mediche. Prima donna a dirigere il Dipartimento di Ingegneria Biomedica all’UCLA, promosse l’inclusione femminile nella tecnologia.",
		"awards": "",
		"quote": "Bisogna ampliare l'accesso delle donne alla tecnologia, rompendo la storia patriarcale della scienza.",
		"links": ["<https://en.wikipedia.org/wiki/Thelma_Estrin>"],
		"profession_keys": ["Eng","Med"],
	},
	"Pa": {
		"name": "Protoattinio",
		"number": 91,
		"category": "Attinide",
		"group": 5,
		"period": 10,
		"image": "res://Images/STEAM Women/Patricia Cowings.jpg",
		"scientist_name": "Patricia Cowings",
		"profession": "Psicofisiologa aerospaziale",
		"brief_subtitle": "Addestratrice di astronauti",
		"year": "1948 - ",
		"nationality": "Americana",
		"description": "Psicofisiologa afroamericana pioniera alla NASA, sviluppò tecniche di biofeedback per contrastare il mal di spazio. Prima donna nera formata come astronauta, le sue ricerche migliorarono l’adattamento umano alle missioni spaziali.",
		"awards": "",
		"quote": "Se puoi imparare a controllare il tuo corpo, puoi adattarti a quasi tutto.",
		"links": ["<https://en.wikipedia.org/wiki/Patricia_Cowings>"],
		"profession_keys": ["Med", "Hum", "Astro"],
	},
	"U": {
		"name": "Uranio",
		"number": 92,
		"category": "Attinide",
		"group": 6,
		"period": 10,
		"image": "res://Images/STEAM Women/Ursula Franklin.jpg",
		"scientist_name": "Ursula Franklin",
		"profession": "Fisica e Attivista",
		"brief_subtitle": "Paladina della tecnologia etica",
		"year": "1921 - 2016",
		"nationality": "Canadese",
		"description": "Fisica canadese di origine tedesca, pioniera nello studio degli impatti sociali della tecnologia. Denunciò i rischi delle armi nucleari e promosse un uso sostenibile dell’energia. Prima donna professoressa di ingegneria a Toronto.",
		"awards": "Order of Canada (1981)",
		"quote": "La pace non è l'assenza di guerra, la pace è l'assenza di paura.",
		"links": ["<https://en.wikipedia.org/wiki/Ursula_Franklin>"],
		"profession_keys": ["Hum","Phy"],
	},
	"Np": {
		"name": "Nettunio",
		"number": 93,
		"category": "Attinide",
		"group": 7,
		"period": 10,
		"image": "res://Images/STEAM Women/Nathalie Picqué.jpg",
		"scientist_name": "Nathalie Picqué",
		"profession": "Fisica quantistica",
		"brief_subtitle": "Maestra della metrologia quantistica",
		"year": "1973 - ",
		"nationality": "Francese",
		"description": "Fisica francese che rivoluzionò la precisione delle misurazioni con tecniche quantistiche. Direttrice al Max Planck Institute, il suo lavoro ha applicazioni in telecomunicazioni e energia pulita.",
		"awards": "Premio Fresnel (2019)",
		"quote": "La precisione nelle misurazioni è la chiave per comprendere l'universo.",
		"links": ["<https://en.wikipedia.org/wiki/Nathalie_Picqu%C3%A9>"],
		"profession_keys": ["Phy"]
	},
	"Pu": {
		"name": "Plutonio",
		"number": 94,
		"category": "Attinide",
		"group": 8,
		"period": 10,
		"image": "res://Images/STEAM Women/Purnima Sinha.jpg",
		"scientist_name": "Purnima Sinha",
		"profession": "Fisica ambientale",
		"brief_subtitle": "Difensora della sostenibilità",
		"year": "1927 - 2015",
		"nationality": "Indiana",
		"description": "Fisica indiana pioniera nello studio di materiali sostenibili e soluzioni per il cambiamento climatico. Ricercatrice al Tata Institute, unì scienza e attivismo per la tutela delle risorse naturali.",
		"awards": "",
		"quote": "La scienza deve creare un futuro sostenibile per le prossime generazioni.",
		"links": ["<https://en.wikipedia.org/wiki/Purnima_Sinha>"],
		"profession_keys": ["Phy", "Bio"]
	},
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
		"description": "Emmy Noether è stata una matematica tedesca nota per il suo contributo all'algebra astratta e alla fisica teorica. Il suo teorema ha rivoluzionato la comprensione delle simmetrie in fisica. Nonostante le difficoltà dovute alla discriminazione di genere, ha lasciato un'eredità fondamentale nella matematica e nella fisica.",
		"awards": "Premio Ackermann-Teubner (1932)",
		"quote": "La matematica non è solo un mezzo per risolvere problemi, ma un linguaggio attraverso cui possiamo comprendere la struttura profonda della realtà.",
		"links": ["https://en.wikipedia.org/wiki/Emmy_Noether", "https://mathshistory.st-andrews.ac.uk/Biographies/Noether/"],
		"profession_keys": ["Phy", "Mat"],
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
		"brief_subtitle": "Prima donna nobel, madre della radioattività", 
		"year": "1867 - 1934", 
		"nationality": "Polacca-Francese", 
		"description": "Maria Skłodowska Curie è stata una scienziata rivoluzionaria, pioniera degli studi sulla radioattività. Prima persona a vincere due Premi Nobel in discipline scientifiche diverse, ha scoperto il radio e il polonio e ha contribuito allo sviluppo della medicina e della fisica nucleare.",
		"awards": "Premio Nobel per la Fisica (1903), Premio Nobel per la Chimica (1911)",
		"quote": "Niente nella vita è da temere, è solo da comprendere. Ora è il momento di comprendere di più, affinché possiamo temere di meno.",
		"links": [
			"https://en.wikipedia.org/wiki/Marie_Curie",
			"https://www.nobelprize.org/prizes/physics/1903/curie/biographical/"
		],
		"profession_keys": ["Phy", "Chem"]
	},
	"Bk": {
		"name": "Berkelio",
		"number": 97,
		"category": "Attinide",
		"group": 11,
		"period": 10,
		"image": "res://Images/STEAM Women/Barbara McClintock.jpg",
		"scientist_name": "Barbara McClintock",
		"profession": "Biologa",
		"brief_subtitle": "Scopritrice dei 'geni che saltano'",
		"year": "1902 - 1992",
		"nationality": "Statunitense",
		"description": "Biologa statunitense premio Nobel per la Medicina (1983) per la scoperta dei trasposoni, segmenti di DNA mobili che rivoluzionarono la genetica. Il suo lavoro pionieristico, inizialmente osteggiato, dimostrò che il genoma non è statico ma dinamico.",
		"awards": "Premio Nobel per la Medicina (1983)",
		"quote": "Bisogna sempre credere alle nostre osservazioni, per quanto bizzarre possano essere. Forse stanno cercando di dirci qualcosa.",
		"links": ["<https://en.wikipedia.org/wiki/Barbara_McClintock>"],
		"profession_keys": ["Med", "Bio"],
	},
	"Cf": {
		"name": "Californio",
		"number": 98,
		"category": "Attinide",
		"group": 12,
		"period": 10,
		"image": "res://Images/STEAM Women/Chaterine Feuillet.jpg",
		"scientist_name": "Catherine Feuillet",
		"profession": "Genetista delle piante",
		"brief_subtitle": "Mappatrice del genoma del grano",
		"year": "1965 - ",
		"nationality": "Francese",
		"description": "Genetista francese che ha guidato il sequenziamento del genoma del frumento, aprendo la strada a colture resistenti ai cambiamenti climatici. Direttrice scientifica di aziende agrotech, il suo lavoro è cruciale per la sicurezza alimentare globale.",
		"awards": "",
		"quote": "La genetica è la chiave per nutrire il futuro.",
		"links": ["<https://en.wikipedia.org/wiki/Catherine_Feuillet>"],
		"profession_keys": ["Bio"],
	},
	"Es": {
		"name": "Einsteinio",
		"number": 99,
		"category": "Attinide",
		"group": 13,
		"period": 10,
		"image": "res://Images/STEAM Women/Esther Lederberg.jpg",
		"scientist_name": "Esther Lederberg",
		"profession": "Microbiologa e Genetista",
		"brief_subtitle": "Pioniera della genetica batterica",
		"year": "1922 - 2006",
		"nationality": "Statunitense",
		"description": "Microbiologa americana scopritrice del batteriofago lambda e inventrice del replica plating, tecnica per studiare mutazioni genetiche. Nonostante il marito Joshua Lederberg abbia vinto il Nobel, il suo contributo fu a lungo ignorato.",
		"awards": "",
		"quote": "La scienza avanza con piccoli passi, e ogni scoperta è un tassello fondamentale per comprendere il mondo che ci circonda.",
		"links": ["<https://en.wikipedia.org/wiki/Esther_Lederberg>"],
		"profession_keys": ["Bio"],
	},
	"Fm": {
		"name": "Fermio",
		"number": 100,
		"category": "Attinide",
		"group": 14,
		"period": 10,
		"image": "res://Images/STEAM Women/Fay Ajzenberg-Selove.jpg",
		"scientist_name": "Fay Ajzenberg-Selove",
		"profession": "Fisica Nucleare",
		"brief_subtitle": "Esploratrice dei nuclei atomici",
		"year": "1926 - 2012",
		"nationality": "Statunitense",
		"description": "Fisica nucleare statunitense che mappò le proprietà dei nuclei leggeri, contribuendo alla comprensione della fusione stellare e della nucleosintesi. Professoressa all’Università della Pennsylvania, sfidò le barriere di genere nella fisica teorica.",
		"awards": "",
		"quote": "La passione per la scienza ci spinge a scoprire l'invisibile e a comprendere l'universo.",
		"links": ["<https://en.wikipedia.org/wiki/Fay_Ajzenberg-Selove>"],
		"profession_keys": ["Bio", "Hum"]
	},
	"Md": {
		"name": "Mendelevio",
		"number": 101,
		"category": "Attinide",
		"group": 15,
		"period": 10,
		"image": "res://Images/STEAM Women/Maud Menten.jpg",
		"scientist_name": "Maud Menten",
		"profession": "Biochimica",
		"brief_subtitle": "Pioniera della cinetica enzimatica",
		"year": "1879 - 1960",
		"nationality": "Canadese",
		"description": "Biochimica canadese che rivoluzionò lo studio degli enzimi sviluppando, con Leonor Michaelis, l'equazione di Michaelis-Menten. Questo modello descrive la velocità delle reazioni enzimatiche e rimane un pilastro della biochimica moderna. Contribuì anche alla comprensione del metabolismo cellulare, superando le barriere di genere nella scienza del XX secolo.",
		"awards": "",
		"quote": "La chimica è il ponte che collega la biologia alla fisica.",
		"links": ["<https://en.wikipedia.org/wiki/Maud_Menten>"],
		"profession_keys": ["Chem", "Bio"],
	},

	"No": {
		"name": "Nobelio",
		"number": 102,
		"category": "Attinide",
		"group": 16,
		"period": 10,
		"image": "res://Images/STEAM Women/Noreen Murray.jpg",
		"scientist_name": "Noreen Murray",
		"profession": "Biochimica e Genetista Molecolare",
		"brief_subtitle": "Architetta del DNA ricombinante",
		"year": "1935 - 2011",
		"nationality": "Inglese",
		"description": "Biochimica britannica pioniera nell'ingegneria genetica. Sviluppò vettori di DNA ricombinante fondamentali per la terapia genica e la biotecnologia. Il suo lavoro ha permesso progressi nella produzione di farmaci biologici e nella ricerca biomedica.",
		"awards": "",
		"quote": "La scienza è una porta aperta verso l’innovazione, e ogni scoperta è un passo avanti per migliorare il mondo.",
		"links": ["<https://en.wikipedia.org/wiki/Noreen_Murray>"],
		"profession_keys": ["Chem", "Bio"],
	},
	"Lr": {
		"name": "Laurenzio",
		"number": 103,
		"category": "Attinide",
		"group": 17,
		"period": 10,
		"image": "res://Images/STEAM Women/Mary Leakey.jpg",
		"scientist_name": "Mary Leakey",
		"profession": "Archeologa e Paleontologa",
		"brief_subtitle": "Scopritrice delle impronte di Laetoli",
		"year": "1913 - 1996",
		"nationality": "Britannica",
		"description": "Archeologa britannica che scoprì le impronte fossili di Laetoli (Tanzania, 1978), risalenti a 3,6 milioni di anni fa. Queste impronte dimostrarono che gli ominidi camminavano eretti molto prima del previsto, rivoluzionando la comprensione dell'evoluzione umana.",
		"awards": "",
		"quote": "Le ossa raccontano la storia dell’umanità, dobbiamo solo imparare ad ascoltarle.",
		"links": ["<https://en.wikipedia.org/wiki/Mary_Leakey>"],
		"profession_keys": ["Bio", "Hum"]
	},
	"4B Licei SGF": {
		"name": "", 
		"category": "Credits", 
		"group": 1, 
		"period": 10,
	},
}
#Database colori degli elementi
var themes = {
	"default": {
		"Category": {
			"1": Color(0.5, 0, 0.5),
			"2": Color(0.6, 0, 0.8),
			"3": Color(0.8, 0, 0.8),
			"4": Color(0.9, 0, 0.7),
			"5": Color(1, 0, 0.6),
			"6": Color(1, 0.3, 0.5),
			"7": Color(1, 0.5, 0.4),
			"8": Color(1, 0.6, 0.3),
		},
		"Credits": Color.ROYAL_BLUE,
		"F-Block": Color.SLATE_GRAY.darkened(0.12),
		"Metallo alcalino": Color("#F2334C"),
		"Metallo alcalino-terroso": Color("#EF5F45"),
		"Metallo di transizione": Color("#EB8B3D"),  
		"Metallo post-transizionale": Color("#E2BC48"),  
		"Metalloide": Color("86D855"),
		"Non metallo": Color("#51D661"),
		"Alogeno": Color("19CCCC"),
		"Gas nobile": Color("#19BFFF"),
		"Lantanide": Color(0.3, 0.3, 1.0),
		"Attinide": Color(0.5, 0.1, 0.9),
		"Sconosciuto": Color.SLATE_GRAY,
		"Background": "default"
	},
	"plain": {
		"Category": {
			"1": Color(0.5, 0, 0.5),
			"2": Color(0.6, 0, 0.8),
			"3": Color(0.8, 0, 0.8),
			"4": Color(0.9, 0, 0.7),
			"5": Color(1, 0, 0.6),
			"6": Color(1, 0.3, 0.5),
			"7": Color(1, 0.5, 0.4),
			"8": Color(1, 0.6, 0.3),
		},
		"Credits": Color.ROYAL_BLUE,
		"F-Block": Color.SLATE_GRAY.darkened(0.12),
		"Metallo alcalino": Color("#F2334C"),
		"Metallo alcalino-terroso": Color("#EF5F45"),
		"Metallo di transizione": Color("#EB8B3D"),  
		"Metallo post-transizionale": Color("#E2BC48"),  
		"Metalloide": Color("86D855"),
		"Non metallo": Color("#51D661"),
		"Alogeno": Color("19CCCC"),
		"Gas nobile": Color("#19BFFF"),
		"Lantanide": Color(0.3, 0.3, 1.0),
		"Attinide": Color(0.5, 0.1, 0.9),
		"Sconosciuto": Color.SLATE_GRAY,
		"Background": Color("#9995ff")
	},
	#"light": {
		#"Category": {
			#"1": Color(0.5, 0, 0.5),
			#"2": Color(0.6, 0, 0.8),
			#"3": Color(0.8, 0, 0.8),
			#"4": Color(0.9, 0, 0.7),
			#"5": Color(1, 0, 0.6),
			#"6": Color(1, 0.3, 0.5),
			#"7": Color(1, 0.5, 0.4),
			#"8": Color(1, 0.6, 0.3),
		#},
		#"Credits": Color(0.2, 0.3, 0.8),
		#"F-Block": Color.SLATE_GRAY.darkened(0.12),
		#"Metallo alcalino": Color("#D02040"),
		#"Metallo alcalino-terroso": Color("#DD533A"),
		#"Metallo di transizione": Color("#E06E30"),
		#"Metallo post-transizionale": Color("#D1A832"),
		#"Metalloide": Color("#6ADD55"),
		#"Non metallo": Color("#32D87C"),
		#"Alogeno": Color("#1ACCCC"),
		#"Gas nobile": Color("#1ABFFF"),
		#"Lantanide": Color(0.3, 0.3, 0.8),
		#"Attinide": Color(0.5, 0.2, 0.7),
		#"Sconosciuto": Color("#888888"),
		#"Background": Color(1, 1, 1)
	#},
	#"dark": {
		#"Category": {
			#"1": Color(0.5, 0, 0.5),
			#"2": Color(0.6, 0, 0.8),
			#"3": Color(0.8, 0, 0.8),
			#"4": Color(0.9, 0, 0.7),
			#"5": Color(1, 0, 0.6),
			#"6": Color(1, 0.3, 0.5),
			#"7": Color(1, 0.5, 0.4),
			#"8": Color(1, 0.6, 0.3),
		#},
		#"Credits": Color(0.5, 0.6, 1),
		#"F-Block": Color("#596759"),
		#"Metallo alcalino": Color("#F2334C"),
		#"Metallo alcalino-terroso": Color("#EF5F45"),
		#"Metallo di transizione": Color("#EB8B3D"),
		#"Metallo post-transizionale": Color("#E2BC48"),
		#"Metalloide": Color("#86D855"),
		#"Non metallo": Color("#4CD866"),
		#"Alogeno": Color("#19CCCC"),
		#"Gas nobile": Color("#19BFFF"),
		#"Lantanide": Color(0.3, 0.3, 1.0),
		#"Attinide": Color(0.5, 0.1, 0.9),
		#"Sconosciuto": Color("#444444"),
		#"Background": Color(0.08, 0.08, 0.08)
	#},
	"pastel": {
		"Category": {
			"1": Color("#D9A5D9"),
			"2": Color("#E5A5E5"),
			"3": Color("#E8A5E8"),
			"4": Color("#F5B3DD"),
			"5": Color("#F9B6C5"),
			"6": Color("#FFC2C2"),
			"7": Color("#FFD6AA"),
			"8": Color("#FFE5AA"),
		},
		"Credits": Color("#A5A5FF"),
		"F-Block": Color("#B3C2A3"),
		"Metallo alcalino": Color("#F9B0B5"),
		"Metallo alcalino-terroso": Color("#F9C2A5"),
		"Metallo di transizione": Color("#FAD9B6"),
		"Metallo post-transizionale": Color("#FBEAB5"),
		"Metalloide": Color("#C4F1B8"),
		"Non metallo": Color("#B3F7C5"),
		"Alogeno": Color("#B0E5E5"),
		"Gas nobile": Color("#B0EBF9"),
		"Lantanide": Color("#A5A5FF"),
		"Attinide": Color("#C3A5F9"),
		"Sconosciuto": Color("#9CA6C1"),
		"Background": Color("#EDE8DC"),
		"Font": Color("A87676")  
	},
	"majlinda": {
		"Category": {
			"1": Color(0.3, 0, 0.3),
			"2": Color(0.4, 0, 0.6),
			"3": Color(0.5, 0, 0.5),
			"4": Color(0.6, 0, 0.4),
			"5": Color(0.7, 0, 0.3),
			"6": Color(0.7, 0.2, 0.3),
			"7": Color(0.7, 0.3, 0.2),
			"8": Color(0.7, 0.4, 0.1),
		},
		"Credits": Color.ROYAL_BLUE,  # Blu spento
		"F-Block": Color.GRAY,
		"Metallo alcalino": Color("f3a7a7"),
		"Metallo alcalino-terroso": Color("#e8c7c1"),
		"Metallo di transizione": Color("#F2C854"),
		"Metallo post-transizionale": Color("#EAED9C"),
	 	"Metalloide": Color("#b3ddca"),
		"Non metallo": Color("#9dd0ee"),
		"Alogeno": Color("#90beec"),
		"Gas nobile": Color("#83ace9"),
		"Lantanide": Color("#b7b1f8"),
		"Attinide": Color("#ecb4ed"),
		"Sconosciuto": Color("7D8BBC"),
		"Background": Color("#F8F7D6"),
	},
	"fabrizio": {
		"Category": {
			"1": Color("#FF6A0B"),
			"2": Color("E85157"),
			"3": Color("D138A3"),
			"4": Color("A224E0"),
			"5": Color("6647E0"),
			"6": Color("2A6AE0"),
			"7": Color("10B8C2"),
			"8": Color("03CDB9"),
		},
		"Credits": Color.ROYAL_BLUE,
		"F-Block": Color("#49495B"),
		"Metallo alcalino": Color("#333399"),
		"Metallo alcalino-terroso": Color("#4D2DA0"),
		"Metallo di transizione": Color("#6627A6"),  
		"Metallo post-transizionale": Color("#8021AD"),  
		"Metalloide": Color("#991AB3"),
		"Non metallo": Color("#B314BA"),
		"Alogeno": Color("#CC0DC0"),
		"Gas nobile": Color("#FF00CC"),
		"Lantanide": Color("#991AB3"),
		"Attinide": Color("#6627A6"),
		"Sconosciuto": Color("#5A445F"),
		"Background": Color.MIDNIGHT_BLUE.darkened(0.6),
	}
}

var prof_to_key = {
	"Phy": "1",
	"Astro": "2",
	"Chem": "3",
	"Bio": "4",
	"Mat": "5",
	"Eng": "6",
	"Med": "7",
	"Hum": "8",
}

func set_new_theme(theme_name: String):
	if themes.has(theme_name):
		current_theme = themes[theme_name]

func desaturate_colors_in_place(amount: float) -> void:
		for key in current_theme.keys():
			if key != "Category" and  key != "TitleFont" and key!= "Background":
				current_theme[key] = current_theme[key].lerp(Color.LIGHT_GRAY, amount)

func darken_colors_in_place(amount: float) -> void:
	for key in current_theme.keys():
		if key != "Category" and  key != "TitleFont" and key!= "Background":
			current_theme[key] = current_theme[key].darkened(amount)

func lighten_colors_in_place(amount: float) -> void:
	for key in current_theme.keys():
		if key != "Category" and  key != "TitleFont" and key!= "Background":
			current_theme[key] = current_theme[key].lightened(amount)

func _input(event):
	if event is InputEventMouseButton:
		reset_all_colors()
		if event.pressed and popup_panel.visible and popup_margin.visible:
			if not popup_panel.get_global_rect().has_point(get_global_mouse_position()):
				popup_panel.visible = false
				popup_margin.visible = false
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			elements_animation(grid_container)
			reset_all_colors()
		if event.keycode == KEY_T:
			change_theme()

func change_theme():
		# Incrementa l'indice e cicla
	current_theme_index = (current_theme_index + 1) % theme_names.size()
	# Ottieni il nome del tema all'indice corrente
	var next_theme_name = theme_names[current_theme_index]
	# Applica il nuovo tema
	set_new_theme(next_theme_name)
	change_bg(next_theme_name)
	precompute_styles()
	reset_all_colors()

func change_bg(new_theme):
	if not themes.has(new_theme):
		return
	var bg_value = current_theme["Background"]
	solid_bg.global_position = Vector2(-size.x/2, -size.y/2)
	if bg_value is not String:
		moving_bg.visible = false
		solid_bg.color = current_theme["Background"]
	else:
		moving_bg.visible = true
		solid_bg.color = Color("9995ff")

func _ready() -> void:
	moving_bg.visible = true
	solid_bg.visible = true
	timer.connect("timeout",reset_all_colors)
	await get_tree().process_frame
	center_table()
	grid_container.resized.connect(center_table)
	calculate_scale_factor()
	change_bg(default_theme)
	screen_size = get_viewport_rect().size
	create_periodic_table()
	control_element_container.queue_free()
	popup_panel.visible = false 
	popup_margin.visible = false 

func center_table():
	var container_size = grid_container.get_combined_minimum_size()
	var offset_x = 0
	grid_container.anchor_left = 0.5
	grid_container.anchor_top = 0.5
	grid_container.anchor_right = 0.5
	grid_container.anchor_bottom = 0.5
	grid_container.offset_left = -container_size.x / 2 + offset_x
	grid_container.offset_top = -container_size.y / 2
	grid_container.offset_right = container_size.x / 2 
	grid_container.offset_bottom = container_size.y / 2

func calculate_scale_factor():
	# Dimensione di riferimento (la dimensione originale dello schermo per cui è stato progettato)
	var reference_width = 1152.0  # Ad esempio, se hai progettato per 1920x1080
	var reference_height = 648.0
	
	# Calcola il fattore di scala orizzontale e verticale
	var width_scale = screen_size.x / reference_width
	var height_scale = screen_size.y / reference_height
	
	# Usa il minore tra i due per mantenere le proporzioni
	scale_factor = min(width_scale, height_scale)
	screen_size = get_viewport_rect().size
	# Aggiorna btn_size in base al fattore di scala
	btn_size = int(60 * scale_factor)  # 60 è la tua dimensione originale dei bottoni

func create_periodic_table():
	var total_elements = elements.size()
	var elements_created = 0
	grid_container.columns = groups + 1  # +1 per la colonna dei periodi a sinistra
	# Prima riga: numeri dei gruppi (con uno spazio iniziale vuoto)
	grid_container.add_child(Control.new())  # Spazio vuoto per allineare i numeri dei gruppi
	for i in range(groups):
		var group_label = Label.new()
		group_label.text = str(i + 1)
		group_label.custom_minimum_size = Vector2(btn_size, 10)
		group_label.size = Vector2(btn_size, 10)
		group_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		group_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid_container.add_child(group_label)
		group_label.add_theme_font_override("font", load("res://Fonts/Gravity-Bold.otf"))
		group_label.add_theme_font_size_override("font_size", 17)
		group_label.add_theme_color_override("font_color", Color.LIGHT_GRAY)
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
			period_label.custom_minimum_size = Vector2(10, btn_size)
			period_label.size = Vector2(10, btn_size)
			period_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			period_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		grid_container.add_child(period_label)
		period_label.add_theme_font_override("font", load("res://Fonts/Gravity-Bold.otf"))
		period_label.add_theme_font_size_override("font_size", 17)
		period_label.add_theme_color_override("font_color", Color.LIGHT_GRAY)
		# Aggiungiamo gli elementi della riga
		for symbol in table_layout[i]:
			if symbol == null:
				# Spazio vuoto per mantenere la struttura della tavola
				var empty = Control.new()
				empty.custom_minimum_size = Vector2(btn_size/3.0, btn_size/3.0)
				empty.size = Vector2(btn_size/3.0, btn_size/3.0)
				grid_container.add_child(empty)
			else:
				# Crea il bottone per l'elemento
				var element = elements[symbol]
				var btn = Button.new()
				var lbl = Label.new()
				var nm_lbl = Label.new()
				var element_container = Control.new()
				if "number" in element:
					lbl.text = str(element["number"])
				lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
				lbl.vertical_alignment = VERTICAL_ALIGNMENT_TOP
				lbl.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
				lbl.add_theme_font_override("font", load("res://Fonts/Gravity-Bold.otf"))
				lbl.add_theme_font_size_override("font_size", 14)
				lbl.z_index = 2
				nm_lbl.text = str(element["name"])
				nm_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				nm_lbl.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
				nm_lbl.add_theme_constant_override("line_spacing", -5)
				nm_lbl.add_theme_font_override("font", load("res://Fonts/texgyreheroscn-bold.otf"))
				nm_lbl.add_theme_font_size_override("font_size", 12)
				#if "scientist_name" in element:
					#var first_word = str(element["scientist_name"]).split(" ")[0]
					#nm_lbl.text = first_word
					#nm_lbl.add_theme_font_size_override("font_size", 14)
				if element["category"] == "Category":
					nm_lbl.add_theme_font_size_override("font_size", 13)
					nm_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				nm_lbl.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
				nm_lbl.set_offset(SIDE_BOTTOM, 2) 
				nm_lbl.z_index = 3
				btn.text = symbol
				btn.custom_minimum_size = Vector2(btn_size, btn_size)
				btn.size = Vector2(btn_size, btn_size)
				btn.autowrap_mode = 2
				btn.pressed.connect(on_element_selected.bind(symbol, element_container, grid_container))
				btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
				btn.focus_mode = Control.FOCUS_NONE
				btn.add_theme_font_override("font", load("res://Fonts/texgyreheros-bold.otf"))
				if not "number" in element:
					btn.add_theme_font_size_override("font_size", 18)
					if element["category"] == "Title":
						btn.add_theme_font_size_override("font_size", 30)
				else:
					btn.add_theme_font_size_override("font_size", 25)
				btn.pivot_offset = btn.size/2
				element_container.custom_minimum_size = Vector2(btn_size, btn_size)
				element_container.size = Vector2(btn_size, btn_size)
				element_container.scale = Vector2(0,0)
				element_container.add_child(lbl)
				element_container.add_child(nm_lbl)
				element_container.add_child(btn)
				element_container.pivot_offset = btn.size/2
				var style = StyleBoxFlat.new()
				if style:
					style.set_corner_radius_all(radius)
					style.set_expand_margin_all(margin)
					style.border_color = Color.ANTIQUE_WHITE

					if "Font" in current_theme:
						btn.add_theme_color_override("font_color", current_theme["Font"])
						lbl.add_theme_color_override("font_color", current_theme["Font"])
						nm_lbl.add_theme_color_override("font_color", current_theme["Font"])
						btn.add_theme_color_override("font_hover_color", current_theme["Font"])
						lbl.add_theme_color_override("font_hover_color", current_theme["Font"])
						nm_lbl.add_theme_color_override("font_hover_color", current_theme["Font"])
					else:
						btn.add_theme_color_override("font_color", default_font_color)
						lbl.add_theme_color_override("font_color", default_font_color)
						nm_lbl.add_theme_color_override("font_color", default_font_color)
						btn.add_theme_color_override("font_hover_color", default_font_color)
						lbl.add_theme_color_override("font_hover_color", default_font_color)
						nm_lbl.add_theme_color_override("font_hover_color", default_font_color)
					if element["category"] == "Category":
						category_counter = (category_counter % 8) + 1  # Cicla da 1 a 8
						style.bg_color = current_theme["Category"][str(category_counter)]
					else:
						style.bg_color = current_theme[element["category"]]
					btn.add_theme_stylebox_override("normal", style)
					btn.add_theme_stylebox_override("hover", style)
					element_container.add_to_group("elements")
					grid_container.add_child(element_container)
					elements_created += 1
					var piano_pitches = [1.0, 1.12246204831, 1.25992104989, 1.33483985417, 1.49830707688, 1.68179283051, 1.88774862536, 2.0]
					btn.mouse_entered.connect(func():
						if timer.wait_time != 0:
							timer.stop()
							timer.wait_time = 0.5
						var tween = element_container.create_tween()
						if element["category"] != "Category":
							var base_color = current_theme[element["category"]]
							var hover_color = base_color.darkened(0.2)
							element_hovering_audio.pitch_scale = randf_range(1.2,1.5)
							element_hovering_audio.play()
							style.bg_color = hover_color
						else:
							var key = prof_to_key.get(symbol)
							var base_color = current_theme["Category"].get(key, Color.WHITE)
							if piano_key == piano_pitches.size():
								piano_key = 0
							element_hovering_audio.pitch_scale = piano_pitches[piano_key]
							element_hovering_audio.play()
							piano_key += 1
							style.bg_color = base_color
							on_category_selected(symbol)
							#style.bg_color = base_color
						tween.tween_property(element_container, "scale", Vector2(1.1,1.1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					)
					btn.mouse_exited.connect(func():
						var tween = element_container.create_tween()
						if element["category"] != "Category":
							element_hovering_audio.stop()
							style.bg_color = current_theme[element["category"]]
						else:
							timer.start()
						tween.tween_property(element_container, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					)
					if elements_created == total_elements:
						elements_animation(grid_container)

func elements_animation(grid):
	var speed: float = 0.3
	var delay_map := {}
	# Prepara una mappa: key = diagonale (riga + colonna), value = lista di elementi
	for index in grid.get_child_count():
		var element = grid.get_child(index)
		if element.is_in_group("elements"):
			var row = index / (groups + 1)
			var col = index % (groups + 1)
			var diagonal = int(row * 1.5 + col)

			if not delay_map.has(diagonal):
				delay_map[diagonal] = []
			delay_map[diagonal].append(element)

	# Ordina le chiavi delle diagonali
	var sorted_keys = delay_map.keys()
	sorted_keys.sort()

	# Esegui le animazioni per diagonali
	for key in sorted_keys:
		for element in delay_map[key]:
			var tween = element.create_tween().set_trans(Tween.TRANS_CUBIC)
			tween.set_parallel(false)
			tween.tween_property(element, "scale", Vector2(1.4, 1.4), speed)
			tween.tween_property(element, "scale", Vector2(1.0, 1.0), speed)
		await get_tree().create_timer(0.08).timeout
		animation_finished = true

func on_element_selected(symbol, button, grid_container):
	if animation_finished:
		button.scale = Vector2(1.0, 1.0)
		
	if not can_press:
		return

	if selected_button == button:
		selected_button = null
		popup_margin.visible = false 
		popup_panel.visible = false 
		popup_animation(button) 
		return

	selected_button = button
		
	var element = elements[symbol]
	if element["category"] == "F-Block":
		return
	if element["category"] == "Credits":
		return
	if element["category"] == "Category":
		on_category_selected(symbol)
		return
	popup_name_label.text = "Nome: %s\nNumero: %d\nCategoria: %s" % [
		element["name"], element["number"], element["category"]
	]
	if "image" in element:
		var img_texture = load(element["image"])
		popup_image.texture = img_texture

	if "links" in element:
		popup_name_label.text = "" + element["scientist_name"]
		popup_profession_label.text =  "" + element["profession"]
		popup_brief_label.text = "" + element["brief_subtitle"]
		popup_year_label.text = element["year"]
		popup_description_label.text = element["description"]
		popup_quote_label.text = element["quote"]
		popup_nationality_label.text = element["nationality"]
		popup_links_label.text = "\n".join(element["links"]) if "links" in element else ""
		if element["awards"] != "":
			popup_awards_panel.visible =  true
			popup_awards_label.text =  element["awards"]
		else:
			popup_awards_panel.visible =  false
	can_press = false
	calculate_popup_position(button, grid_container)
	popup_margin.visible = true 
	popup_panel.visible = true 
	popup_animation(button) 

	await get_tree().create_timer(0.3).timeout
	can_press = true

	#forza feb sei un mitico scemo de best in de uorld ma come fai a essere cosi bravo ad essere scemo lucA mi ha detto di chiederti se vuoi fare sesso con lui e oliver taigher ti va???? sexting chilling 

func on_category_selected(symbol: String):
	reset_all_colors()
	var matching_symbols := []

	# 1) Trova i simboli che corrispondono alla professione
	for sym in elements.keys():
		var data = elements[sym]
		if data.has("profession_keys") and symbol in data["profession_keys"]:
			matching_symbols.append(sym)
	
	# Prepara un solo StyleBox da riutilizzare
	var key = prof_to_key.get(symbol)
	var color = current_theme["Category"].get(key, Color.WHITE)
	var shared_style = StyleBoxFlat.new()
	var unselected_style = StyleBoxFlat.new()
	shared_style.bg_color = color
	unselected_style.bg_color = Color(0.8, 0.8, 0.8, 0.4)
	shared_style.set_corner_radius_all(radius)
	shared_style.set_expand_margin_all(margin)
	shared_style.set_border_width_all(border)
	unselected_style.set_corner_radius_all(radius)
	unselected_style.set_expand_margin_all(margin)
	# 2) Anima solo i bottoni che corrispondono
	for element_container in grid_container.get_children():
		for child in element_container.get_children():
			if child is Button:
				if child.text in matching_symbols:
					# Applica lo stile condiviso
					child.add_theme_stylebox_override("normal", shared_style)
					# Usa un solo tween per tutti i bottoni
					var tween = create_tween()
					tween.tween_property(child, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
					tween.tween_property(child, "scale", Vector2(1.0, 1.0), 0.05)
				else:
					child.add_theme_stylebox_override("normal", unselected_style)

func animate_button(button):
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.2,1.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(button, "scale", Vector2(1.0,1.0), 0.05)
		
func calculate_popup_position(button, periodic_table_container):
	var horizontal_offset = 5
	var vertical_offset = 10
	
	popup_margin.reset_size()
	button.scale = Vector2(1.0, 1.0)
	
	# Otteniamo i limiti della tavola periodica invece dello schermo
	var table_rect = Rect2(periodic_table_container.global_position, periodic_table_container.size)
	var table_min_y = table_rect.position.y
	var table_max_y = table_rect.position.y + table_rect.size.y
	
	# Calcolo posizione X (manteniamo la stessa logica ma con i limiti della tavola)
	var popup_pos_x = button.global_position.x + button.size.x
	if popup_pos_x > table_rect.position.x + table_rect.size.x / 2:
		popup_pos_x = popup_pos_x - button.size.x - popup_margin.size.x - horizontal_offset
	else:
		popup_pos_x = popup_pos_x + horizontal_offset
	
	# Calcolo posizione Y
	var popup_pos_y = button.global_position.y + button.size.y / 2 - popup_margin.size.y / 2 + 100
	
	# Verifica che il popup non vada fuori dalla tavola in alto
	if popup_pos_y < table_min_y + vertical_offset:
		popup_pos_y = table_min_y - vertical_offset
	
	# Verifica che il popup non vada fuori dalla tavola in basso
	if popup_pos_y + popup_margin.size.y > table_max_y - vertical_offset:
		popup_pos_y = table_max_y - popup_margin.size.y + vertical_offset
	
	var popup_pos = Vector2(popup_pos_x, popup_pos_y)
	
	popup_margin.global_position = popup_pos
	popup_panel.global_position = popup_pos

func popup_animation(button):
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.3, 1.3), 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween.tween_property(button, "scale", Vector2(1.1,1.1), 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	popup_panel.size.y = (popup_margin.size.y)

const STATES = ["normal"]

# Cache globale per gli stili
var global_style_cache = {}

# Disabilita i segnali di aggiornamento durante il batch di operazioni
var _is_batch_updating = false

# Precomputa gli stili per i vari stati una sola volta
var precomputed_themes = {}

# Inizializza gli stili precomputati (chiamare all'avvio)
func precompute_styles():
	precomputed_themes.clear()
	
	# Pre-calcola gli stili per le categorie principali
	for category in current_theme.keys():
		if category == "Category" or category == "Font" or current_theme["Background"] is String:
			continue
			
		var style = StyleBoxFlat.new()
		style.set_corner_radius_all(radius)
		style.set_expand_margin_all(margin)
		style.bg_color = current_theme[category]
		precomputed_themes[category] = style
	
	# Pre-calcola gli stili per le categorie numerate
	if "Category" in current_theme:
		for i in prof_to_key:
			var key = str(i)
			if key in current_theme["Category"]:
				var style = StyleBoxFlat.new()
				style.set_corner_radius_all(radius)
				style.set_expand_margin_all(margin)
				style.bg_color = current_theme["Category"][key]
				precomputed_themes["Category_" + key] = style

# Versione ottimizzata della funzione principale
func reset_all_colors() -> void:
	selected_category_symbol = ""
	category_counter = 0
	
	# Prepariamo una lista di aggiornamenti da applicare in batch
	var buttons_to_update = []
	var labels_to_update = []
	var font_color = current_theme.get("Font", default_font_color)
	
	# Disabilita temporaneamente gli aggiornamenti
	_is_batch_updating = true
	
	# Raccogliamo tutti gli elementi da aggiornare
	for element_container in grid_container.get_children():
		# Raccogli le Label
		for child in element_container.get_children():
			if child is Label:
				labels_to_update.append(child)
		
		# Ottimizzazione ricerca Button
		var btn = find_button_in_children(element_container)
		if not btn:
			continue
		
		var data = elements.get(btn.text)
		if not data:
			continue
		
		# Reset completo delle scale
		btn.scale = Vector2(1.0, 1.0)
		
		var category: String = data["category"]
		var style_key = category
		
		# Gestione categorie speciali
		if category == "Category":
			category_counter = (category_counter % 8) + 1
			style_key = "Category_" + str(category_counter)
		
		# Aggiungi il bottone alla lista con lo stile da applicare
		buttons_to_update.append({
			"button": btn,
			"style_key": style_key
		})
	
	# Applica il colore del font a tutte le label in un'unica volta
	for label in labels_to_update:
		label.add_theme_color_override("font_color", font_color)
	
	# Applica gli stili a tutti i bottoni in batch
	batch_apply_styles(buttons_to_update, font_color)
	
	# Riattiva gli aggiornamenti
	_is_batch_updating = false
	

# Funzione helper ottimizzata per trovare il primo Button nei figli
func find_button_in_children(parent: Node) -> Button:
	var btn = parent.get_node_or_null("Button")
	if btn and btn is Button:
		return btn
	
	# Fallback alla ricerca tra tutti i figli
	for child in parent.get_children():
		if child is Button:
			return child
			
	return null

# Versione ottimizzata che applica gli stili in batch
func batch_apply_styles(buttons_data: Array, font_color: Color) -> void:

	# Applica gli stili in batch
	for data in buttons_data:
		var btn = data["button"]
		var style_key = data["style_key"]
		
		# Ottieni o crea lo stile
		var style
		if style_key in precomputed_themes:
			style = precomputed_themes[style_key]
		else:
			# Crea il nuovo stile solo se necessario
			style = StyleBoxFlat.new()
			style.set_corner_radius_all(radius)
			style.set_expand_margin_all(margin)
			
			if style_key.begins_with("Category_"):
				var category_number = style_key.substr(9)
				style.bg_color = current_theme["Category"][category_number]
			else:
				style.bg_color = current_theme[style_key]
				
			precomputed_themes[style_key] = style
		
		# Applica lo stile a tutti gli stati del bottone in una volta sola
		for state in STATES:
			btn.add_theme_stylebox_override(state, style)
		
		# Imposta il colore del font
		btn.add_theme_color_override("font_color", font_color)
		btn.add_theme_color_override("font_hover_color", font_color)
	

# Funzione originale per compatibilità, ma ottimizzata
func apply_style_to_button(btn: Button, style: StyleBoxFlat) -> void:
	# Se siamo in modalità batch, non fare nulla per evitare aggiornamenti multipli
	if _is_batch_updating:
		return
	
	# Disabilita temporaneamente gli aggiornamenti dell'interfaccia
	var was_processing = get_tree().is_processing()
	if was_processing:
		get_tree().set_deferred_enabled(false)
	
	# Applica lo stile a tutti gli stati
	for state in STATES:
		btn.add_theme_stylebox_override(state, style)
	
	# Imposta il colore del font
	var font_color = current_theme.get("Font", default_font_color)
	btn.add_theme_color_override("font_color", font_color)
	btn.add_theme_color_override("font_hover_color", font_color)
	
	# Riattiva gli aggiornamenti dell'interfaccia
	if was_processing:
		get_tree().set_deferred_enabled(true)

func _on_theme_button_pressed() -> void:
	change_theme()
