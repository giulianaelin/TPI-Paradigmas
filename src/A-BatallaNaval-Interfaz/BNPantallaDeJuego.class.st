"
Base de las pantallas donde se ve la partida (ubicacion y batalla): el panel con la flota del jugador, su tablero, la nutria con los avisos y el boton para girar (cambiar entre horizontal y vertical). Cada subclase agrega su lado derecho y decide que hace un clic.
"
Class {
	#name : 'BNPantallaDeJuego',
	#superclass : 'BNPantalla',
	#instVars : [
		'panel',
		'vistaPropia',
		'nutria',
		'direccion',
		'botonGirar'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'acciones' }
BNPantallaDeJuego >> accionDeGirar [

	"Como se llama el boton de girar en esta pantalla."
	self subclassResponsibility
]

{ #category : 'eventos' }
BNPantallaDeJuego >> actualizarMarcasCon: unPunto tiempo: unosMilisegundos [

	"Resalta casillas segun donde esta el mouse. Devuelve true si cambio algo."
	self subclassResponsibility
]

{ #category : 'eventos' }
BNPantallaDeJuego >> actualizarMouse: unPunto tiempo: unosMilisegundos [

	| cambio |
	cambio := super actualizarMouse: unPunto tiempo: unosMilisegundos.
	(nutria cuadro: unosMilisegundos // 450 \\ 2) ifTrue: [cambio := true].
	(self actualizarMarcasCon: unPunto tiempo: unosMilisegundos) ifTrue: [cambio := true].
	^cambio
]

{ #category : 'initialization' }
BNPantallaDeJuego >> agregarBotonGirarEn: unRectangulo [

	botonGirar := self agregarBoton: unRectangulo texto: self textoDeGirar icono: #girar accion: [self girar]
]

{ #category : 'dibujo' }
BNPantallaDeJuego >> dibujarContenidoEn: unCanvas [

	self dibujarVentana: (15 @ 15 extent: 270 @ 489) titulo: self tituloDelPanel en: unCanvas.
	panel dibujarEn: unCanvas con: self recursos.
	self dibujarVentana: (294 @ 15 extent: 480 @ 489) titulo: 'Tu mar' en: unCanvas.
	vistaPropia dibujarEn: unCanvas con: self recursos.
	self dibujarLadoDerechoEn: unCanvas.
	nutria dibujarEn: unCanvas con: self recursos
]

{ #category : 'dibujo' }
BNPantallaDeJuego >> dibujarLadoDerechoEn: unCanvas [

	self subclassResponsibility
]

{ #category : 'accessing' }
BNPantallaDeJuego >> direccion [

	^direccion
]

{ #category : 'acciones' }
BNPantallaDeJuego >> girar [

	direccion := direccion = BNCoordenada horizontal
		ifTrue: [BNCoordenada vertical]
		ifFalse: [BNCoordenada horizontal].
	botonGirar texto: self textoDeGirar
]

{ #category : 'acciones' }
BNPantallaDeJuego >> nombreDeDireccion [

	^direccion = BNCoordenada horizontal
		ifTrue: ['horizontal']
		ifFalse: ['vertical']
]

{ #category : 'accessing' }
BNPantallaDeJuego >> nutria [

	^nutria
]

{ #category : 'accessing' }
BNPantallaDeJuego >> panel [

	^panel
]

{ #category : 'initialization' }
BNPantallaDeJuego >> prepararse [

	self subclassResponsibility
]

{ #category : 'initialization' }
BNPantallaDeJuego >> setJuego: unJuego [

	direccion := BNCoordenada horizontal.
	super setJuego: unJuego.
	panel := BNPanelFlota jugador: self partida jugador origen: 30 @ 72.
	vistaPropia := BNVistaTableroPropio tablero: self partida jugador tablero origen: 366 @ 96.
	nutria := BNNutria en: 15 @ 516 globo: (222 @ 522 extent: 681 @ 183).
	self prepararse
]

{ #category : 'eventos' }
BNPantallaDeJuego >> tecla: unCodigo [

	(unCodigo = $r asInteger or: [unCodigo = $R asInteger]) ifTrue: [self girar]
]

{ #category : 'acciones' }
BNPantallaDeJuego >> textoDeGirar [

	^self accionDeGirar , ': ' , self nombreDeDireccion
]

{ #category : 'dibujo' }
BNPantallaDeJuego >> tituloDelPanel [

	self subclassResponsibility
]

{ #category : 'accessing' }
BNPantallaDeJuego >> vistaPropia [

	^vistaPropia
]
