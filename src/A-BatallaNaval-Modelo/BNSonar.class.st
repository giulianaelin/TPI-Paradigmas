"
Habilidad del barreminas: explora una zona de 3x3 del tablero enemigo. No es un ataque: no hace dano y no tiene probabilidad ni desvio. Descubre las minas de la zona (quedan marcadas en ese tablero) y cuenta cuantas casillas con naves a flote hay, sin decir cuales (detecta tambien al submarino sumergido). Despues de usarlo hay que esperar 3 turnos.
"
Class {
	#name : 'BNSonar',
	#superclass : 'Object',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'exploracion' }
BNSonar >> explorar: unaCoordenada en: unTablero [
    "Descubre las minas de la zona y devuelve cuantas casillas con naves a flote hay en ella."
    | zona |
    zona := self zonaAlrededorDe: unaCoordenada.
    zona do: [:otra |
        (unTablero casillaEn: otra) tieneMinaActiva ifTrue: [unTablero descubrirMinaEn: otra]].
    ^(zona select: [:otra |
        | casilla |
        casilla := unTablero casillaEn: otra.
        casilla estaOcupada and: [casilla ocupante estaAFlote]]) size
]

{ #category : 'accessing' }
BNSonar >> nombre [
    ^'Sonar'
]

{ #category : 'recarga' }
BNSonar >> turnosDeRecarga [
    "Turnos que hay que esperar para volver a usarlo."
    ^3
]

{ #category : 'exploracion' }
BNSonar >> zonaAlrededorDe: unaCoordenada [
    "La casilla elegida y sus 8 vecinas (las que caen dentro del tablero)."
    ^(unaCoordenada vecinosConDiagonales asOrderedCollection copyWith: unaCoordenada) asArray
]
