"
Pantalla donde el jugador ubica sus naves. Al empezar muestra las minas propias unos segundos para memorizarlas y despues las oculta. El jugador elige una nave de la lista, ve una sombra donde quedaria (blanca si entra, roja si no) y la ubica con un clic; la regla de donde se puede ubicar la decide el modelo. Cuando ubica la ultima, empieza la batalla.
"
Class {
	#name : 'BNPantallaUbicacion',
	#superclass : 'BNPantallaDeJuego',
	#instVars : [
		'elegida',
		'finRevelado'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'dibujo' }
BNPantallaUbicacion >> accionDeGirar [

	"En la ubicacion el boton gira la nave que se va a ubicar."
	^'Girar'
]

{ #category : 'eventos' }
BNPantallaUbicacion >> actualizarMarcasCon: unPunto tiempo: unosMilisegundos [

	| coordenada |
	self estaRevelando ifTrue: [^self actualizarRevelado: unosMilisegundos].
	coordenada := vistaPropia coordenadaEn: unPunto.
	(coordenada isNil or: [elegida isNil]) ifTrue: [^vistaPropia desmarcar].
	^vistaPropia
		marcar: (coordenada lineaRecortadaDe: elegida tamano hacia: direccion)
		validas: (self partida jugador tablero puedeUbicar: elegida desde: coordenada hacia: direccion)
]

{ #category : 'eventos' }
BNPantallaUbicacion >> actualizarRevelado: unosMilisegundos [

	"Cuenta regresiva de las minas. Devuelve true si cambio el aviso."
	| quedan titulo |
	unosMilisegundos >= finRevelado ifTrue: [
		self terminarRevelado.
		^true].
	quedan := (finRevelado - unosMilisegundos) // 1000 + 1.
	titulo := nutria titulo.
	self avisarMinas: quedan.
	^titulo ~= nutria titulo
]

{ #category : 'acciones' }
BNPantallaUbicacion >> avisarMinas: unosSegundos [

	nutria
		decir: '¡Memorizá tus minas! ' , unosSegundos printString
		detalle: #('Tus minas se ven unos segundos y después se esconden.' 'Si ubicás una nave encima, pierde 1 vida.')
		cara: #sorprendida
]

{ #category : 'eventos' }
BNPantallaUbicacion >> clicLibreEn: unPunto [

	| nave coordenada |
	self estaRevelando ifTrue: [^self].
	nave := panel naveEn: unPunto.
	nave notNil ifTrue: [^self elegir: nave].
	coordenada := vistaPropia coordenadaEn: unPunto.
	coordenada notNil ifTrue: [self ubicarEn: coordenada]
]

{ #category : 'initialization' }
BNPantallaUbicacion >> crearBotones [

	self agregarBotonGirarEn: (918 @ 516 extent: 351 @ 48).
	self agregarBoton: (918 @ 570 extent: 351 @ 48) texto: 'Ubicar al azar' icono: #azar accion: [self ubicarAlAzar].
	self agregarBoton: (918 @ 624 extent: 351 @ 48) texto: 'Menú' icono: #menu accion: [juego mostrarMenu]
]

{ #category : 'dibujo' }
BNPantallaUbicacion >> dibujarLadoDerechoEn: unCanvas [

	self dibujarVentana: (789 @ 15 extent: 480 @ 489) titulo: 'Cómo ubicar' en: unCanvas.
	self escribirParrafos: self textoDeAyuda en: 819 @ 78 ancho: 420 en: unCanvas
]

{ #category : 'accessing' }
BNPantallaUbicacion >> elegida [

	^elegida
]

{ #category : 'acciones' }
BNPantallaUbicacion >> elegir: unaNave [

	elegida := unaNave.
	panel elegida: unaNave
]

{ #category : 'accessing' }
BNPantallaUbicacion >> estaRevelando [

	^finRevelado notNil
]

{ #category : 'acciones' }
BNPantallaUbicacion >> estaSinUbicar: unaNave [

	^self partida jugador navesSinUbicar anySatisfy: [:otraNave | otraNave == unaNave]
]

{ #category : 'initialization' }
BNPantallaUbicacion >> prepararse [

	panel filtro: [:unaNave | self estaSinUbicar: unaNave].
	self elegir: self partida jugador navesSinUbicar first.
	vistaPropia mostrarMinas: true.
	finRevelado := Time millisecondClockValue + (self segundosDeRevelado * 1000).
	self avisarMinas: self segundosDeRevelado
]

{ #category : 'initialization' }
BNPantallaUbicacion >> segundosDeRevelado [

	^4
]

{ #category : 'acciones' }
BNPantallaUbicacion >> terminarRevelado [

	finRevelado := nil.
	vistaPropia mostrarMinas: false.
	nutria
		decir: 'Ubicá tus naves'
		detalle: #('Elegí una nave de la lista y hacé clic en tu mar. Con R o con Girar cambiás la dirección.')
		cara: #normal
]

{ #category : 'dibujo' }
BNPantallaUbicacion >> textoDeAyuda [

	^#('1. Elegí una nave de la lista de la izquierda.'
		'2. Pasá el mouse por tu mar: la sombra blanca muestra dónde quedaría (roja si no entra).'
		'3. Hacé clic para ubicarla. Con R o con el botón Girar cambiás la dirección.'
		'Las naves no pueden ir sobre islas. Si una cae sobre una mina, pierde 1 vida y ya no se mueve.'
		'Cuando ubiques todas las naves, empieza la batalla.')
]

{ #category : 'dibujo' }
BNPantallaUbicacion >> tituloDelPanel [

	^'Tus naves'
]

{ #category : 'acciones' }
BNPantallaUbicacion >> ubicarAlAzar [

	[self partida ubicarFlotaDelJugadorAlAzar]
		on: BNError
		do: [:error | ^nutria decir: '¡Uy!' detalle: (Array with: error messageText) cara: #triste].
	juego mostrarBatalla
]

{ #category : 'acciones' }
BNPantallaUbicacion >> ubicarEn: unaCoordenada [

	| nave faltan |
	elegida isNil ifTrue: [^self].
	nave := elegida.
	[self partida ubicar: nave desde: unaCoordenada hacia: direccion]
		on: BNError
		do: [:error | ^nutria decir: '¡Ahí no entra!' detalle: (Array with: error messageText) cara: #triste].
	self partida enBatalla ifTrue: [^juego mostrarBatalla].
	faltan := self partida jugador navesSinUbicar.
	self elegir: faltan first.
	nave estaHerida ifTrue: [
		^nutria decir: '¡Mina!' detalle: (Array with: 'Tu ' , nave nombre , ' cayó sobre una mina y perdió 1 vida. Ya no se puede mover.') cara: #sorprendida].
	((self partida jugador tablero casillasDe: nave) anySatisfy: [:unaCasilla | unaCasilla minaDetonada]) ifTrue: [
		^nutria decir: '¡Mina!' detalle: (Array with: 'Tu ' , nave nombre , ' cayó sobre una mina, pero no le hizo nada.') cara: #contenta].
	nutria decir: '¡Bien ubicada!' detalle: (Array with: 'Te faltan ' , faltan size printString , ' naves.') cara: #contenta
]
