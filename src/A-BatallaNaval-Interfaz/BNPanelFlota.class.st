"
Dibujo la lista de naves de un jugador: icono, nombre y un corazon por cada punto de resistencia (rosa si esta sano, roto si se perdio). Si el arma especial de una nave esta recargando, le pongo un relojito con los turnos que le faltan. Permito elegir una nave con un clic; el filtro (un bloque) dice cuales se pueden elegir en cada momento y las demas se ven apagadas.
"
Class {
	#name : 'BNPanelFlota',
	#superclass : 'Object',
	#instVars : [
		'jugador',
		'origen',
		'elegida',
		'filtro'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNPanelFlota class >> jugador: unJugador origen: unPunto [

	^self new setJugador: unJugador origen: unPunto
]

{ #category : 'geometria' }
BNPanelFlota >> altoDeFila [

	"11 naves en el alto de la ventana."
	^38
]

{ #category : 'dibujo' }
BNPanelFlota >> dibujarEn: unCanvas con: unosRecursos [

	jugador naves withIndexDo: [:unaNave :i | self dibujarFila: i nave: unaNave en: unCanvas con: unosRecursos]
]

{ #category : 'dibujo' }
BNPanelFlota >> dibujarFila: unIndice nave: unaNave en: unCanvas con: unosRecursos [

	| rect nombre |
	rect := self rectanguloDeFila: unIndice.
	unaNave == elegida ifTrue: [
		unCanvas frameAndFillRectangle: rect fillColor: BNLienzoPixel rosa2 borderWidth: 3 borderColor: BNLienzoPixel oscuro].
	unCanvas translucentImage: (unosRecursos imagen: 'icono-' , unaNave nombre asLowercase ampliada: 2) at: rect origin + (2 @ 3).
	nombre := unosRecursos fuente formaDe: unaNave nombre escala: 2 color: BNLienzoPixel texto sombra: nil.
	unCanvas translucentImage: nombre at: rect origin + (102 @ -1).
	1 to: unaNave resistencia do: [:k |
		unCanvas
			translucentImage: (unosRecursos
				imagen: (k <= unaNave resistenciaRestante ifTrue: ['vida-sana'] ifFalse: ['vida-perdida'])
				ampliada: 2)
			at: rect origin + ((102 + ((k - 1) * 26)) @ 15)].
	unaNave estaRecargando ifTrue: [
		unCanvas frameAndFillRectangle: (rect origin + (52 @ 4) extent: 46 @ 30) fillColor: BNLienzoPixel crema borderWidth: 2 borderColor: BNLienzoPixel oscuro.
		unCanvas translucentImage: (unosRecursos icono: #reloj) at: rect origin + (55 @ 8).
		unCanvas
			translucentImage: (unosRecursos fuente formaDe: unaNave turnosDeRecarga printString escala: 2 color: BNLienzoPixel oscuro sombra: nil)
			at: rect origin + (80 @ 10)].
	(filtro value: unaNave) ifFalse: [unCanvas fillRectangle: rect color: (BNLienzoPixel claro alpha: 0.6)]
]

{ #category : 'accessing' }
BNPanelFlota >> elegida [

	^elegida
]

{ #category : 'accessing' }
BNPanelFlota >> elegida: unaNave [

	elegida := unaNave
]

{ #category : 'accessing' }
BNPanelFlota >> filtro: unBloque [

	filtro := unBloque
]

{ #category : 'geometria' }
BNPanelFlota >> naveEn: unPunto [

	"La nave de la fila que esta en ese punto, si se puede elegir."
	jugador naves withIndexDo: [:unaNave :i |
		(((self rectanguloDeFila: i) containsPoint: unPunto) and: [filtro value: unaNave])
			ifTrue: [^unaNave]].
	^nil
]

{ #category : 'geometria' }
BNPanelFlota >> rectanguloDeFila: unIndice [

	^(origen + (0 @ ((unIndice - 1) * self altoDeFila))) extent: 240 @ self altoDeFila
]

{ #category : 'initialization' }
BNPanelFlota >> setJugador: unJugador origen: unPunto [

	jugador := unJugador.
	origen := unPunto.
	filtro := [:unaNave | true]
]
