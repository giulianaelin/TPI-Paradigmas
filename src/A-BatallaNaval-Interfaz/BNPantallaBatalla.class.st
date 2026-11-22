"
Pantalla de la batalla. El jugador elige una nave a flote (en la lista o en su mar) y hace clic en el mar enemigo para disparar con su arma; mientras mueve el mouse ve en que casillas pegaria. Con las flechas mueve la nave elegida. Con el barreminas puede usar el Sonar (boton Sonar y despues un clic en el mar enemigo). Despues de cada accion, la nutria cuenta lo que paso (tomandolo del registro de la partida). Cuando le toca a la computadora, la hago jugar de a un disparo, con una pausa entre cada uno, y la nutria avisa que hizo y cuando vuelve a ser tu turno. Toda regla del juego la aplica BNPartida.
"
Class {
	#name : 'BNPantallaBatalla',
	#superclass : 'BNPantallaDeJuego',
	#instVars : [
		'vistaEnemiga',
		'elegida',
		'pendientes',
		'flechas',
		'registroVisto',
		'proximaJugada',
		'botonSonar',
		'modoSonar',
		'botonGuardar'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'dibujo' }
BNPantallaBatalla >> accionDeGirar [

	"En la batalla las naves no giran: el boton elige hacia donde sale el torpedo o el ataque rapido."
	^'Apuntar'
]

{ #category : 'acciones' }
BNPantallaBatalla >> actualizarFlechas [

	"Mientras juega el enemigo, todo queda apagado. Si no: las flechas sirven si la nave elegida se puede mover; Apuntar, si su arma usa direccion; Sonar, si la nave tiene sonar listo."
	| libre |
	libre := self esperandoALaComputadora not and: [elegida notNil].
	flechas do: [:unBoton | unBoton habilitado: (libre and: [elegida puedeMoverse])].
	botonGirar habilitado: (libre and: [elegida armaDisponible usaDireccion]).
	botonSonar habilitado: (libre and: [elegida estaAFlote and: [elegida puedeSondear]]).
	botonGuardar habilitado: self esperandoALaComputadora not.
	botonSonar estaHabilitado ifFalse: [modoSonar := false].
	botonSonar elegido: modoSonar == true
]

{ #category : 'eventos' }
BNPantallaBatalla >> actualizarMarcasCon: unPunto tiempo: unosMilisegundos [

	| coordenada cambio |
	cambio := false.
	(proximaJugada notNil and: [unosMilisegundos >= proximaJugada]) ifTrue: [
		self jugarLaComputadora.
		cambio := true].
	coordenada := vistaEnemiga coordenadaEn: unPunto.
	(coordenada notNil and: [elegida notNil and: [self esperandoALaComputadora not]])
		ifTrue: [
			| celdas |
			celdas := modoSonar == true
				ifTrue: [BNSonar new zonaAlrededorDe: coordenada]
				ifFalse: [self celdasApuntadasDesde: coordenada].
			(vistaEnemiga marcar: celdas validas: (modoSonar == true or: [self sonValidas: celdas])) ifTrue: [cambio := true]]
		ifFalse: [(vistaEnemiga marcar: pendientes asArray validas: true) ifTrue: [cambio := true]].
	(vistaPropia marcar: self coordenadasDeLaElegida validas: true) ifTrue: [cambio := true].
	^cambio
]

{ #category : 'acciones' }
BNPantallaBatalla >> alternarSonar [

	"Prende o apaga el modo sonar: con el modo prendido, el proximo clic en el mar enemigo explora en vez de disparar."
	(self esperandoALaComputadora or: [elegida isNil]) ifTrue: [^self].
	modoSonar := modoSonar not.
	botonSonar elegido: modoSonar.
	modoSonar ifTrue: [
		nutria
			decir: 'Sonar listo'
			detalle: #('Hacé clic en el mar enemigo: explora esa casilla y las 8 de alrededor, marca las minas y cuenta las casillas con naves.')
			cara: #normal]
]

{ #category : 'acciones' }
BNPantallaBatalla >> apuntarA: unaCoordenada [

	elegida isNil ifTrue: [^self].
	vistaEnemiga borrarSonar.
	(self partida computadora tablero casillaEn: unaCoordenada) fueAtacada ifTrue: [
		^nutria decir: 'Ya disparaste ahí' detalle: #('Elegí una casilla que todavía no hayas atacado.') cara: #normal].
	(pendientes includes: unaCoordenada) ifTrue: [^self].
	pendientes add: unaCoordenada.
	pendientes size < elegida armaDisponible cantidadDeObjetivos ifTrue: [
		^nutria decir: 'Falta una casilla' detalle: #('El bombardeo pega en 2 casillas: elegí la segunda.') cara: #normal].
	self ejecutar: [self partida disparar: elegida a: pendientes asArray hacia: direccion]
]

{ #category : 'acciones' }
BNPantallaBatalla >> ayudaDe: unaNave [

	| texto |
	texto := 'Acierta el ' , unaNave probabilidadDeImpacto printString , '% de las veces. Si falla, el tiro se desvía a una casilla vecina.'.
	unaNave estaRecargando ifTrue: [
		texto := texto , ' Está recargando (' , unaNave turnosDeRecarga printString , '): mientras tanto dispara con cañón.'].
	unaNave puedeSondear ifTrue: [texto := texto , ' Tiene Sonar: tocá Sonar y elegí dónde explorar (no falla nunca).'].
	unaNave armaDisponible cantidadDeObjetivos > 1 ifTrue: [texto := texto , ' Elegí 2 casillas.'].
	unaNave armaDisponible usaDireccion ifTrue: [texto := texto , ' Elegí la dirección con Apuntar (o la tecla R).'].
	unaNave puedeMoverse ifFalse: [texto := texto , ' Está herida: ya no se mueve.'].
	unaNave estaOculta ifTrue: [texto := texto , ' Está sumergido: el enemigo no ve sus impactos. Si dispara, se le van a ver.'].
	^texto
]

{ #category : 'eventos' }
BNPantallaBatalla >> celdasApuntadasDesde: unaCoordenada [

	"Las casillas donde pegaria el arma de la nave elegida si se dispara ahi."
	| objetivos |
	objetivos := pendientes copyWith: unaCoordenada.
	objetivos size < elegida armaDisponible cantidadDeObjetivos ifTrue: [^objetivos asArray].
	^[(elegida armaDisponible tirosDesde: objetivos asArray hacia: direccion) flatCollect: [:unTiro | unTiro]]
		on: BNError
		do: [:error | objetivos asArray]
]

{ #category : 'eventos' }
BNPantallaBatalla >> clicLibreEn: unPunto [

	| nave coordenada |
	self esperandoALaComputadora ifTrue: [^self].
	nave := panel naveEn: unPunto.
	nave notNil ifTrue: [^self elegir: nave].
	coordenada := vistaPropia coordenadaEn: unPunto.
	coordenada notNil ifTrue: [
		| ocupante |
		ocupante := (self partida jugador tablero casillaEn: coordenada) ocupante.
		(ocupante notNil and: [ocupante estaAFlote]) ifTrue: [self elegir: ocupante].
		^self].
	coordenada := vistaEnemiga coordenadaEn: unPunto.
	coordenada isNil ifTrue: [^self].
	modoSonar == true
		ifTrue: [self sondearEn: coordenada]
		ifFalse: [self apuntarA: coordenada]
]

{ #category : 'avisos' }
BNPantallaBatalla >> contarLoQuePaso [

	"Arma el aviso de la nutria con las lineas nuevas del registro: primero lo del jugador, despues lo de la computadora."
	| registro nuevas corte mias deLaComputadora titulo cara detalle |
	registro := self partida registro.
	nuevas := registro allButFirst: registroVisto.
	registroVisto := registro size.
	corte := nuevas findFirst: [:unaLinea | unaLinea beginsWith: self partida computadora nombre , ':'].
	corte = 0
		ifTrue: [
			mias := nuevas.
			deLaComputadora := #()]
		ifFalse: [
			mias := nuevas first: corte - 1.
			deLaComputadora := nuevas allButFirst: corte - 1].
	titulo := 'Agua'.
	cara := #triste.
	(self lineas: mias incluyen: ': Isla') ifTrue: [titulo := 'Isla'].
	(self lineas: mias incluyen: 'mueve') ifTrue: [titulo := 'Nave movida'. cara := #normal].
	(self lineas: mias incluyen: 'usa Sonar') ifTrue: [titulo := 'Sonar'. cara := #normal].
	(self lineas: mias incluyen: '¡Mina!') ifTrue: [titulo := '¡Mina!'. cara := #sorprendida].
	(self lineas: mias incluyen: '¡Impacto!') ifTrue: [titulo := '¡Impacto!'. cara := #contenta].
	(self lineas: mias incluyen: '¡Hundido!') ifTrue: [titulo := '¡Hundido!'. cara := #contenta].
	detalle := OrderedCollection with: (self resumen: mias).
	(self partida enBatalla and: [self partida turno == self partida jugador])
		ifTrue: [detalle add: '¡Acertaste! Disparás otra vez.']
		ifFalse: [self partida leTocaALaComputadora ifTrue: [detalle add: 'Ahora le toca al enemigo...']].
	deLaComputadora isEmpty ifFalse: [detalle add: 'El enemigo: ' , (self resumen: deLaComputadora)].
	nutria decir: titulo detalle: detalle asArray cara: cara
]

{ #category : 'turno de la computadora' }
BNPantallaBatalla >> contarTurnoDeLaComputadora [

	| registro nuevas teDio titulo detalle |
	registro := self partida registro.
	nuevas := registro allButFirst: registroVisto.
	registroVisto := registro size.
	teDio := (self lineas: nuevas incluyen: '¡Impacto!') or: [self lineas: nuevas incluyen: '¡Hundido!'].
	detalle := OrderedCollection with: 'El enemigo disparó. ' , (self resumen: nuevas).
	self partida leTocaALaComputadora
		ifTrue: [
			titulo := 'Turno del enemigo'.
			detalle add: 'Acertó, así que vuelve a disparar...']
		ifFalse: [
			titulo := '¡Tu turno!'.
			detalle add: 'Elegí una nave y disparale al mar enemigo.'].
	nutria decir: titulo detalle: detalle asArray cara: (teDio ifTrue: [#triste] ifFalse: [#contenta])
]

{ #category : 'eventos' }
BNPantallaBatalla >> coordenadasDeLaElegida [

	elegida isNil ifTrue: [^#()].
	^((self partida jugador tablero casillasDe: elegida) collect: [:unaCasilla | unaCasilla coordenada]) asArray
]

{ #category : 'initialization' }
BNPantallaBatalla >> crearBotones [

	self agregarBotonGirarEn: (918 @ 513 extent: 351 @ 45).
	flechas := OrderedCollection new.
	{ #arriba -> BNCoordenada arriba. #abajo -> BNCoordenada abajo. #izquierda -> BNCoordenada izquierda. #derecha -> BNCoordenada derecha }
		withIndexDo: [:unPar :i |
			flechas add: (self
				agregarBoton: ((918 + ((i - 1) * 90)) @ 561 extent: 81 @ 45)
				texto: ''
				icono: unPar key
				accion: [self mover: unPar value])].
	botonSonar := self agregarBoton: (918 @ 609 extent: 351 @ 45) texto: 'Sonar' icono: #sonar accion: [self alternarSonar].
	botonGuardar := self agregarBoton: (918 @ 657 extent: 171 @ 45) texto: 'Guardar' icono: #guardar accion: [self guardar].
	self agregarBoton: (1098 @ 657 extent: 171 @ 45) texto: 'Menú' icono: #menu accion: [juego mostrarMenu]
]

{ #category : 'dibujo' }
BNPantallaBatalla >> dibujarBloqueoEn: unCanvas [

	"Mientras juega el enemigo, su mar se oscurece con un cartel: no se puede hacer nada ahi."
	| rect fuente titulo detalle |
	rect := vistaEnemiga rectangulo.
	unCanvas fillRectangle: rect color: (Color black alpha: 0.45).
	fuente := self recursos fuente.
	titulo := fuente formaDe: 'Turno del enemigo' escala: 4 color: BNLienzoPixel blanco sombra: BNLienzoPixel oscuro.
	detalle := fuente formaDe: 'Esperá tu turno...' escala: 2 color: BNLienzoPixel blanco sombra: BNLienzoPixel oscuro.
	unCanvas translucentImage: titulo at: (rect center x - (titulo width // 2)) @ (rect center y - 30).
	unCanvas translucentImage: detalle at: (rect center x - (detalle width // 2)) @ (rect center y + 20)
]

{ #category : 'dibujo' }
BNPantallaBatalla >> dibujarLadoDerechoEn: unCanvas [

	self dibujarVentana: (789 @ 15 extent: 480 @ 489) titulo: 'Mar enemigo' en: unCanvas.
	vistaEnemiga dibujarEn: unCanvas con: self recursos.
	self esperandoALaComputadora ifTrue: [self dibujarBloqueoEn: unCanvas]
]

{ #category : 'acciones' }
BNPantallaBatalla >> ejecutar: unaAccion [

	"Hace la accion en el modelo; si el modelo la rechaza, la nutria avisa por que. Despues cuenta lo que paso."
	[unaAccion value]
		on: BNError
		do: [:error |
			pendientes removeAll.
			^nutria decir: '¡No se puede!' detalle: (Array with: error messageText) cara: #triste].
	pendientes removeAll.
	self contarLoQuePaso.
	self partida estaTerminada ifTrue: [^juego mostrarFinDe: self].
	self partida leTocaALaComputadora ifTrue: [proximaJugada := Time millisecondClockValue + self pausa].
	elegida estaAFlote ifFalse: [self elegirSinAviso: self partida jugador navesAFlote first].
	self actualizarFlechas
]

{ #category : 'accessing' }
BNPantallaBatalla >> elegida [

	^elegida
]

{ #category : 'acciones' }
BNPantallaBatalla >> elegir: unaNave [

	elegida := unaNave.
	panel elegida: unaNave.
	pendientes removeAll.
	modoSonar := false.
	self actualizarFlechas.
	nutria
		decir: unaNave nombre , ': ' , unaNave armaDisponible nombre
		detalle: (Array with: (self ayudaDe: unaNave))
		cara: #normal
]

{ #category : 'acciones' }
BNPantallaBatalla >> elegirSinAviso: unaNave [

	elegida := unaNave.
	panel elegida: unaNave
]

{ #category : 'turno de la computadora' }
BNPantallaBatalla >> esperandoALaComputadora [

	^proximaJugada notNil
]

{ #category : 'acciones' }
BNPantallaBatalla >> guardar [

	"Guarda la partida para seguirla despues (no mientras juega el enemigo)."
	self esperandoALaComputadora ifTrue: [^self].
	[juego guardarPartida]
		on: Error
		do: [:error | ^nutria decir: '¡No se pudo guardar!' detalle: (Array with: error messageText) cara: #triste].
	nutria
		decir: 'Partida guardada'
		detalle: #('Podés seguirla cuando quieras desde el menú, con Cargar partida.')
		cara: #contenta
]

{ #category : 'turno de la computadora' }
BNPantallaBatalla >> jugarLaComputadora [

	"Le pide a la partida un disparo de la computadora y cuenta lo que hizo. Si acerto, programa el siguiente."
	proximaJugada := nil.
	[self partida jugarTurnoDeLaComputadora] on: BNError do: [:error | ^self].
	self contarTurnoDeLaComputadora.
	self partida estaTerminada ifTrue: [^juego mostrarFinDe: self].
	self partida leTocaALaComputadora ifTrue: [proximaJugada := Time millisecondClockValue + self pausa].
	elegida estaAFlote ifFalse: [self elegirSinAviso: self partida jugador navesAFlote first].
	self actualizarFlechas
]

{ #category : 'avisos' }
BNPantallaBatalla >> lineas: unasLineas incluyen: unTexto [

	^unasLineas anySatisfy: [:unaLinea | unaLinea includesSubstring: unTexto]
]

{ #category : 'acciones' }
BNPantallaBatalla >> mover: unDesplazamiento [

	(elegida isNil or: [self esperandoALaComputadora]) ifTrue: [^self].
	vistaEnemiga borrarSonar.
	self ejecutar: [self partida mover: elegida hacia: unDesplazamiento]
]

{ #category : 'turno de la computadora' }
BNPantallaBatalla >> pausa [

	"Milisegundos que espera la computadora antes de cada disparo, para que se pueda leer lo que paso y se note que es su turno."
	^3500
]

{ #category : 'initialization' }
BNPantallaBatalla >> prepararse [

	vistaEnemiga := BNVistaTableroEnemigo tablero: self partida computadora tablero origen: 861 @ 96.
	pendientes := OrderedCollection new.
	proximaJugada := nil.
	modoSonar := false.
	registroVisto := self partida registro size.
	panel filtro: [:unaNave | unaNave estaAFlote].
	self elegir: self partida jugador navesAFlote first.
	nutria
		decir: '¡A la batalla!'
		detalle: #('Elegí una nave de tu flota y hacé clic en el mar enemigo para disparar. Con las flechas movés la nave elegida (gasta el turno).')
		cara: #contenta
]

{ #category : 'avisos' }
BNPantallaBatalla >> resumen: unasLineas [

	"Junta en un texto los resultados (las lineas con sangria) y los movimientos."
	| resultados |
	resultados := (unasLineas select: [:unaLinea |
		((unaLinea beginsWith: '  ') or: [unaLinea includesSubstring: 'mueve'])
			and: [(unaLinea includesSubstring: 'vuelve a disparar') not]])
		collect: [:unaLinea | unaLinea trimBoth].
	resultados size > 4 ifTrue: [resultados := resultados last: 4].
	^', ' join: resultados
]

{ #category : 'eventos' }
BNPantallaBatalla >> sonValidas: unasCoordenadas [

	^unasCoordenadas allSatisfy: [:unaCoordenada |
		(self partida computadora tablero casillaEn: unaCoordenada) fueAtacada not]
]

{ #category : 'acciones' }
BNPantallaBatalla >> sondearEn: unaCoordenada [

	"Usa el sonar del barreminas en esa zona. Si el modelo lo acepta, la zona queda marcada en el mar enemigo."
	| salioBien |
	salioBien := false.
	modoSonar := false.
	vistaEnemiga borrarSonar.
	self ejecutar: [
		self partida sondear: unaCoordenada con: elegida.
		salioBien := true].
	salioBien ifTrue: [vistaEnemiga mostrarSonar: (BNSonar new zonaAlrededorDe: unaCoordenada)]
]

{ #category : 'eventos' }
BNPantallaBatalla >> tecla: unCodigo [

	super tecla: unCodigo.
	unCodigo = 30 ifTrue: [self mover: BNCoordenada arriba].
	unCodigo = 31 ifTrue: [self mover: BNCoordenada abajo].
	unCodigo = 28 ifTrue: [self mover: BNCoordenada izquierda].
	unCodigo = 29 ifTrue: [self mover: BNCoordenada derecha]
]

{ #category : 'dibujo' }
BNPantallaBatalla >> tituloDelPanel [

	^'Tu flota'
]

{ #category : 'accessing' }
BNPantallaBatalla >> vistaEnemiga [

	^vistaEnemiga
]
