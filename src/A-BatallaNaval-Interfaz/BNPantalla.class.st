"
Soy la base abstracta de las pantallas del juego (menu, opciones, ubicacion, batalla y fin). Cada pantalla sabe dibujarse y responder a clics, teclas y al paso del tiempo; el BNJuegoMorph solo le pasa los eventos a la pantalla actual (polimorfismo). Las pantallas usan la partida del modelo, pero el modelo no sabe nada de ellas.
"
Class {
	#name : 'BNPantalla',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'botones'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNPantalla class >> en: unJuego [

	^self new setJuego: unJuego
]

{ #category : 'eventos' }
BNPantalla >> actualizarMouse: unPunto tiempo: unosMilisegundos [

	"Se llama varias veces por segundo con la posicion del mouse. Devuelve true si hay que redibujar."
	| cambio |
	cambio := false.
	botones do: [:unBoton |
		(unBoton bajoElMouse: (unBoton estaHabilitado and: [unBoton contiene: unPunto]))
			ifTrue: [cambio := true]].
	^cambio
]

{ #category : 'initialization' }
BNPantalla >> agregarBoton: unRectangulo texto: unTexto icono: unIcono accion: unBloque [

	^botones add: (BNBoton en: unRectangulo texto: unTexto icono: unIcono accion: unBloque)
]

{ #category : 'accessing' }
BNPantalla >> botones [

	^botones
]

{ #category : 'eventos' }
BNPantalla >> clicEn: unPunto [

	botones do: [:unBoton |
		(unBoton estaHabilitado and: [unBoton contiene: unPunto]) ifTrue: [^unBoton ejecutar]].
	self clicLibreEn: unPunto
]

{ #category : 'eventos' }
BNPantalla >> clicLibreEn: unPunto [

	"Un clic que no cayo en ningun boton. Por defecto no hace nada."
]

{ #category : 'initialization' }
BNPantalla >> crearBotones [

	"Por defecto no hay botones."
]

{ #category : 'dibujo' }
BNPantalla >> dibujarContenidoEn: unCanvas [

	self subclassResponsibility
]

{ #category : 'dibujo' }
BNPantalla >> dibujarEn: unCanvas [

	self dibujarFondoEn: unCanvas.
	self dibujarContenidoEn: unCanvas.
	botones do: [:unBoton | unBoton dibujarEn: unCanvas con: self recursos]
]

{ #category : 'dibujo' }
BNPantalla >> dibujarFondoEn: unCanvas [

	unCanvas drawImage: (self recursos imagen: 'fondo-juego') at: 0 @ 0
]

{ #category : 'dibujo' }
BNPantalla >> dibujarVentana: unRectangulo titulo: unTitulo en: unCanvas [

	unCanvas translucentImage: (self recursos ventana: unRectangulo extent) at: unRectangulo origin.
	unCanvas
		translucentImage: (self recursos fuente formaDe: unTitulo escala: 3 color: BNLienzoPixel texto sombra: BNLienzoPixel crema)
		at: unRectangulo origin + (72 @ 15)
]

{ #category : 'dibujo' }
BNPantalla >> escribir: unTexto en: unPunto escala: unaEscala en: unCanvas [

	unCanvas
		translucentImage: (self recursos fuente formaDe: unTexto escala: unaEscala color: BNLienzoPixel texto sombra: nil)
		at: unPunto
]

{ #category : 'dibujo' }
BNPantalla >> escribirParrafos: unosTextos en: unPunto ancho: unAncho en: unCanvas [

	"Escribe varios parrafos cortando las lineas para que entren en el ancho."
	| y |
	y := unPunto y.
	unosTextos do: [:unParrafo |
		(self recursos fuente lineasDe: unParrafo ancho: unAncho escala: 2) do: [:unaLinea |
			self escribir: unaLinea en: unPunto x @ y escala: 2 en: unCanvas.
			y := y + 24].
		y := y + 12]
]

{ #category : 'accessing' }
BNPantalla >> musica [

	"Nombre de la cancion que suena en esta pantalla (nil = silencio)."
	^nil
]

{ #category : 'accessing' }
BNPantalla >> partida [

	^juego partida
]

{ #category : 'accessing' }
BNPantalla >> recursos [

	^juego recursos
]

{ #category : 'initialization' }
BNPantalla >> setJuego: unJuego [

	juego := unJuego.
	botones := OrderedCollection new.
	self crearBotones
]

{ #category : 'eventos' }
BNPantalla >> tecla: unCodigo [

	"Por defecto las teclas no hacen nada."
]
