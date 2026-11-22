"
Partida para los tests: igual a BNPartida, pero los disparos nunca se desvian. Asi un test puede apuntar a una casilla y saber que el tiro cae ahi.
"
Class {
	#name : 'BNPartidaCertera',
	#superclass : 'BNPartida',
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'azar' }
BNPartidaCertera >> aciertaTiradaDe: unaNave [

	"En los tests todos los disparos salen donde se apunto."
	^true
]
