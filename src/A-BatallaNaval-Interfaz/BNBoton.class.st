"
Soy un boton de la interfaz: tengo un rectangulo en la pantalla, un texto, un icono opcional y un bloque que se ejecuta al hacer clic. Me dibujo segun mi estado: normal, resaltado (mouse encima o elegido) o apagado (deshabilitado). Guardo mi dibujo de cada estado para no rehacerlo.
"
Class {
	#name : 'BNBoton',
	#superclass : 'Object',
	#instVars : [
		'rectangulo',
		'texto',
		'icono',
		'accion',
		'habilitado',
		'bajoElMouse',
		'elegido',
		'formas'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNBoton class >> en: unRectangulo texto: unTexto icono: unIcono accion: unBloque [

	^self new setRectangulo: unRectangulo texto: unTexto icono: unIcono accion: unBloque
]

{ #category : 'eventos' }
BNBoton >> bajoElMouse: unBooleano [

	"Avisa si el mouse esta encima. Devuelve true si cambio (hay que redibujar)."
	| antes |
	antes := bajoElMouse.
	bajoElMouse := unBooleano.
	^antes ~= unBooleano
]

{ #category : 'dibujo' }
BNBoton >> colorDeTexto [

	habilitado ifFalse: [^BNLienzoPixel textoApagado].
	^self estado = #resaltado
		ifTrue: [BNLienzoPixel blanco]
		ifFalse: [BNLienzoPixel texto]
]

{ #category : 'eventos' }
BNBoton >> contiene: unPunto [

	^rectangulo containsPoint: unPunto
]

{ #category : 'dibujo' }
BNBoton >> crearFormaCon: unosRecursos [

	| logico lienzo grande escalaIcono escalaTexto letras x |
	logico := rectangulo extent // 3.
	lienzo := BNLienzoPixel extent: logico + (0 @ 3).
	lienzo botonEn: (0 @ 0 extent: logico) estado: self estado.
	escalaIcono := logico y >= 24 ifTrue: [2] ifFalse: [1].
	icono ifNotNil: [
		lienzo icono: icono en: (6 * escalaIcono) @ ((logico y - (7 * escalaIcono)) // 2) escala: escalaIcono apagado: habilitado not].
	grande := lienzo ampliadoPor: 3.
	texto isEmpty ifTrue: [^grande].
	escalaTexto := logico y >= 24 ifTrue: [6] ifFalse: [3].
	letras := unosRecursos fuente formaDe: texto escala: escalaTexto color: self colorDeTexto sombra: self sombraDeTexto.
	x := (rectangulo width - letras width) // 2.
	icono ifNotNil: [x := x + (escalaIcono * 12)].
	(FormCanvas on: grande) translucentImage: letras at: x @ ((rectangulo height - (7 * escalaTexto)) // 2).
	^grande
]

{ #category : 'dibujo' }
BNBoton >> dibujarEn: unCanvas con: unosRecursos [

	unCanvas translucentImage: (self formaCon: unosRecursos) at: rectangulo origin
]

{ #category : 'eventos' }
BNBoton >> ejecutar [

	accion value
]

{ #category : 'accessing' }
BNBoton >> elegido: unBooleano [

	elegido := unBooleano
]

{ #category : 'accessing' }
BNBoton >> estaHabilitado [

	^habilitado
]

{ #category : 'dibujo' }
BNBoton >> estado [

	habilitado ifFalse: [^#apagado].
	^(bajoElMouse or: [elegido])
		ifTrue: [#resaltado]
		ifFalse: [#normal]
]

{ #category : 'dibujo' }
BNBoton >> formaCon: unosRecursos [

	^formas at: self estado ifAbsentPut: [self crearFormaCon: unosRecursos]
]

{ #category : 'accessing' }
BNBoton >> habilitado: unBooleano [

	habilitado := unBooleano
]

{ #category : 'accessing' }
BNBoton >> rectangulo [

	^rectangulo
]

{ #category : 'initialization' }
BNBoton >> setRectangulo: unRectangulo texto: unTexto icono: unIcono accion: unBloque [

	rectangulo := unRectangulo.
	texto := unTexto.
	icono := unIcono.
	accion := unBloque.
	habilitado := true.
	bajoElMouse := false.
	elegido := false.
	formas := Dictionary new
]

{ #category : 'dibujo' }
BNBoton >> sombraDeTexto [

	habilitado ifFalse: [^nil].
	^self estado = #resaltado
		ifTrue: [BNLienzoPixel oscuro]
		ifFalse: [BNLienzoPixel franja]
]

{ #category : 'accessing' }
BNBoton >> texto [

	^texto
]

{ #category : 'accessing' }
BNBoton >> texto: unTexto [

	texto = unTexto ifFalse: [
		texto := unTexto.
		formas := Dictionary new]
]
