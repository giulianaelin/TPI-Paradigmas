"
Prueba el tiempo de recarga de las armas especiales: despues de usarlas la nave dispara con un canon comun hasta que pasan los turnos que pide su arma; el canon no recarga y usarlo mientras tanto no reinicia la espera.
"
Class {
	#name : 'BNRecargaTest',
	#superclass : 'TestCase',
	#instVars : [
		'crucero'
	],
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'running' }
BNRecargaTest >> setUp [

	super setUp.
	crucero := BNCrucero new
]

{ #category : 'tests' }
BNRecargaTest >> testCadaArmaDiceCuantoRecarga [

	self assert: BNCanon new turnosDeRecarga equals: 0.
	self assert: BNTorpedo new turnosDeRecarga equals: 2.
	self assert: BNBombardeo new turnosDeRecarga equals: 2.
	self assert: BNAtaqueRapido new turnosDeRecarga equals: 1
]

{ #category : 'tests' }
BNRecargaTest >> testDespuesDeUsarElTorpedoDisparaConCanon [

	crucero registrarUsoDe: crucero arma.
	self assert: crucero estaRecargando.
	self assert: crucero armaDisponible class equals: BNCanon
]

{ #category : 'tests' }
BNRecargaTest >> testDispararConElCanonNoReiniciaLaRecarga [

	crucero registrarUsoDe: crucero arma.
	crucero alEmpezarSuTurno.
	crucero registrarUsoDe: crucero armaDisponible.
	self assert: crucero turnosDeRecarga equals: 1
]

{ #category : 'tests' }
BNRecargaTest >> testElCanonNuncaRecarga [

	| acorazado |
	acorazado := BNAcorazado new.
	acorazado registrarUsoDe: acorazado arma.
	self deny: acorazado estaRecargando
]

{ #category : 'tests' }
BNRecargaTest >> testElSubmarinoTambienAvanzaSuRecarga [

	"El submarino redefine alEmpezarSuTurno para sumergirse, pero igual hace lo de toda nave."
	| submarino |
	submarino := BNSubmarino new.
	submarino registrarUsoDe: BNTorpedo new.
	submarino alEmpezarSuTurno.
	self assert: submarino turnosDeRecarga equals: 1
]

{ #category : 'tests' }
BNRecargaTest >> testEnLaPartidaElTorpedoQuedaRecargando [

	| partida propio libre |
	partida := BNPartidaCertera conRandom: (Random seed: 11).
	partida ubicarFlotaDelJugadorAlAzar.
	propio := partida jugador naves detect: [:unaNave | unaNave class == BNCrucero].
	libre := (partida computadora tablero casillas detect: [:unaCasilla | unaCasilla estaLibre and: [unaCasilla fueAtacada not]]) coordenada.
	partida disparar: propio a: { libre } hacia: BNCoordenada horizontal.
	self assert: (partida registro anySatisfy: [:unaLinea | unaLinea includesSubstring: 'usa Torpedo']).
	self assert: propio estaRecargando
]

{ #category : 'tests' }
BNRecargaTest >> testLaRecargaBajaCuandoEmpiezaSuTurno [

	"El torpedo pide 2: en el turno siguiente todavia recarga, en el otro ya esta listo."
	crucero registrarUsoDe: crucero arma.
	crucero alEmpezarSuTurno.
	self assert: crucero armaDisponible class equals: BNCanon.
	crucero alEmpezarSuTurno.
	self assert: crucero armaDisponible class equals: BNTorpedo
]

{ #category : 'tests' }
BNRecargaTest >> testUnaNaveNuevaTieneSuArmaLista [

	self deny: crucero estaRecargando.
	self assert: crucero armaDisponible class equals: BNTorpedo
]
