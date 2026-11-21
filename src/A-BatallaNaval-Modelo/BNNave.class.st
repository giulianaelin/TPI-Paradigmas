"
Es la base abstracta de todas las naves. Recibe impactos y responde si esta herida, hundida o si se puede mover. Cada subclase define su tamaño, su probabilidad de impacto y su nombre; la resistencia es igual a mi tamaño. Lleva la cuenta de impactos y no de casillas: una nave herida no se mueve, así que el daño nunca cambia de lugar.
"
Class {
	#name : 'BNNave',
	#superclass : 'Object',
	#instVars : [
		'impactosRecibidos'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos del tipo' }
BNNave >> arma [
    "El arma con la que dispara. La define cada tipo de nave."
    ^self subclassResponsibility
]

{ #category : 'as yet unclassified' }
BNNave >> estaAFlote [
    "Verdadero si todavia no se hundio."
    ^self estaHundida not
]

{ #category : 'as yet unclassified' }
BNNave >> estaHerida [
    "Verdadero si recibio al menos un impacto."
    ^impactosRecibidos > 0
]

{ #category : 'as yet unclassified' }
BNNave >> estaHundida [
    "Verdadero si ya no le queda resistencia."
    ^self resistenciaRestante = 0
]

{ #category : 'initialization' }
BNNave >> initialize [
    "Una nave nueva no recibio ningun impacto."
    super initialize.
    impactosRecibidos := 0
]

{ #category : 'as yet unclassified' }
BNNave >> nombre [
    "Nombre para mostrar en los mensajes del juego. Lo define cada tipo."
    ^self subclassResponsibility
]

{ #category : 'printing' }
BNNave >> printOn: unStream [
    "Se muestra como 'Acorazado (3/4)': nombre y resistencia restante sobre total."
    unStream
        nextPutAll: self nombre;
        nextPutAll: ' (';
        print: self resistenciaRestante;
        nextPut: $/;
        print: self resistencia;
        nextPut: $)
]

{ #category : 'as yet unclassified' }
BNNave >> probabilidadDeImpacto [
    "Porcentaje (1 a 100) de que un disparo de esta nave salga donde se apunto. La define cada tipo."
    ^self subclassResponsibility
]

{ #category : 'as yet unclassified' }
BNNave >> puedeMoverse [
    "Regla del juego: una nave herida queda inmovil."
    ^self estaHerida not
]

{ #category : 'as yet unclassified' }
BNNave >> recibirImpacto [
    "Registra un impacto. Una nave hundida ya no puede recibir mas."
    self estaHundida ifTrue: [
        ^BNOperacionInvalida signal: 'La nave ya esta hundida'].
    impactosRecibidos := impactosRecibidos + 1
]

{ #category : 'as yet unclassified' }
BNNave >> resistencia [
    "Impactos que aguanta antes de hundirse. En la consigna es igual al tamaño, por eso se define una sola vez aca."
    ^self tamano
]

{ #category : 'as yet unclassified' }
BNNave >> resistenciaRestante [
    "Impactos que todavia aguanta."
    ^self resistencia - impactosRecibidos
]

{ #category : 'as yet unclassified' }
BNNave >> tamano [
    "Cantidad de casillas que ocupa. La define cada tipo de nave."
    ^self subclassResponsibility
]
