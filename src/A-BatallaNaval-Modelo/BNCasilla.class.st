"
Una casilla individual. Conoce su coordenada, su terreno (agua o isla), el estado de su mina (sinMina, armada, detonada), si fue atacada y su ocupante. Las islas no admiten minas ni ocupantes. Las reglas de juego las aplica BNTablero.
"
Class {
	#name : 'BNCasilla',
	#superclass : 'Object',
	#instVars : [
		'coordenada',
		'terreno',
		'estadoMina',
		'atacada',
		'ocupante'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'as yet unclassified' }
BNCasilla class >> en: unaCoordenada [
    "Crea una casilla en la posicion indicada."
    ^self new inicializarEn: unaCoordenada
]

{ #category : 'as yet unclassified' }
BNCasilla >> armarMina [

    (self esIsla or: [self estaOcupada])
        ifTrue: [
            ^BNOperacionInvalida signal:
                'No se puede colocar una mina sobre una isla o un barco'
        ].

    estadoMina == #sinMina
        ifFalse: [
            ^BNOperacionInvalida signal:
                'La casilla ya tiene una mina'
        ].

    estadoMina := #armada
]

{ #category : 'as yet unclassified' }
BNCasilla >> convertirEnIsla [
    (estadoMina ~~ #sinMina or: [self estaOcupada])
        ifTrue: [
            ^BNOperacionInvalida signal:
                'No se puede convertir en isla una casilla con mina u ocupada'
        ].
    terreno := #isla
]

{ #category : 'accessing' }
BNCasilla >> coordenada [
    "Devuelve la posicion de esta casilla."
    ^coordenada
]

{ #category : 'as yet unclassified' }
BNCasilla >> detonarMina [

    self tieneMinaActiva
        ifFalse: [
            ^BNOperacionInvalida signal:
                'La casilla no tiene una mina armada'
        ].

    estadoMina := #detonada
]

{ #category : 'as yet unclassified' }
BNCasilla >> esAgua [
    "Comprueba si la casilla es agua."
    ^terreno == #agua
]

{ #category : 'as yet unclassified' }
BNCasilla >> esIsla [
    ^terreno == #isla
]

{ #category : 'as yet unclassified' }
BNCasilla >> estaOcupada [
    ^ocupante notNil
]

{ #category : 'accessing' }
BNCasilla >> estadoMina [
    "Devuelve el estado actual de la mina en la casilla."
    ^estadoMina
]

{ #category : 'as yet unclassified' }
BNCasilla >> fueAtacada [
    "Comprueba si la casilla ya recibio un ataque."
    ^atacada
]

{ #category : 'as yet unclassified' }
BNCasilla >> inicializarEn: unaCoordenada [
    "Asigna una posicion a la casilla."
    coordenada := unaCoordenada
]

{ #category : 'initialization' }
BNCasilla >> initialize [
    "Establece los valores iniciales de una casilla."
    super initialize.
    terreno := #agua.
    estadoMina := #sinMina.
    atacada := false.
    ocupante := nil
]

{ #category : 'as yet unclassified' }
BNCasilla >> liberar [
    "Quita el barco que ocupa la casilla."
    ocupante := nil
]

{ #category : 'as yet unclassified' }
BNCasilla >> marcarAtacada [
    "Registra que esta casilla recibio un ataque."
    atacada := true
]

{ #category : 'as yet unclassified' }
BNCasilla >> minaDetonada [
    "Comprueba si la mina de esta casilla ya exploto."
    ^estadoMina == #detonada
]

{ #category : 'accessing' }
BNCasilla >> ocupante [
    "Devuelve el barco que ocupa esta casilla."
    ^ocupante
]

{ #category : 'as yet unclassified' }
BNCasilla >> ocuparCon: unOcupante [
    "Coloca un barco en una casilla si esta disponible."

    self esIsla ifTrue: [
        ^BNOperacionInvalida signal:
            'No se puede colocar un barco sobre una isla'
    ].

    self fueAtacada ifTrue: [
        ^BNOperacionInvalida signal:
            'No se puede ocupar una casilla que ya fue atacada'
    ].

    self estaOcupada ifTrue: [
        ^BNOperacionInvalida signal:
            'La casilla ya esta ocupada'
    ].

    unOcupante isNil ifTrue: [
        ^BNOperacionInvalida signal:
            'El ocupante no puede ser nil'
    ].

    ocupante := unOcupante
]

{ #category : 'as yet unclassified' }
BNCasilla >> tieneMinaActiva [
    "Comprueba si hay una mina lista para explotar."
    ^estadoMina == #armada
]
