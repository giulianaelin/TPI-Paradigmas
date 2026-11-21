"
Prueba las armas: a que casillas pega cada una y como arma sus tiros. Tambien que cada tipo de nave tenga su arma.
"
Class {
	#name : 'BNArmaTest',
	#superclass : 'TestCase',
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'utilidades' }
BNArmaTest >> c: unTexto [
    ^BNCoordenada desdeTexto: unTexto
]

{ #category : 'tests' }
BNArmaTest >> testCadaNaveTieneSuArma [
    "Portaaviones: bombardeo; acorazado y submarino: cañon; crucero: torpedo; destructor: ataque rapido."
    self assert: BNPortaaviones new arma class equals: BNBombardeo.
    self assert: BNAcorazado new arma class equals: BNCanon.
    self assert: BNCrucero new arma class equals: BNTorpedo.
    self assert: BNSubmarino new arma class equals: BNCanon.
    self assert: BNDestructor new arma class equals: BNAtaqueRapido
]

{ #category : 'tests' }
BNArmaTest >> testCantidadDeObjetivosIncorrectaDaError [
    "El cañon necesita exactamente una casilla."
    self
        should: [BNCanon new tirosDesde: {} hacia: BNCoordenada horizontal]
        raise: BNOperacionInvalida
]

{ #category : 'tests' }
BNArmaTest >> testElAtaqueRapidoHaceDosTirosSeguidos [
    "Dos tiros independientes: la casilla elegida y la siguiente."
    self
        assert: (BNAtaqueRapido new tirosDesde: { self c: 'C3' } hacia: BNCoordenada horizontal)
        equals: { { self c: 'C3' }. { self c: 'D3' } }
]

{ #category : 'tests' }
BNArmaTest >> testElBombardeoHaceDosTirosADosCasillas [
    "Dos tiros independientes, uno a cada casilla elegida."
    self assert: BNBombardeo new cantidadDeObjetivos equals: 2.
    self
        assert: (BNBombardeo new tirosDesde: { self c: 'A1'. self c: 'H8' } hacia: BNCoordenada horizontal)
        equals: { { self c: 'A1' }. { self c: 'H8' } }
]

{ #category : 'tests' }
BNArmaTest >> testElBombardeoNecesitaCasillasDistintas [
    "No se puede bombardear dos veces la misma casilla."
    self
        should: [BNBombardeo new tirosDesde: { self c: 'A1'. self c: 'A1' } hacia: BNCoordenada horizontal]
        raise: BNOperacionInvalida
]

{ #category : 'tests' }
BNArmaTest >> testElCanonHaceUnTiroAUnaCasilla [
    "Un solo tiro a la casilla elegida."
    self
        assert: (BNCanon new tirosDesde: { self c: 'C3' } hacia: BNCoordenada horizontal)
        equals: { { self c: 'C3' } }
]

{ #category : 'tests' }
BNArmaTest >> testElTorpedoCercaDelBordePierdeLoQueSale [
    "Desde K1 hacia la derecha solo entran K1 y L1."
    self
        assert: (BNTorpedo new tirosDesde: { self c: 'K1' } hacia: BNCoordenada horizontal)
        equals: { { self c: 'K1'. self c: 'L1' } }
]

{ #category : 'tests' }
BNArmaTest >> testElTorpedoPegaATresCasillasEnLinea [
    "Un solo tiro que cubre 3 casillas."
    self
        assert: (BNTorpedo new tirosDesde: { self c: 'C3' } hacia: BNCoordenada vertical)
        equals: { { self c: 'C3'. self c: 'C4'. self c: 'C5' } }
]
