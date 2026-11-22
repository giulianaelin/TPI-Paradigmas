"
Estrategia de la computadora en dificultad intermedia (""cazar y rematar""): si hay naves enemigas tocadas que todavia no se hundieron, dispara a las casillas de arriba, abajo, izquierda y derecha de esos impactos hasta hundirlas; si no hay ninguna, caza al azar igual que la estrategia aleatoria (por eso heredo de ella y reuso su eleccion al azar).
"
Class {
	#name : 'BNEstrategiaCazadora',
	#superclass : 'BNEstrategiaAleatoria',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'eleccion' }
BNEstrategiaCazadora >> casillasParaRematarEn: unTablero [
	"Coordenadas sin atacar que estan al lado de una nave tocada que todavia flota y que no esta oculta (de una nave oculta no sabe que la toco)."
	| tocadas vecinas |
	tocadas := unTablero casillas select: [:unaCasilla |
		unaCasilla fueAtacada and: [unaCasilla estaOcupada and: [
			unaCasilla ocupante estaAFlote and: [unaCasilla ocupante estaOculta not]]]].
	vecinas := Set new.
	tocadas do: [:unaCasilla | vecinas addAll: unaCasilla coordenada vecinosOrtogonales].
	^(vecinas reject: [:unaCoordenada | (unTablero casillaEn: unaCoordenada) fueAtacada]) asArray
]

{ #category : 'eleccion' }
BNEstrategiaCazadora >> elegirObjetivos: unaCantidad en: unTablero con: unaPartida [
	"Primero remata: elige entre las vecinas de los impactos. Si faltan casillas, completa al azar."
	| elegidas resto |
	elegidas := self elegir: unaCantidad de: (self casillasParaRematarEn: unTablero) con: unaPartida.
	resto := unTablero coordenadasSinAtacar reject: [:unaCoordenada | elegidas includes: unaCoordenada].
	^elegidas , (self elegir: unaCantidad - elegidas size de: resto con: unaPartida)
]
