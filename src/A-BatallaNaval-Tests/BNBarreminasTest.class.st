"
Prueba el barreminas (caracteristica propia): sus datos, que es inmune a las minas, que su sonar explora una zona de 3x3 descubriendo minas y contando casillas con naves, que el sonar recarga, y como se usa desde la partida.
"
Class {
	#name : 'BNBarreminasTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero',
		'barreminas'
	],
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'utilidades' }
BNBarreminasTest >> c: unTexto [

	^BNCoordenada desdeTexto: unTexto
]

{ #category : 'running' }
BNBarreminasTest >> setUp [

	super setUp.
	tablero := BNTablero new.
	barreminas := BNBarreminas new
]

{ #category : 'tests nave' }
BNBarreminasTest >> testDatosDelBarreminas [

	self assert: barreminas tamano equals: 2.
	self assert: barreminas resistencia equals: 2.
	self assert: barreminas nombre equals: 'Barreminas'.
	self assert: barreminas arma class equals: BNCanon
]

{ #category : 'tests nave' }
BNBarreminasTest >> testDespuesDeUsarElSonarTieneQueEsperar3Turnos [

	barreminas registrarUsoDe: barreminas sonar.
	self deny: barreminas puedeSondear.
	self assert: barreminas armaDisponible class equals: BNCanon.
	3 timesRepeat: [barreminas alEmpezarSuTurno].
	self assert: barreminas puedeSondear
]

{ #category : 'tests partida' }
BNBarreminasTest >> testDispararleAUnaMinaNoDaniaAlBarreminas [

	| partida propio mina |
	partida := BNPartidaCertera conRandom: (Random seed: 4).
	partida ubicarFlotaDelJugadorAlAzar.
	propio := partida jugador naves detect: [:unaNave | unaNave class == BNBarreminas].
	mina := partida computadora tablero coordenadasConMina first.
	partida disparar: propio a: { mina } hacia: BNCoordenada horizontal.
	self deny: propio estaHerida.
	self assert: (partida registro anySatisfy: [:unaLinea | unaLinea includesSubstring: 'no le hace nada'])
]

{ #category : 'tests sonar' }
BNBarreminasTest >> testElSonarCuentaCasillasConNavesYDescubreMinas [

	"Un destructor en C2 y D2 y una mina en B3: explorando alrededor de C3 encuentra las dos casillas y la mina."
	tablero ubicar: BNDestructor new desde: (self c: 'C2') hacia: BNCoordenada horizontal.
	tablero armarMinaEn: (self c: 'B3').
	tablero armarMinaEn: (self c: 'H8').
	self assert: (BNSonar new explorar: (self c: 'C3') en: tablero) equals: 2.
	self assert: (tablero tieneMinaDescubiertaEn: (self c: 'B3')).
	self deny: (tablero tieneMinaDescubiertaEn: (self c: 'H8'))
]

{ #category : 'tests sonar' }
BNBarreminasTest >> testElSonarNoCuentaNavesHundidas [

	| destructor |
	destructor := BNDestructor new.
	tablero ubicar: destructor desde: (self c: 'C2') hacia: BNCoordenada horizontal.
	tablero recibirDisparoEn: (self c: 'C2').
	tablero recibirDisparoEn: (self c: 'D2').
	self assert: (BNSonar new explorar: (self c: 'C3') en: tablero) equals: 0
]

{ #category : 'tests nave' }
BNBarreminasTest >> testEsInmuneALasMinasAlUbicarse [

	"Cae sobre una mina: la mina explota, pero no pierde vida."
	tablero armarMinaEn: (self c: 'B2').
	tablero ubicar: barreminas desde: (self c: 'B2') hacia: BNCoordenada horizontal.
	self assert: (tablero casillaEn: (self c: 'B2')) minaDetonada.
	self deny: barreminas estaHerida
]

{ #category : 'tests partida' }
BNBarreminasTest >> testLaFlotaDelJuegoTieneUnBarreminas [

	| flota |
	flota := BNFlota conBarreminas.
	self assert: flota naves size equals: 11.
	self assert: flota casillasNecesarias equals: 36.
	self assert: (flota naves select: [:unaNave | unaNave class == BNBarreminas]) size equals: 1
]

{ #category : 'tests sonar' }
BNBarreminasTest >> testLaZonaEsDe3x3 [

	self assert: (BNSonar new zonaAlrededorDe: (self c: 'E5')) size equals: 9.
	self assert: (BNSonar new zonaAlrededorDe: (self c: 'A1')) size equals: 4
]

{ #category : 'tests nave' }
BNBarreminasTest >> testLasDemasNavesSiPierdenVidaConLaMina [

	| destructor |
	destructor := BNDestructor new.
	tablero armarMinaEn: (self c: 'B2').
	tablero ubicar: destructor desde: (self c: 'B2') hacia: BNCoordenada horizontal.
	self assert: destructor estaHerida
]

{ #category : 'tests partida' }
BNBarreminasTest >> testNoSePuedeSondearConOtraNave [

	| partida acorazado |
	partida := BNPartida conRandom: (Random seed: 4).
	partida ubicarFlotaDelJugadorAlAzar.
	acorazado := partida jugador naves detect: [:unaNave | unaNave class == BNAcorazado].
	self should: [partida sondear: (self c: 'F6') con: acorazado] raise: BNOperacionInvalida
]

{ #category : 'tests nave' }
BNBarreminasTest >> testSoloElBarreminasTieneSonar [

	self assert: barreminas puedeSondear.
	self deny: BNAcorazado new puedeSondear
]

{ #category : 'tests partida' }
BNBarreminasTest >> testSondearGastaElTurnoSinProbabilidad [

	| partida propio naves |
	partida := BNPartida conRandom: (Random seed: 4).
	partida ubicarFlotaDelJugadorAlAzar.
	propio := partida jugador naves detect: [:unaNave | unaNave class == BNBarreminas].
	naves := partida sondear: (self c: 'F6') con: propio.
	self assert: naves equals: ((BNSonar new zonaAlrededorDe: (self c: 'F6')) select: [:unaCoordenada |
		| casilla |
		casilla := partida computadora tablero casillaEn: unaCoordenada.
		casilla estaOcupada and: [casilla ocupante estaAFlote]]) size.
	self assert: partida leTocaALaComputadora.
	self assert: (partida registro anySatisfy: [:unaLinea | unaLinea includesSubstring: 'usa Sonar'])
]
