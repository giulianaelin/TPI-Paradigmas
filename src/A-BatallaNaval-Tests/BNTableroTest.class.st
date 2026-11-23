"
Prueba BNTablero: la creación de las casillas, las islas (que no se toquen y que una isla inválida no modifique el tablero), las minas y la ubicación de naves. Como todavía no existen las naves, usa Object new como ocupante.
"
Class {
	#name : 'BNTableroTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero'
	],
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'accessing - structure variables' }
BNTableroTest >> c: unTexto [
    "Atajo para escribir coordenadas en los tests, por ejemplo: self c: 'H8'."
    ^BNCoordenada desdeTexto: unTexto
]

{ #category : 'running' }
BNTableroTest >> setUp [
    "Antes de cada test arranca con un tablero nuevo."
    super setUp.
    tablero := BNTablero new
]

{ #category : 'tests' }
BNTableroTest >> testAgregarIslaDeDosCasillas [
    "Una isla de 2 casillas convierte ambas y deja de contarlas como libres."
    tablero agregarIslaEn: { self c: 'B2'. self c: 'C2' }.
    self assert: (tablero casillaEn: (self c: 'B2')) esIsla.
    self assert: (tablero casillaEn: (self c: 'C2')) esIsla.
    self assert: tablero islas size equals: 1.
    self assert: tablero casillasLibres size equals: 142
]

{ #category : 'tests' }
BNTableroTest >> testAlEmpezarTodasLasCasillasEstanLibres [
    "Sin islas, minas ni naves, todas las casillas estan libres."
    self assert: tablero casillasLibres size equals: 144
]

{ #category : 'tests' }
BNTableroTest >> testCasillaEnDevuelveLaCasillaDeEsaCoordenada [
    "Cada coordenada encuentra su propia casilla, incluida la ultima del tablero."
    self assert: (tablero casillaEn: (self c: 'H8')) coordenada equals: (self c: 'H8').
    self assert: (tablero casillaEn: (self c: 'L12')) coordenada equals: (self c: 'L12')
]

{ #category : 'tests' }
BNTableroTest >> testCoordenadasConMina [
    "El tablero informa donde estan las minas, y esas casillas dejan de estar libres."
    tablero
        armarMinaEn: (self c: 'A1');
        armarMinaEn: (self c: 'E5').
    self assert: tablero coordenadasConMina size equals: 2.
    self assert: (tablero coordenadasConMina includes: (self c: 'E5')).
    self assert: tablero casillasLibres size equals: 142
]

{ #category : 'tests' }
BNTableroTest >> testDispararALosRestosDeUnaNaveHundida [
    "Una nave que se hundio por minas puede tener casillas sin atacar: disparar ahi da #restos y no la daña de nuevo."
    | nave |
    nave := BNDestructor new.
    tablero ubicar: nave en: { self c: 'A1'. self c: 'B1' }.
    nave recibirImpacto; recibirImpacto.
    self assert: (tablero recibirDisparoEn: (self c: 'A1')) equals: #restos
]

{ #category : 'tests' }
BNTableroTest >> testDispararAUnaIsla [
    "La isla bloquea el disparo."
    tablero agregarIslaEn: { self c: 'D4' }.
    self assert: (tablero recibirDisparoEn: (self c: 'D4')) equals: #isla
]

{ #category : 'tests' }
BNTableroTest >> testDispararAUnaMina [
    "La mina explota y se devuelve #mina (el daño lo recibe la nave que disparo)."
    tablero armarMinaEn: (self c: 'E5').
    self assert: (tablero recibirDisparoEn: (self c: 'E5')) equals: #mina.
    self assert: (tablero casillaEn: (self c: 'E5')) minaDetonada.
    self assert: tablero coordenadasConMina isEmpty
]

{ #category : 'tests' }
BNTableroTest >> testDispararAUnaNaveHastaHundirla [
    "Un destructor resiste 2 impactos: el primero es #impacto y el segundo #hundido."
    | nave |
    nave := BNDestructor new.
    tablero ubicar: nave en: { self c: 'A1'. self c: 'B1' }.
    self assert: (tablero recibirDisparoEn: (self c: 'A1')) equals: #impacto.
    self assert: nave resistenciaRestante equals: 1.
    self assert: (tablero recibirDisparoEn: (self c: 'B1')) equals: #hundido.
    self assert: nave estaHundida
]

{ #category : 'tests' }
BNTableroTest >> testDispararAlAgua [
    "Un disparo a una casilla vacia devuelve #agua y la deja marcada como atacada."
    self assert: (tablero recibirDisparoEn: (self c: 'H8')) equals: #agua.
    self assert: (tablero casillaEn: (self c: 'H8')) fueAtacada
]

{ #category : 'tests' }
BNTableroTest >> testIslaInvalidaNoDejaElTableroAMedias [
    "F6 estaria bien, pero B3 toca otra isla: no se pone ninguna de las dos."
    tablero agregarIslaEn: { self c: 'B2' }.
    self
        should: [tablero agregarIslaEn: { self c: 'F6'. self c: 'B3' }]
        raise: BNOperacionInvalida.
    self deny: (tablero casillaEn: (self c: 'F6')) esIsla.
    self assert: tablero islas size equals: 1
]

{ #category : 'tests' }
BNTableroTest >> testLasIslasNoPuedenTocarseNiEnDiagonal [
    "C3 toca en diagonal a la isla de B2, asi que no se acepta."
    tablero agregarIslaEn: { self c: 'B2' }.
    self should: [tablero agregarIslaEn: { self c: 'C3' }] raise: BNOperacionInvalida.
    self deny: (tablero casillaEn: (self c: 'C3')) esIsla
]

{ #category : 'tests' }
BNTableroTest >> testMoverUnaNave [
    "Un destructor en A1-B1 se mueve hacia abajo: queda en A2-B2."
    | nave |
    nave := BNDestructor new.
    tablero ubicar: nave desde: (self c: 'A1') hacia: BNCoordenada horizontal.
    tablero mover: nave hacia: BNCoordenada abajo.
    self
        assert: ((tablero casillasDe: nave) collect: [:unaCasilla | unaCasilla coordenada])
        equals: { self c: 'A2'. self c: 'B2' }.
    self deny: (tablero casillaEn: (self c: 'A1')) estaOcupada
]

{ #category : 'tests' }
BNTableroTest >> testMoverseSobreUnaMinaHiere [
    "Si al moverse cae sobre una mina, la mina explota y la nave pierde 1 vida."
    | nave |
    nave := BNDestructor new.
    tablero ubicar: nave desde: (self c: 'A1') hacia: BNCoordenada horizontal.
    tablero armarMinaEn: (self c: 'C1').
    tablero mover: nave hacia: BNCoordenada derecha.
    self assert: nave resistenciaRestante equals: 1.
    self assert: (tablero casillaEn: (self c: 'C1')) minaDetonada
]

{ #category : 'tests' }
BNTableroTest >> testNoSePuedeArmarUnaMinaEnUnaIsla [
    "Una isla no admite minas."
    tablero agregarIslaEn: { self c: 'D4' }.
    self should: [tablero armarMinaEn: (self c: 'D4')] raise: BNOperacionInvalida
]

{ #category : 'tests' }
BNTableroTest >> testNoSePuedeDispararDosVecesEnLaMismaCasilla [
    "Una casilla ya atacada no se puede volver a atacar."
    tablero recibirDisparoEn: (self c: 'H8').
    self should: [tablero recibirDisparoEn: (self c: 'H8')] raise: BNOperacionInvalida
]

{ #category : 'tests' }
BNTableroTest >> testNoSePuedeMoverFueraDelTablero [
    "Desde la fila 1 no se puede subir; la nave queda donde estaba."
    | nave |
    nave := BNDestructor new.
    tablero ubicar: nave desde: (self c: 'A1') hacia: BNCoordenada horizontal.
    self should: [tablero mover: nave hacia: BNCoordenada arriba] raise: BNOperacionInvalida.
    self assert: (tablero casillaEn: (self c: 'A1')) ocupante equals: nave
]

{ #category : 'tests' }
BNTableroTest >> testNoSePuedeUbicarDondeElEnemigoYaDisparo [
    "Una casilla ya atacada no admite naves."
    (tablero casillaEn: (self c: 'A1')) marcarAtacada.
    self deny: (tablero puedeUbicar: Object new en: { self c: 'A1'. self c: 'A2' })
]

{ #category : 'tests' }
BNTableroTest >> testNoSePuedeUbicarUnaNaveSobreUnaIsla [
    "Si una de las casillas es isla, la nave no entra."
    tablero agregarIslaEn: { self c: 'C1' }.
    self deny: (tablero puedeUbicar: Object new en: { self c: 'B1'. self c: 'C1' })
]

{ #category : 'tests' }
BNTableroTest >> testNoSePuedenSuperponerDosNaves [
    "B1 ya esta ocupada por otra nave."
    tablero ubicar: Object new en: { self c: 'A1'. self c: 'B1' }.
    self deny: (tablero puedeUbicar: Object new en: { self c: 'B1'. self c: 'C1' })
]

{ #category : 'tests' }
BNTableroTest >> testNoSeUbicaUnaNaveQuePasaPorUnaIsla [
    "Hay una isla en D2: un acorazado desde B2 hacia la derecha pasaria por ella."
    tablero agregarIslaEn: { self c: 'D2' }.
    self deny: (tablero puedeUbicar: BNAcorazado new desde: (self c: 'B2') hacia: BNCoordenada horizontal).
    self assert: (tablero puedeUbicar: BNAcorazado new desde: (self c: 'B3') hacia: BNCoordenada horizontal)
]

{ #category : 'tests' }
BNTableroTest >> testPuedeAgregarIslaEn [
    "F6-G6 esta lejos de B2; C3 la toca en diagonal; una isla vacia no vale."
    tablero agregarIslaEn: { self c: 'B2' }.
    self assert: (tablero puedeAgregarIslaEn: { self c: 'F6'. self c: 'G6' }).
    self deny: (tablero puedeAgregarIslaEn: { self c: 'C3' }).
    self deny: (tablero puedeAgregarIslaEn: {})
]

{ #category : 'tests' }
BNTableroTest >> testRetirarLiberaLasCasillasDeLaNave [
    "Al retirar la nave, sus casillas quedan desocupadas."
    | nave |
    nave := Object new.
    tablero ubicar: nave en: { self c: 'A1'. self c: 'B1' }.
    tablero retirar: nave.
    self assert: (tablero casillasDe: nave) isEmpty.
    self deny: (tablero casillaEn: (self c: 'A1')) estaOcupada
]

{ #category : 'tests' }
BNTableroTest >> testSePuedeUbicarUnaNaveSobreUnaMina [
    "Una nave puede caer sobre una mina: la mina explota, la nave pierde 1 de resistencia y la casilla queda marcada como atacada."
    | nave casilla |
    nave := BNDestructor new.
    tablero armarMinaEn: (self c: 'A1').
    tablero ubicar: nave en: { self c: 'A1'. self c: 'B1' }.
    casilla := tablero casillaEn: (self c: 'A1').
    self assert: casilla ocupante equals: nave.
    self assert: casilla minaDetonada.
    self assert: casilla fueAtacada.
    self assert: nave resistenciaRestante equals: 1.
    self deny: nave puedeMoverse
]

{ #category : 'tests' }
BNTableroTest >> testTieneUnaCasillaDeAguaPorCoordenada [
    "El tablero de 12x12 tiene 144 casillas y todas empiezan siendo agua."
    self assert: tablero casillas size equals: 144.
    self assert: (tablero casillas allSatisfy: [:unaCasilla | unaCasilla esAgua])
]

{ #category : 'tests' }
BNTableroTest >> testUbicacionInvalidaNoOcupaNingunaCasilla [
    "Si la nave no entra entera, no queda ninguna casilla ocupada."
    tablero agregarIslaEn: { self c: 'C1' }.
    self
        should: [tablero ubicar: Object new en: { self c: 'B1'. self c: 'C1' }]
        raise: BNOperacionInvalida.
    self deny: (tablero casillaEn: (self c: 'B1')) estaOcupada
]

{ #category : 'tests' }
BNTableroTest >> testUbicarNaveHorizontal [
    "Un acorazado (4 casillas) desde B2 hacia la derecha ocupa B2, C2, D2 y E2."
    | nave |
    nave := BNAcorazado new.
    tablero ubicar: nave desde: (self c: 'B2') hacia: BNCoordenada horizontal.
    self
        assert: ((tablero casillasDe: nave) collect: [:unaCasilla | unaCasilla coordenada])
        equals: { self c: 'B2'. self c: 'C2'. self c: 'D2'. self c: 'E2' }
]

{ #category : 'tests' }
BNTableroTest >> testUbicarNaveVertical [
    "Un destructor (2 casillas) desde A11 hacia abajo ocupa A11 y A12, la ultima fila."
    | nave |
    nave := BNDestructor new.
    tablero ubicar: nave desde: (self c: 'A11') hacia: BNCoordenada vertical.
    self
        assert: ((tablero casillasDe: nave) collect: [:unaCasilla | unaCasilla coordenada])
        equals: { self c: 'A11'. self c: 'A12' }
]

{ #category : 'tests' }
BNTableroTest >> testUnaNaveAdmiteSusPropiasCasillasParaMoverse [
    "Moverse a la derecha: B1 ya es de la misma nave, asi que se admite."
    | nave |
    nave := Object new.
    tablero ubicar: nave en: { self c: 'A1'. self c: 'B1' }.
    self assert: (tablero puedeUbicar: nave en: { self c: 'B1'. self c: 'C1' })
]

{ #category : 'tests' }
BNTableroTest >> testUnaNaveHeridaNoSeMueve [
    "Regla del juego: una nave herida queda inmovil."
    | nave |
    nave := BNDestructor new.
    tablero ubicar: nave desde: (self c: 'A1') hacia: BNCoordenada horizontal.
    nave recibirImpacto.
    self should: [tablero mover: nave hacia: BNCoordenada abajo] raise: BNOperacionInvalida
]

{ #category : 'tests' }
BNTableroTest >> testUnaNaveQueNoEntraEnElTableroDaError [
    "Un portaaviones (5 casillas) desde J1 hacia la derecha se saldria del tablero."
    | nave |
    nave := BNPortaaviones new.
    self deny: (tablero puedeUbicar: nave desde: (self c: 'J1') hacia: BNCoordenada horizontal).
    self
        should: [tablero ubicar: nave desde: (self c: 'J1') hacia: BNCoordenada horizontal]
        raise: BNOperacionInvalida.
    self assert: (tablero casillasDe: nave) isEmpty
]
