"
Represento a un participante de la partida (la persona o la computadora): tengo un nombre, mi tablero y mi flota. Respondo que naves me faltan ubicar y si fui derrotado.
"
Class {
	#name : 'BNJugador',
	#superclass : 'Object',
	#instVars : [
		'nombre',
		'tablero',
		'flota'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'instance creation' }
BNJugador class >> nombre: unNombre [
    "Crea un jugador con un tablero vacio y la flota estandar."
    ^self new setNombre: unNombre
]

{ #category : 'testing' }
BNJugador >> estaDerrotado [
    "Perdi si toda mi flota esta hundida."
    ^flota estaDestruida
]

{ #category : 'accessing' }
BNJugador >> flota [
    ^flota
]

{ #category : 'accessing' }
BNJugador >> naves [
    "Las naves de mi flota, en orden."
    ^flota naves
]

{ #category : 'accessing' }
BNJugador >> navesAFlote [
    ^flota navesAFlote
]

{ #category : 'accessing' }
BNJugador >> navesSinUbicar [
    "Las naves que todavia no estan en mi tablero."
    ^flota naves select: [:unaNave | (tablero casillasDe: unaNave) isEmpty]
]

{ #category : 'accessing' }
BNJugador >> nombre [
    ^nombre
]

{ #category : 'initialization' }
BNJugador >> setNombre: unNombre [
    nombre := unNombre.
    tablero := BNTablero new.
    flota := BNFlota conBarreminas
]

{ #category : 'accessing' }
BNJugador >> tablero [
    ^tablero
]

{ #category : 'testing' }
BNJugador >> tieneLaNave: unaNave [
    "Verdadero si la nave es de mi flota."
    ^flota naves anySatisfy: [:otraNave | otraNave == unaNave]
]
