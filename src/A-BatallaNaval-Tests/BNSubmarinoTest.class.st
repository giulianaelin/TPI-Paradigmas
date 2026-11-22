"
Prueba el ataque sigiloso del submarino: sumergido el enemigo no se entera de sus impactos; cuando ataca sus impactos se ven hasta el proximo turno de su duenio; y si ya ataco y esta herido, se ven para siempre.
"
Class {
	#name : 'BNSubmarinoTest',
	#superclass : 'TestCase',
	#instVars : [
		'submarino',
		'partida'
	],
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'utilidades' }
BNSubmarinoTest >> casillaLibreSinAtacarDe: unJugador [

	"Una casilla de agua, sin mina, sin nave y sin atacar: un disparo ahi seguro es agua."
	^(unJugador tablero casillas detect: [:unaCasilla | unaCasilla estaLibre and: [unaCasilla fueAtacada not]]) coordenada
]

{ #category : 'running' }
BNSubmarinoTest >> setUp [

	super setUp.
	submarino := BNSubmarino new.
	partida := BNPartidaCertera conRandom: (Random seed: 11).
	partida ubicarFlotaDelJugadorAlAzar
]

{ #category : 'utilidades' }
BNSubmarinoTest >> submarinoDe: unJugador [

	^unJugador naves detect: [:unaNave | unaNave class == BNSubmarino]
]

{ #category : 'tests nave' }
BNSubmarinoTest >> testAlAtacarSeVenSusImpactosHastaSuProximoTurno [

	submarino alAtacar.
	self deny: submarino estaOculta.
	submarino alEmpezarSuTurno.
	self assert: submarino estaOculta
]

{ #category : 'tests partida' }
BNSubmarinoTest >> testAlDispararConElSubmarinoSeVenSusImpactos [

	| propio |
	propio := self submarinoDe: partida jugador.
	partida disparar: propio a: { self casillaLibreSinAtacarDe: partida computadora } hacia: BNCoordenada horizontal.
	self deny: propio estaOculta.
	self assert: (partida registro anySatisfy: [:unaLinea | unaLinea includesSubstring: 'sale a la superficie'])
]

{ #category : 'tests partida' }
BNSubmarinoTest >> testCuandoVuelveSuTurnoSeSumergeSiEstaSano [

	"Despues del turno del enemigo, sus impactos se ven solo si quedo herido."
	| propio |
	propio := self submarinoDe: partida jugador.
	partida disparar: propio a: { self casillaLibreSinAtacarDe: partida computadora } hacia: BNCoordenada horizontal.
	partida jugarTurnosDeLaComputadora.
	partida estaTerminada ifTrue: [^self].
	self assert: propio estaOculta not equals: propio estaHerida
]

{ #category : 'tests nave' }
BNSubmarinoTest >> testEmpiezaSumergido [

	self assert: submarino estaOculta.
	self deny: submarino muestraSusImpactos
]

{ #category : 'tests nave' }
BNSubmarinoTest >> testHeridoAntesDeAtacarSigueSumergido [

	"Si lo hieren pero no ataco nunca, sigue oculto."
	submarino recibirImpacto.
	submarino alEmpezarSuTurno.
	self assert: submarino estaOculta
]

{ #category : 'tests nave' }
BNSubmarinoTest >> testLasDemasNavesNoSeEsconden [

	self deny: BNAcorazado new estaOculta
]

{ #category : 'tests partida' }
BNSubmarinoTest >> testPegarleSumergidoParaElAtacanteEsAgua [

	"El jugador le pega al submarino enemigo: el submarino pierde vida, pero el jugador ve agua y no vuelve a disparar."
	| enemigo coordenada acorazado |
	enemigo := self submarinoDe: partida computadora.
	coordenada := ((partida computadora tablero casillasDe: enemigo) detect: [:unaCasilla | unaCasilla fueAtacada not]) coordenada.
	acorazado := partida jugador naves detect: [:unaNave | unaNave class == BNAcorazado].
	partida disparar: acorazado a: { coordenada } hacia: BNCoordenada horizontal.
	self assert: enemigo estaHerida.
	self deny: (partida registro anySatisfy: [:unaLinea | unaLinea includesSubstring: '¡Impacto!']).
	self assert: partida leTocaALaComputadora
]

{ #category : 'tests nave' }
BNSubmarinoTest >> testSiAtacoYEstaHeridoSusImpactosSeVenParaSiempre [

	"No importa el orden: herido y despues ataca, o ataca y despues lo hieren."
	| otro |
	submarino recibirImpacto.
	submarino alAtacar.
	submarino alEmpezarSuTurno.
	self deny: submarino estaOculta.
	otro := BNSubmarino new.
	otro alAtacar.
	otro alEmpezarSuTurno.
	otro recibirImpacto.
	self deny: otro estaOculta
]
