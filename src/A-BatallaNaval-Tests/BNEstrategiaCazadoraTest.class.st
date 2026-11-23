"
Prueba la estrategia intermedia: caza al azar mientras no hay impactos, remata alrededor de una nave tocada y deja de rematar cuando la nave se hunde.
"
Class {
	#name : 'BNEstrategiaCazadoraTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero',
		'partida',
		'estrategia'
	],
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'running' }
BNEstrategiaCazadoraTest >> setUp [

	super setUp.
	tablero := BNTablero new.
	partida := BNPartida conRandom: (Random seed: 3).
	estrategia := BNEstrategiaCazadora new
]

{ #category : 'tests' }
BNEstrategiaCazadoraTest >> testNoRemataUnSubmarinoSumergido [

	"Si toco un submarino sumergido no se entero: no hay nada para rematar. Cuando el submarino ataca, si."
	| sub |
	sub := BNSubmarino new.
	tablero ubicar: sub desde: (BNCoordenada desdeTexto: 'B2') hacia: BNCoordenada horizontal.
	tablero recibirDisparoEn: (BNCoordenada desdeTexto: 'B2').
	self assert: (estrategia casillasParaRematarEn: tablero) isEmpty.
	sub alAtacar.
	self deny: (estrategia casillasParaRematarEn: tablero) isEmpty
]

{ #category : 'tests' }
BNEstrategiaCazadoraTest >> testNoRemataUnaNaveHundida [

	"Cuando la nave tocada se hunde, ya no hay nada para rematar."
	self ubicarDestructorEnB2.
	tablero recibirDisparoEn: (BNCoordenada desdeTexto: 'B2').
	tablero recibirDisparoEn: (BNCoordenada desdeTexto: 'C2').
	self assert: (estrategia casillasParaRematarEn: tablero) isEmpty
]

{ #category : 'tests' }
BNEstrategiaCazadoraTest >> testRemataAlrededorDeUnImpacto [

	"Despues de tocar B2, dispara a una vecina de B2 (A2, B1, B3 o C2)."
	| elegidas vecinas |
	self ubicarDestructorEnB2.
	tablero recibirDisparoEn: (BNCoordenada desdeTexto: 'B2').
	vecinas := #('A2' 'B1' 'B3' 'C2') collect: [:unTexto | BNCoordenada desdeTexto: unTexto].
	elegidas := estrategia elegirObjetivos: 1 en: tablero con: partida.
	self assert: (vecinas includes: elegidas first)
]

{ #category : 'tests' }
BNEstrategiaCazadoraTest >> testSiFaltanVecinasCompletaAlAzar [

	"El bombardeo pide 2 casillas: si para rematar hay menos, completa al azar con casillas distintas."
	| destructor elegidas |
	destructor := BNDestructor new.
	tablero ubicar: destructor desde: (BNCoordenada desdeTexto: 'A1') hacia: BNCoordenada horizontal.
	tablero recibirDisparoEn: (BNCoordenada desdeTexto: 'A1').
	tablero recibirDisparoEn: (BNCoordenada desdeTexto: 'A2').
	elegidas := estrategia elegirObjetivos: 2 en: tablero con: partida.
	self assert: elegidas size equals: 2.
	self assert: elegidas asSet size equals: 2.
	self assert: (elegidas includes: (BNCoordenada desdeTexto: 'B1'))
]

{ #category : 'tests' }
BNEstrategiaCazadoraTest >> testSinImpactosCazaAlAzar [

	"Sin naves tocadas no hay nada para rematar: elige una casilla sin atacar cualquiera."
	| elegidas |
	self assert: (estrategia casillasParaRematarEn: tablero) isEmpty.
	elegidas := estrategia elegirObjetivos: 1 en: tablero con: partida.
	self assert: elegidas size equals: 1.
	self deny: (tablero casillaEn: elegidas first) fueAtacada
]

{ #category : 'utilidades' }
BNEstrategiaCazadoraTest >> ubicarDestructorEnB2 [

	"Un destructor horizontal en B2 y C2."
	| destructor |
	destructor := BNDestructor new.
	tablero ubicar: destructor desde: (BNCoordenada desdeTexto: 'B2') hacia: BNCoordenada horizontal.
	^destructor
]
