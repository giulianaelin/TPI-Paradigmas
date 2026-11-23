"
Prueba la jerarquia de naves: los datos de cada tipo (tamaño, resistencia y probabilidad de impacto) y como una nave recibe daño hasta hundirse.
"
Class {
	#name : 'BNNaveTest',
	#superclass : 'TestCase',
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'tests' }
BNNaveTest >> testConTodosLosImpactosSeHunde [
    "Un destructor resiste 2 impactos: con el segundo se hunde."
    | nave |
    nave := BNDestructor new.
    nave recibirImpacto; recibirImpacto.
    self assert: nave resistenciaRestante equals: 0.
    self assert: nave estaHundida.
    self deny: nave estaAFlote
]

{ #category : 'tests' }
BNNaveTest >> testDatosDeCadaTipo [
    "Tamaño y probabilidad de cada tipo; la resistencia es igual al tamaño."
    {
        BNPortaaviones -> #(5 75).
        BNAcorazado -> #(4 95).
        BNCrucero -> #(3 70).
        BNSubmarino -> #(3 80).
        BNDestructor -> #(2 85) } do: [:unPar |
            | nave |
            nave := unPar key new.
            self assert: nave tamano equals: unPar value first.
            self assert: nave resistencia equals: unPar value first.
            self assert: nave probabilidadDeImpacto equals: unPar value last]
]

{ #category : 'tests' }
BNNaveTest >> testElAcorazadoTieneLaMayorProbabilidad [
    "Los cañones pesados del acorazado: mas probabilidad que cualquier otra nave."
    { BNPortaaviones. BNCrucero. BNSubmarino. BNDestructor } do: [:unTipo |
        self assert: BNAcorazado new probabilidadDeImpacto > unTipo new probabilidadDeImpacto]
]

{ #category : 'tests' }
BNNaveTest >> testNoSePuedeImpactarUnaNaveHundida [
    "Una nave hundida ya no recibe mas impactos."
    | nave |
    nave := BNDestructor new.
    nave recibirImpacto; recibirImpacto.
    self should: [nave recibirImpacto] raise: BNOperacionInvalida
]

{ #category : 'tests' }
BNNaveTest >> testRecibirUnImpactoLaHiereYNoPuedeMoverse [
    "Con un impacto pierde 1 de resistencia, queda herida y ya no se puede mover."
    | nave |
    nave := BNCrucero new.
    nave recibirImpacto.
    self assert: nave resistenciaRestante equals: 2.
    self assert: nave estaHerida.
    self deny: nave estaHundida.
    self deny: nave puedeMoverse
]

{ #category : 'tests' }
BNNaveTest >> testSeMuestraConSuNombreYSuVida [
    "Asi aparece en el Playground y en los mensajes: nombre y resistencia restante/total."
    | nave |
    nave := BNAcorazado new.
    self assert: nave printString equals: 'Acorazado (4/4)'.
    nave recibirImpacto.
    self assert: nave printString equals: 'Acorazado (3/4)'
]

{ #category : 'tests' }
BNNaveTest >> testUnaNaveNuevaEstaSana [
    "Recien creada: resistencia completa, a flote y se puede mover."
    | nave |
    nave := BNPortaaviones new.
    self assert: nave resistenciaRestante equals: 5.
    self deny: nave estaHerida.
    self deny: nave estaHundida.
    self assert: nave estaAFlote.
    self assert: nave puedeMoverse
]
