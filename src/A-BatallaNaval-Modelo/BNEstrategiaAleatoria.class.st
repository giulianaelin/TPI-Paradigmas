"
Estrategia de la computadora en dificultad facil: elige al azar casillas del tablero enemigo a las que todavia no disparo. El azar lo pone la partida (asi se controla con una semilla en los tests).
"
Class {
	#name : 'BNEstrategiaAleatoria',
	#superclass : 'Object',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'eleccion' }
BNEstrategiaAleatoria >> elegir: unaCantidad de: unasCoordenadas con: unaPartida [
	"Elige al azar unaCantidad coordenadas distintas de esa lista (o todas, si hay menos)."
	| candidatas elegidas |
	candidatas := unasCoordenadas asOrderedCollection.
	elegidas := OrderedCollection new.
	[elegidas size < unaCantidad and: [candidatas notEmpty]] whileTrue: [
		| una |
		una := unaPartida elegirUnaDe: candidatas.
		candidatas remove: una.
		elegidas add: una].
	^elegidas asArray
]

{ #category : 'eleccion' }
BNEstrategiaAleatoria >> elegirObjetivos: unaCantidad en: unTablero con: unaPartida [
	"Devuelve unaCantidad casillas distintas sin atacar, elegidas al azar."
	^self elegir: unaCantidad de: unTablero coordenadasSinAtacar con: unaPartida
]
