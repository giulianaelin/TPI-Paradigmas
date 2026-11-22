"
Guardo como es el terreno de un tablero: los tamanos de las islas y la cantidad de minas (la estandar: islas de 1, 1 y 2 casillas y 4 minas). Valido que la configuracion tenga sentido y me puedo pasar a un estado simple y reconstruir desde el. BNGeneradorTerreno me usa para saber que colocar.
"
Class {
	#name : 'BNConfiguracionTerreno',
	#superclass : 'Object',
	#instVars : [
		'tamanosDeIslas',
		'cantidadDeMinas'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'as yet unclassified' }
BNConfiguracionTerreno class >> desdeEstado: unEstado [
    "Reconstruye una configuracion desde datos guardados."
    ^self
        tamanosDeIslas: (unEstado at: 'tamanosDeIslas')
        cantidadDeMinas: (unEstado at: 'cantidadDeMinas')
]

{ #category : 'as yet unclassified' }
BNConfiguracionTerreno class >> estandar [
    "Crea la configuracion normal del juego."
    ^self
        tamanosDeIslas: #(1 1 2)
        cantidadDeMinas: 4
]

{ #category : 'as yet unclassified' }
BNConfiguracionTerreno class >> tamanosDeIslas: unosTamanos cantidadDeMinas: unaCantidad [
    "Crea una configuracion con los valores indicados."
    ^self new
        inicializarTamanosDeIslas: unosTamanos
        cantidadDeMinas: unaCantidad
]

{ #category : 'as yet unclassified' }
BNConfiguracionTerreno >> cantidadDeIslas [
    "Devuelve cuantas islas tiene el tablero."
    ^tamanosDeIslas size
]

{ #category : 'accessing' }
BNConfiguracionTerreno >> cantidadDeMinas [
    "Devuelve la cantidad de minas del tablero."
    ^cantidadDeMinas
]

{ #category : 'as yet unclassified' }
BNConfiguracionTerreno >> cantidadTotalDeCasillasDeIsla [
    "Calcula cuantas casillas ocupan todas las islas."
    ^tamanosDeIslas inject: 0 into: [:suma :tamano |
        suma + tamano]
]

{ #category : 'as yet unclassified' }
BNConfiguracionTerreno >> estadoSerializable [
    "Prepara los datos de configuracion para guardarlos."
    ^Dictionary new
        at: 'tamanosDeIslas' put: tamanosDeIslas copy;
        at: 'cantidadDeMinas' put: cantidadDeMinas;
        yourself
]

{ #category : 'as yet unclassified' }
BNConfiguracionTerreno >> inicializarTamanosDeIslas: unosTamanos cantidadDeMinas: unaCantidad [
    "Configura las islas y minas, comprobando que los valores sean correctos."

    (unosTamanos isCollection and: [unosTamanos isNotEmpty])
        ifFalse: [
            ^BNConfiguracionInvalida signal:
                'Se necesita al menos una isla'
        ].

    (unosTamanos allSatisfy: [:tamano |
        tamano isInteger and: [
            tamano between: 1 and: BNCoordenada dimension
        ]])
        ifFalse: [
            ^BNConfiguracionInvalida signal:
                'Cada isla debe tener entre 1 y 12 casillas'
        ].

    (unaCantidad isInteger and: [unaCantidad >= 0])
        ifFalse: [
            ^BNConfiguracionInvalida signal:
                'La cantidad de minas debe ser un entero no negativo'
        ].

    tamanosDeIslas := unosTamanos asArray copy.
    cantidadDeMinas := unaCantidad.
    ^self
]

{ #category : 'initialization' }
BNConfiguracionTerreno >> initialize [
    "Establece los valores predeterminados del terreno." "Configura las tres islas y las cuatro minas del tablero."
    super initialize.
    self
        inicializarTamanosDeIslas: #(1 1 2)
        cantidadDeMinas: 4
]

{ #category : 'accessing' }
BNConfiguracionTerreno >> tamanosDeIslas [
    "Devuelve los tamanos de las islas del tablero."
    ^tamanosDeIslas copy
]
