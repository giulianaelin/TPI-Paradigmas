"
Representa el tablero de un jugador: es una grilla cuadrada de casillas (la dimensión la define BNCoordenada). Conoce las islas que se ubicaron y responde dónde hay minas. Decide si una nave puede ubicarse en un grupo de coordenadas, y la ubica o la retira. No sabe nada de turnos ni de interfaz.
"
Class {
	#name : 'BNTablero',
	#superclass : 'Object',
	#instVars : [
		'casillas',
		'islas',
		'minasDescubiertas'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'as yet unclassified' }
BNTablero >> agregarIslaEn: unasCoordenadas [
    "Convierte en isla esas casillas. Valida todo antes de modificar, para que una isla invalida no deje el tablero a medias."
    (self puedeAgregarIslaEn: unasCoordenadas) ifFalse: [
        ^BNOperacionInvalida signal: 'Una isla necesita casillas libres que no toquen otra isla'].
    (self casillasEn: unasCoordenadas) do: [:unaCasilla | unaCasilla convertirEnIsla].
    islas add: unasCoordenadas asArray
]

{ #category : 'as yet unclassified' }
BNTablero >> armarMinaEn: unaCoordenada [
    "Coloca una mina. La casilla controla que no sea isla, que no este ocupada y que no tenga ya una mina."
    (self casillaEn: unaCoordenada) armarMina
]

{ #category : 'as yet unclassified' }
BNTablero >> casillaEn: unaCoordenada [
    "Devuelve la casilla de esa coordenada. Las casillas estan guardadas fila por fila."
    ^casillas at: (unaCoordenada fila - 1) * self dimension + unaCoordenada columna
]

{ #category : 'accessing' }
BNTablero >> casillas [
    "Devuelve una copia de todas las casillas, para que nadie modifique la grilla desde afuera."
    ^casillas copy
]

{ #category : 'as yet unclassified' }
BNTablero >> casillasDe: unOcupante [
    "Devuelve las casillas que ocupa esa nave."
    ^casillas select: [:unaCasilla | unaCasilla ocupante == unOcupante]
]

{ #category : 'as yet unclassified' }
BNTablero >> casillasEn: unasCoordenadas [
    "Devuelve las casillas de todas las coordenadas indicadas."
    ^unasCoordenadas collect: [:unaCoordenada | self casillaEn: unaCoordenada]
]

{ #category : 'as yet unclassified' }
BNTablero >> casillasLibres [
    "Casillas donde se puede poner una isla o una mina (las usa el generador de terreno)."
    ^casillas select: [:unaCasilla | unaCasilla estaLibre]
]

{ #category : 'as yet unclassified' }
BNTablero >> coordenadasConMina [
    "Coordenadas de las minas armadas. La perspectiva propia las usa para mostrarlas al empezar."
    ^(casillas select: [:unaCasilla | unaCasilla tieneMinaActiva])
        collect: [:unaCasilla | unaCasilla coordenada]
]

{ #category : 'disparos' }
BNTablero >> coordenadasSinAtacar [
    "Coordenadas a las que todavia no se disparo (las usa la computadora para elegir objetivos)."
    ^(casillas reject: [:unaCasilla | unaCasilla fueAtacada])
        collect: [:unaCasilla | unaCasilla coordenada]
]

{ #category : 'minas' }
BNTablero >> descubrirMinaEn: unaCoordenada [
    "El enemigo ya sabe que en esa casilla hay una mina."
    self minasDescubiertas add: unaCoordenada
]

{ #category : 'configuracion' }
BNTablero >> dimension [
    "La dimension la define BNCoordenada, asi hay un solo lugar donde cambiarla."
    ^BNCoordenada dimension
]

{ #category : 'initialization' }
BNTablero >> initialize [
    "Crea una casilla de agua por cada coordenada, fila por fila, y empieza sin islas."
    super initialize.
    casillas := (BNCoordenada todas collect: [:unaCoordenada |
        BNCasilla en: unaCoordenada]) asArray.
    islas := OrderedCollection new.
    minasDescubiertas := Set new
]

{ #category : 'accessing' }
BNTablero >> islas [
    "Devuelve las islas; cada una es la lista de coordenadas que ocupa."
    ^islas copy
]

{ #category : 'minas' }
BNTablero >> minasDescubiertas [
    "Coordenadas de las minas que el enemigo descubrio con el sonar."
    ^minasDescubiertas ifNil: [minasDescubiertas := Set new]
]

{ #category : 'naves' }
BNTablero >> mover: unaNave hacia: unDesplazamiento [
    "Mueve la nave entera una casilla (BNCoordenada arriba, abajo, izquierda o derecha). Una nave herida no se mueve. Si cae sobre una mina, explota (lo resuelve ubicar:en:)."
    | actuales destino |
    unaNave puedeMoverse ifFalse: [
        ^BNOperacionInvalida signal: 'Una nave herida no se puede mover'].
    actuales := (self casillasDe: unaNave) collect: [:unaCasilla | unaCasilla coordenada].
    actuales isEmpty ifTrue: [
        ^BNOperacionInvalida signal: 'La nave no esta en el tablero'].
    (actuales allSatisfy: [:unaCoordenada | unaCoordenada puedeDesplazarseEn: unDesplazamiento])
        ifFalse: [^BNOperacionInvalida signal: 'La nave se saldria del tablero'].
    destino := actuales collect: [:unaCoordenada | unaCoordenada desplazadaEn: unDesplazamiento].
    (self puedeUbicar: unaNave en: destino) ifFalse: [
        ^BNOperacionInvalida signal: 'No se puede mover la nave ahi (isla, otra nave o casilla atacada)'].
    self retirar: unaNave.
    self ubicar: unaNave en: destino
]

{ #category : 'as yet unclassified' }
BNTablero >> puedeAgregarIslaEn: unasCoordenadas [
    "Verdadero si esas casillas pueden ser una isla: al menos una, todas libres y sin tocar otra isla."
    ^unasCoordenadas notEmpty and: [
        ((self casillasEn: unasCoordenadas) allSatisfy: [:unaCasilla | unaCasilla estaLibre])
            and: [(self tocaOtraIsla: unasCoordenadas) not]]
]

{ #category : 'as yet unclassified' }
BNTablero >> puedeUbicar: unaNave desde: unaCoordenada hacia: unaDireccion [
    "Verdadero si la nave entra en el tablero desde esa coordenada en esa direccion, y todas sus casillas la admiten."
    ^(unaCoordenada cabeLineaDe: unaNave tamano hacia: unaDireccion) and: [
        self puedeUbicar: unaNave en: (unaCoordenada lineaDe: unaNave tamano hacia: unaDireccion)]
]

{ #category : 'as yet unclassified' }
BNTablero >> puedeUbicar: unOcupante en: unasCoordenadas [
    "Verdadero si todas las casillas admiten a esa nave. Sirve al ubicar y al mover."
    ^unasCoordenadas notEmpty and: [
        (self casillasEn: unasCoordenadas) allSatisfy: [:unaCasilla |
            unaCasilla admiteA: unOcupante]]
]

{ #category : 'as yet unclassified' }
BNTablero >> recibirDisparoEn: unaCoordenada [
    "Resuelve un disparo enemigo en esa casilla y devuelve el resultado: #agua, #isla, #mina, #impacto, #hundido o #restos (una nave que ya se hundio por minas). Si hay una mina, el daño lo recibe la nave que disparo: de eso se encarga la partida."
    | casilla |
    casilla := self casillaEn: unaCoordenada.
    casilla fueAtacada ifTrue: [
        ^BNOperacionInvalida signal: 'Ya se disparo en ', unaCoordenada etiqueta].
    casilla marcarAtacada.
    casilla esIsla ifTrue: [^#isla].
    casilla tieneMinaActiva ifTrue: [
        casilla detonarMina.
        ^#mina].
    casilla estaOcupada ifFalse: [^#agua].
    casilla ocupante estaHundida ifTrue: [^#restos].
    casilla ocupante recibirImpacto.
    ^casilla ocupante estaHundida
        ifTrue: [#hundido]
        ifFalse: [#impacto]
]

{ #category : 'as yet unclassified' }
BNTablero >> retirar: unOcupante [
    "Libera las casillas que ocupa esa nave (por ejemplo, antes de moverla)."
    (self casillasDe: unOcupante) do: [:unaCasilla | unaCasilla liberar]
]

{ #category : 'minas' }
BNTablero >> tieneMinaDescubiertaEn: unaCoordenada [
    "Verdadero si en esa casilla hay una mina armada que el enemigo ya descubrio."
    ^(self minasDescubiertas includes: unaCoordenada) and: [(self casillaEn: unaCoordenada) tieneMinaActiva]
]

{ #category : 'as yet unclassified' }
BNTablero >> tocaOtraIsla: unasCoordenadas [
    "Verdadero si alguna coordenada es vecina, incluso en diagonal, de una isla ya ubicada."
    ^unasCoordenadas anySatisfy: [:unaCoordenada |
        unaCoordenada vecinosConDiagonales anySatisfy: [:unVecino |
            (self casillaEn: unVecino) esIsla]]
]

{ #category : 'as yet unclassified' }
BNTablero >> ubicar: unaNave desde: unaCoordenada hacia: unaDireccion [
    "Ubica la nave ocupando tantas casillas como su tamaño, desde esa coordenada hacia la direccion (BNCoordenada horizontal o vertical)."
    (self puedeUbicar: unaNave desde: unaCoordenada hacia: unaDireccion) ifFalse: [
        ^BNOperacionInvalida signal: 'No se puede ubicar la nave desde ', unaCoordenada etiqueta].
    self ubicar: unaNave en: (unaCoordenada lineaDe: unaNave tamano hacia: unaDireccion)
]

{ #category : 'as yet unclassified' }
BNTablero >> ubicar: unOcupante en: unasCoordenadas [
    "Ubica la nave en esas casillas, o no ubica nada si alguna no la admite. Si cae sobre una mina, la mina explota: la nave pierde 1 de resistencia y la casilla queda marcada como atacada."
    (self puedeUbicar: unOcupante en: unasCoordenadas) ifFalse: [
        ^BNOperacionInvalida signal: 'No se puede ubicar la nave en esas casillas'].
    (self casillasEn: unasCoordenadas) do: [:unaCasilla |
        unaCasilla ocuparCon: unOcupante.
        unaCasilla tieneMinaActiva ifTrue: [
            unaCasilla detonarMina; marcarAtacada.
            unOcupante recibirDanioDeMina]]
]
