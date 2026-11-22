"
Muestro el final de la partida encima de la ultima pantalla de batalla (oscurecida): quien gano, la nutria contenta o triste, y botones para jugar otra vez o volver al menu.
"
Class {
	#name : 'BNPantallaFin',
	#superclass : 'BNPantalla',
	#instVars : [
		'anterior',
		'gano'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNPantallaFin class >> en: unJuego sobre: unaPantalla [

	^self new setAnterior: unaPantalla juego: unJuego
]

{ #category : 'initialization' }
BNPantallaFin >> crearBotones [

	self agregarBoton: (405 @ 459 extent: 228 @ 54) texto: 'Jugar otra vez' icono: nil accion: [juego nuevaPartida].
	self agregarBoton: (648 @ 459 extent: 228 @ 54) texto: 'Menú' icono: #menu accion: [juego mostrarMenu]
]

{ #category : 'dibujo' }
BNPantallaFin >> dibujarContenidoEn: unCanvas [

	| recursos titulo |
	recursos := self recursos.
	self dibujarVentana: (390 @ 180 extent: 501 @ 357) titulo: 'Fin de la partida' en: unCanvas.
	unCanvas
		translucentImage: (recursos imagen: (gano ifTrue: ['nutria-contenta'] ifFalse: ['nutria-triste']) ampliada: 2)
		at: 414 @ 246.
	titulo := recursos fuente
		formaDe: (gano ifTrue: ['¡Ganaste!'] ifFalse: ['Perdiste...'])
		escala: 5 color: BNLienzoPixel oscuro sombra: BNLienzoPixel franja.
	unCanvas translucentImage: titulo at: 621 @ 270.
	self
		escribirParrafos: (Array with: (gano
			ifTrue: ['Hundiste toda la flota enemiga.']
			ifFalse: ['El enemigo hundió toda tu flota.']))
		en: 621 @ 340 ancho: 250 en: unCanvas
]

{ #category : 'dibujo' }
BNPantallaFin >> dibujarFondoEn: unCanvas [

	anterior dibujarEn: unCanvas.
	unCanvas fillRectangle: (0 @ 0 extent: 1280 @ 720) color: (Color black alpha: 0.4)
]

{ #category : 'accessing' }
BNPantallaFin >> gano [

	^gano
]

{ #category : 'initialization' }
BNPantallaFin >> setAnterior: unaPantalla juego: unJuego [

	anterior := unaPantalla.
	self setJuego: unJuego.
	gano := self partida ganador == self partida jugador
]
