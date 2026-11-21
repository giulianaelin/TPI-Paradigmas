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
BNTableroTest >> testNoSePuedeArmarUnaMinaEnUnaIsla [
    "Una isla no admite minas."
    tablero agregarIslaEn: { self c: 'D4' }.
    self should: [tablero armarMinaEn: (self c: 'D4')] raise: BNOperacionInvalida
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
    "Segun nuestras reglas una nave puede caer sobre una mina (despues recibe el daño)."
    | nave |
    nave := Object new.
    tablero armarMinaEn: (self c: 'A1').
    tablero ubicar: nave en: { self c: 'A1'. self c: 'B1' }.
    self assert: (tablero casillaEn: (self c: 'A1')) ocupante equals: nave
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
BNTableroTest >> testUnaNaveAdmiteSusPropiasCasillasParaMoverse [
    "Moverse a la derecha: B1 ya es de la misma nave, asi que se admite."
    | nave |
    nave := Object new.
    tablero ubicar: nave en: { self c: 'A1'. self c: 'B1' }.
    self assert: (tablero puedeUbicar: nave en: { self c: 'B1'. self c: 'C1' })
]
