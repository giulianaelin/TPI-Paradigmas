"
Soy la ventana del juego (un Morph de 1280x720). Recibo los clics, las teclas y el paso del tiempo y se los paso a la pantalla actual, que es la que sabe que hacer. Guardo la partida del modelo (BNPartida) y cambio de pantalla cuando corresponde. Dibujo todo primero en una forma propia de 1280x720 y despues la copio al mundo de Pharo; si la ventana de Pharo es mas chica, me achico para entrar.
Para jugar: BNJuegoMorph abrir.
"
Class {
	#name : 'BNJuegoMorph',
	#superclass : 'Morph',
	#instVars : [
		'pantalla',
		'recursos',
		'partida',
		'lienzo',
		'escala',
		'vista',
		'musica',
		'dificultad',
		'archivo'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNJuegoMorph class >> abrir [

	"Abre el juego centrado en el mundo de Pharo."
	| juego |
	juego := self new.
	juego openInWorld.
	juego ajustarA: juego world extent.
	juego position: ((juego world extent - juego extent) // 2 max: 0 @ 0).
	^juego
]

{ #category : 'initialization' }
BNJuegoMorph >> ajustarA: unTamanoDisponible [

	"Si no entro en ese espacio, me achico manteniendo la proporcion."
	escala := ((unTamanoDisponible x / self tamano x) min: (unTamanoDisponible y / self tamano y)) min: 1.
	self extent: (self tamano * escala) rounded.
	self redibujar
]

{ #category : 'accessing' }
BNJuegoMorph >> archivo [

	"Donde se guarda la partida."
	^archivo ifNil: [archivo := BNArchivoDePartida estandar]
]

{ #category : 'pantallas' }
BNJuegoMorph >> cargarPartida [

	"Sigue la partida guardada desde donde quedo."
	partida := self archivo cargar.
	partida enUbicacion
		ifTrue: [self mostrar: (BNPantallaUbicacion en: self)]
		ifFalse: [self mostrarBatalla]
]

{ #category : 'pantallas' }
BNJuegoMorph >> cerrar [

	self delete
]

{ #category : 'eventos' }
BNJuegoMorph >> clicEn: unPunto [

	pantalla clicEn: unPunto.
	self redibujar
]

{ #category : 'pantallas' }
BNJuegoMorph >> delete [

	"Al cerrar el juego se corta la musica."
	musica detener.
	super delete
]

{ #category : 'accessing' }
BNJuegoMorph >> dificultad [

	"#facil o #intermedio: la elige el jugador en Opciones."
	^dificultad
]

{ #category : 'accessing' }
BNJuegoMorph >> dificultad: unaDificultad [

	dificultad := unaDificultad
]

{ #category : 'dibujo' }
BNJuegoMorph >> drawOn: unCanvas [

	unCanvas drawImage: vista at: self position
]

{ #category : 'pantallas' }
BNJuegoMorph >> estrategiaElegida [

	"La interfaz solo traduce la eleccion del jugador a una estrategia del modelo."
	^dificultad = #intermedio
		ifTrue: [BNEstrategiaCazadora new]
		ifFalse: [BNEstrategiaAleatoria new]
]

{ #category : 'dibujo' }
BNJuegoMorph >> guardarCapturaEn: unNombreDeArchivo [

	"Guarda lo que se ve en un PNG (sirve para el informe)."
	PNGReadWriter putForm: lienzo onFileNamed: unNombreDeArchivo
]

{ #category : 'pantallas' }
BNJuegoMorph >> guardarPartida [

	self archivo guardar: partida
]

{ #category : 'eventos' }
BNJuegoMorph >> handlesKeyboard: unEvento [

	^true
]

{ #category : 'eventos' }
BNJuegoMorph >> handlesMouseDown: unEvento [

	^true
]

{ #category : 'initialization' }
BNJuegoMorph >> initialize [

	super initialize.
	recursos := BNRecursos actual.
	musica := BNMusica enCarpeta: recursos carpeta / 'musica'.
	dificultad := #facil.
	lienzo := Form extent: self tamano depth: 32.
	escala := 1.
	self extent: self tamano.
	self mostrarMenu
]

{ #category : 'eventos' }
BNJuegoMorph >> keyStroke: unEvento [

	pantalla tecla: unEvento keyValue.
	self redibujar
]

{ #category : 'accessing' }
BNJuegoMorph >> lienzo [

	^lienzo
]

{ #category : 'pantallas' }
BNJuegoMorph >> mostrar: unaPantalla [

	"Cambia de pantalla y pone la musica que le corresponde."
	pantalla := unaPantalla.
	musica reproducir: unaPantalla musica.
	self redibujar
]

{ #category : 'pantallas' }
BNJuegoMorph >> mostrarBatalla [

	self mostrar: (BNPantallaBatalla en: self)
]

{ #category : 'pantallas' }
BNJuegoMorph >> mostrarFinDe: unaPantalla [

	"Una partida terminada ya no se puede seguir: se borra la guardada."
	self archivo borrar.
	self mostrar: (BNPantallaFin en: self sobre: unaPantalla)
]

{ #category : 'pantallas' }
BNJuegoMorph >> mostrarMenu [

	self mostrar: (BNPantallaMenu en: self)
]

{ #category : 'pantallas' }
BNJuegoMorph >> mostrarOpciones [

	self mostrar: (BNPantallaOpciones en: self)
]

{ #category : 'eventos' }
BNJuegoMorph >> mouseDown: unEvento [

	unEvento hand newKeyboardFocus: self.
	self clicEn: (self puntoDelJuego: unEvento position)
]

{ #category : 'accessing' }
BNJuegoMorph >> musica [

	^musica
]

{ #category : 'pantallas' }
BNJuegoMorph >> nuevaPartida [

	partida := BNPartida nueva.
	partida usarEstrategia: self estrategiaElegida.
	self mostrar: (BNPantallaUbicacion en: self)
]

{ #category : 'accessing' }
BNJuegoMorph >> pantalla [

	^pantalla
]

{ #category : 'accessing' }
BNJuegoMorph >> partida [

	^partida
]

{ #category : 'dibujo' }
BNJuegoMorph >> puntoDelJuego: unPuntoDelMundo [

	"Pasa un punto del mundo de Pharo a coordenadas del juego (1280x720)."
	^((unPuntoDelMundo - self position) / escala) rounded
]

{ #category : 'accessing' }
BNJuegoMorph >> recursos [

	^recursos
]

{ #category : 'dibujo' }
BNJuegoMorph >> redibujar [

	pantalla dibujarEn: (FormCanvas on: lienzo).
	vista := escala = 1
		ifTrue: [lienzo]
		ifFalse: [lienzo magnify: lienzo boundingBox by: escala smoothing: 2].
	self changed
]

{ #category : 'eventos' }
BNJuegoMorph >> step [

	| mano |
	mano := self activeHand.
	mano isNil ifTrue: [^self].
	(pantalla actualizarMouse: (self puntoDelJuego: mano position) tiempo: Time millisecondClockValue)
		ifTrue: [self redibujar]
]

{ #category : 'eventos' }
BNJuegoMorph >> stepTime [

	^80
]

{ #category : 'initialization' }
BNJuegoMorph >> tamano [

	^1280 @ 720
]
