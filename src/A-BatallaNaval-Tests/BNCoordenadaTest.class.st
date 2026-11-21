"
Prueba las lineas de coordenadas (lineaDe:hacia: y cabeLineaDe:hacia:) que usan las islas y despues los barcos.
"
Class {
	#name : 'BNCoordenadaTest',
	#superclass : 'TestCase',
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'tests' }
BNCoordenadaTest >> testCabeLineaCercaDelBorde [
    "Desde K1 entran 2 casillas a la derecha (K y L), pero no 3."
    self assert: ((BNCoordenada desdeTexto: 'K1') cabeLineaDe: 2 hacia: BNCoordenada horizontal).
    self deny: ((BNCoordenada desdeTexto: 'K1') cabeLineaDe: 3 hacia: BNCoordenada horizontal).
    self deny: ((BNCoordenada desdeTexto: 'A11') cabeLineaDe: 3 hacia: BNCoordenada vertical)
]

{ #category : 'tests' }
BNCoordenadaTest >> testLineaHorizontal [
    "Desde B2, tres casillas hacia la derecha: B2, C2, D2."
    self
        assert: ((BNCoordenada desdeTexto: 'B2') lineaDe: 3 hacia: BNCoordenada horizontal)
        equals: { BNCoordenada desdeTexto: 'B2'. BNCoordenada desdeTexto: 'C2'. BNCoordenada desdeTexto: 'D2' }
]

{ #category : 'tests' }
BNCoordenadaTest >> testLineaQueSeSaleDelTableroDaError [
    "Pedir una linea que no entra da error de coordenada."
    self
        should: [(BNCoordenada desdeTexto: 'K1') lineaDe: 3 hacia: BNCoordenada horizontal]
        raise: BNCoordenadaInvalida
]

{ #category : 'tests' }
BNCoordenadaTest >> testLineaVertical [
    "Desde B2, tres casillas hacia abajo: B2, B3, B4."
    self
        assert: ((BNCoordenada desdeTexto: 'B2') lineaDe: 3 hacia: BNCoordenada vertical)
        equals: { BNCoordenada desdeTexto: 'B2'. BNCoordenada desdeTexto: 'B3'. BNCoordenada desdeTexto: 'B4' }
]
