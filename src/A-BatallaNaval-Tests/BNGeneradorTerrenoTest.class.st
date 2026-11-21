"
Prueba que BNGeneradorTerreno ubique las islas y minas de la configuracion respetando las reglas del tablero. Usa un Random con semilla fija para que el resultado no dependa de la suerte.
"
Class {
	#name : 'BNGeneradorTerrenoTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero',
		'generador'
	],
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'utilidades' }
BNGeneradorTerrenoTest >> generarEstandar [
    "Genera el terreno estandar: islas #(1 1 2) y 4 minas."
    generador generarEn: tablero segun: BNConfiguracionTerreno estandar
]

{ #category : 'running' }
BNGeneradorTerrenoTest >> setUp [
    "Tablero vacio y generador con semilla fija."
    super setUp.
    tablero := BNTablero new.
    generador := BNGeneradorTerreno conRandom: (Random seed: 42)
]

{ #category : 'tests' }
BNGeneradorTerrenoTest >> testConLaMismaSemillaGeneraElMismoTerreno [
    "Mismo azar, mismo resultado: por eso los tests son confiables."
    | otroTablero |
    otroTablero := BNTablero new.
    self generarEstandar.
    (BNGeneradorTerreno conRandom: (Random seed: 42))
        generarEn: otroTablero segun: BNConfiguracionTerreno estandar.
    self assert: otroTablero islas asArray equals: tablero islas asArray.
    self assert: otroTablero coordenadasConMina equals: tablero coordenadasConMina
]

{ #category : 'tests' }
BNGeneradorTerrenoTest >> testGeneraLasIslasDeLaConfiguracion [
    "Tres islas: dos de 1 casilla y una de 2, o sea 4 casillas de isla."
    self generarEstandar.
    self assert: tablero islas size equals: 3.
    self assert: (tablero islas collect: [:unaIsla | unaIsla size]) asSortedCollection asArray equals: #(1 1 2).
    self assert: (tablero casillas select: [:unaCasilla | unaCasilla esIsla]) size equals: 4
]

{ #category : 'tests' }
BNGeneradorTerrenoTest >> testGeneraLasMinasFueraDeLasIslas [
    "Cuatro minas, ninguna sobre una isla."
    self generarEstandar.
    self assert: tablero coordenadasConMina size equals: 4.
    self assert: (tablero coordenadasConMina allSatisfy: [:unaCoordenada |
        (tablero casillaEn: unaCoordenada) esIsla not])
]

{ #category : 'tests' }
BNGeneradorTerrenoTest >> testLaIslaDeDosCasillasEsContigua [
    "Las dos casillas de la isla grande estan pegadas (arriba, abajo o al costado)."
    | islaGrande |
    self generarEstandar.
    islaGrande := tablero islas detect: [:unaIsla | unaIsla size = 2].
    self assert: (islaGrande first vecinosOrtogonales includes: islaGrande last)
]

{ #category : 'tests' }
BNGeneradorTerrenoTest >> testLasIslasNoSeTocan [
    "Ninguna casilla de una isla es vecina, ni en diagonal, de otra isla."
    self generarEstandar.
    tablero islas do: [:unaIsla |
        tablero islas do: [:otraIsla |
            unaIsla == otraIsla ifFalse: [
                unaIsla do: [:unaCoordenada |
                    self deny: (otraIsla anySatisfy: [:otraCoordenada |
                        unaCoordenada vecinosConDiagonales includes: otraCoordenada])]]]]
]

{ #category : 'tests' }
BNGeneradorTerrenoTest >> testQuedanLibresLasCasillasRestantes [
    "144 - 4 de isla - 4 de mina = 136 libres."
    self generarEstandar.
    self assert: tablero casillasLibres size equals: 136
]

{ #category : 'tests' }
BNGeneradorTerrenoTest >> testSinLugarParaLasMinasDaError [
    "En 144 casillas no entran 200 minas."
    self
        should: [generador
            generarEn: tablero
            segun: (BNConfiguracionTerreno tamanosDeIslas: #(1) cantidadDeMinas: 200)]
        raise: BNConfiguracionInvalida
]
