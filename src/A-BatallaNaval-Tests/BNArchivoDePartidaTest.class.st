"
Prueba que una partida guardada con BNArchivoDePartida se recupera igual (fase, turno, registro, naves) y que sin archivo no hay partida para cargar.
"
Class {
	#name : 'BNArchivoDePartidaTest',
	#superclass : 'TestCase',
	#instVars : [
		'archivo',
		'partida'
	],
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'running' }
BNArchivoDePartidaTest >> setUp [

	super setUp.
	archivo := BNArchivoDePartida en: FileLocator imageDirectory asFileReference / 'prueba-batalla-naval.fuel'.
	archivo borrar.
	partida := BNPartida conRandom: (Random seed: 5).
	partida ubicarFlotaDelJugadorAlAzar
]

{ #category : 'running' }
BNArchivoDePartidaTest >> tearDown [

	archivo borrar.
	super tearDown
]

{ #category : 'tests' }
BNArchivoDePartidaTest >> testGuardarYCargarDevuelveLaMismaPartida [

	"La partida cargada es otro objeto, pero con el mismo estado."
	| nave cargada |
	nave := partida jugador naves detect: [:unaNave | unaNave class == BNAcorazado].
	partida disparar: nave a: { partida computadora tablero coordenadasSinAtacar first } hacia: BNCoordenada horizontal.
	archivo guardar: partida.
	self assert: archivo existe.
	cargada := archivo cargar.
	self deny: cargada == partida.
	self assert: cargada fase equals: partida fase.
	self assert: cargada registro equals: partida registro.
	self assert: (cargada turno == cargada jugador) equals: (partida turno == partida jugador).
	self assert: cargada computadora tablero coordenadasSinAtacar size equals: partida computadora tablero coordenadasSinAtacar size.
	self assert: (cargada jugador naves collect: [:unaNave | unaNave resistenciaRestante]) equals: (partida jugador naves collect: [:unaNave | unaNave resistenciaRestante])
]

{ #category : 'tests' }
BNArchivoDePartidaTest >> testLaPartidaCargadaSigueJugandose [

	"Despues de cargar se puede seguir jugando normalmente."
	| cargada |
	archivo guardar: partida.
	cargada := archivo cargar.
	cargada
		disparar: cargada jugador navesAFlote first
		a: { cargada computadora tablero coordenadasSinAtacar first. cargada computadora tablero coordenadasSinAtacar last }
		hacia: BNCoordenada horizontal.
	self assert: cargada registro size > partida registro size
]

{ #category : 'tests' }
BNArchivoDePartidaTest >> testSinArchivoNoHayPartida [

	self deny: archivo existe.
	self should: [archivo cargar] raise: BNOperacionInvalida
]
