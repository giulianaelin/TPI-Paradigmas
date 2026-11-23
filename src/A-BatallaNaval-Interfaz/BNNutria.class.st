"
Soy la nutria pirata que da los avisos: tengo una cara (normal, contenta, triste o sorprendida), un titulo y lineas de detalle que se muestran en un globo de dialogo. Me balanceo un poquito (dos cuadros) para que se vea viva. Solo soy interfaz: la pantalla me dice que decir segun lo que paso en el modelo.
"
Class {
	#name : 'BNNutria',
	#superclass : 'Object',
	#instVars : [
		'origen',
		'globo',
		'cara',
		'titulo',
		'lineas',
		'cuadro'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNNutria class >> en: unPunto globo: unRectangulo [

	^self new setOrigen: unPunto globo: unRectangulo
]

{ #category : 'accessing' }
BNNutria >> cara [

	^cara
]

{ #category : 'accessing' }
BNNutria >> cuadro: unNumero [

	"Cuadro de la animacion (0 o 1). Devuelve true si cambio."
	| cambio |
	cambio := cuadro ~= unNumero.
	cuadro := unNumero.
	^cambio
]

{ #category : 'accessing' }
BNNutria >> decir: unTitulo detalle: unasLineas cara: unaCara [

	titulo := unTitulo.
	lineas := unasLineas.
	cara := unaCara
]

{ #category : 'dibujo' }
BNNutria >> dibujarEn: unCanvas con: unosRecursos [

	| fuente renglones y |
	unCanvas translucentImage: (unosRecursos imagen: 'nutria-' , cara ampliada: 2) at: origen + (0 @ (cuadro * 4)).
	unCanvas translucentImage: (unosRecursos globo: globo extent) at: globo origin.
	fuente := unosRecursos fuente.
	unCanvas
		translucentImage: (fuente formaDe: titulo escala: 4 color: BNLienzoPixel oscuro sombra: BNLienzoPixel franja)
		at: globo origin + (48 @ 18).
	renglones := lineas flatCollect: [:unaLinea | fuente lineasDe: unaLinea ancho: globo width - 90 escala: 2].
	y := globo top + 66.
	(renglones first: (renglones size min: 4)) do: [:unRenglon |
		unCanvas
			translucentImage: (fuente formaDe: unRenglon escala: 2 color: BNLienzoPixel texto sombra: nil)
			at: (globo left + 48) @ y.
		y := y + 24]
]

{ #category : 'accessing' }
BNNutria >> lineas [

	^lineas
]

{ #category : 'initialization' }
BNNutria >> setOrigen: unPunto globo: unRectangulo [

	origen := unPunto.
	globo := unRectangulo.
	cara := #normal.
	titulo := ''.
	lineas := #().
	cuadro := 0
]

{ #category : 'accessing' }
BNNutria >> titulo [

	^titulo
]
