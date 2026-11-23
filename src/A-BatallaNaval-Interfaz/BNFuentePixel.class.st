"
Soy la tipografia pixel del juego. Tengo una tira con todas las letras dibujadas en blanco (celdas de 6x9) y el ancho de cada una. Con formaDe:escala:color:sombra: armo la imagen de un texto en el color pedido, agrandada sin suavizar; las guardo en un cache porque los mismos textos se dibujan muchas veces.
"
Class {
	#name : 'BNFuentePixel',
	#superclass : 'Object',
	#instVars : [
		'forma',
		'caracteres',
		'anchos',
		'cache'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNFuentePixel class >> forma: unaForma descripcion: unTexto [

	"unTexto tiene dos lineas: los caracteres en orden y el ancho de cada uno."
	^self new setForma: unaForma descripcion: unTexto
]

{ #category : 'medidas' }
BNFuentePixel >> anchoDe: unTexto escala: unaEscala [

	"Ancho en pixeles de pantalla que ocupa el texto."
	^(unTexto inject: 0 into: [:suma :unCaracter | suma + (anchos at: (self indiceDe: unCaracter)) + 1]) * unaEscala
]

{ #category : 'dibujo' }
BNFuentePixel >> crearFormaDe: unTexto escala: unaEscala color: unColor sombra: unaSombra [

	| chica |
	chica := Form extent: ((self anchoDe: unTexto escala: 1) max: 1) @ 10 depth: 32.
	unaSombra ifNotNil: [self pintar: unTexto en: chica color: unaSombra bajando: 1].
	self pintar: unTexto en: chica color: unColor bajando: 0.
	^BNLienzoPixel ampliar: chica por: unaEscala
]

{ #category : 'dibujo' }
BNFuentePixel >> formaDe: unTexto escala: unaEscala color: unColor sombra: unaSombra [

	"Imagen del texto (transparente alrededor). La sombra, si no es nil, va un pixel mas abajo."
	^cache
		at: { unTexto. unaEscala. unColor. unaSombra }
		ifAbsentPut: [self crearFormaDe: unTexto escala: unaEscala color: unColor sombra: unaSombra]
]

{ #category : 'medidas' }
BNFuentePixel >> indiceDe: unCaracter [

	"Posicion del caracter en la tira. Los que no existen se dibujan como signo de pregunta."
	| indice |
	indice := caracteres indexOf: unCaracter.
	^indice = 0
		ifTrue: [caracteres indexOf: $?]
		ifFalse: [indice]
]

{ #category : 'medidas' }
BNFuentePixel >> lineasDe: unTexto ancho: unAncho escala: unaEscala [

	"Parte el texto en lineas que entren en ese ancho, cortando entre palabras."
	| lineas actual |
	lineas := OrderedCollection new.
	actual := ''.
	(unTexto substrings: ' ') do: [:unaPalabra |
		| prueba |
		prueba := actual isEmpty ifTrue: [unaPalabra] ifFalse: [actual , ' ' , unaPalabra].
		((self anchoDe: prueba escala: unaEscala) <= unAncho or: [actual isEmpty])
			ifTrue: [actual := prueba]
			ifFalse: [
				lineas add: actual.
				actual := unaPalabra]].
	actual isEmpty ifFalse: [lineas add: actual].
	^lineas
]

{ #category : 'dibujo' }
BNFuentePixel >> pintar: unTexto en: unaForma color: unColor bajando: unDesplazamiento [

	| x |
	x := 0.
	unTexto do: [:unCaracter |
		| indice ancho |
		indice := self indiceDe: unCaracter.
		ancho := anchos at: indice.
		0 to: ancho - 1 do: [:gx | 0 to: 8 do: [:gy |
			(forma colorAt: (((indice - 1) * 6) + gx) @ gy) alpha > 0.5
				ifTrue: [unaForma colorAt: (x + gx) @ (gy + unDesplazamiento) put: unColor]]].
		x := x + ancho + 1]
]

{ #category : 'initialization' }
BNFuentePixel >> setForma: unaForma descripcion: unTexto [

	| lineas |
	forma := unaForma.
	lineas := unTexto lines.
	caracteres := lineas first.
	anchos := (lineas second substrings collect: [:unNumero | unNumero asNumber]) asArray.
	cache := Dictionary new
]
