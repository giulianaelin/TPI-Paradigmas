"
Ataque rapido del destructor: dos cañonazos seguidos, a la casilla elegida y a la siguiente en la direccion indicada. Son dos tiros independientes (cada uno con su tirada de probabilidad), a diferencia del torpedo que es un solo tiro.
"
Class {
	#name : 'BNAtaqueRapido',
	#superclass : 'BNArma',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos' }
BNAtaqueRapido >> nombre [
    ^'Ataque rapido'
]

{ #category : 'disparo' }
BNAtaqueRapido >> tirosDesde: unosObjetivos hacia: unaDireccion [
    "Dos tiros seguidos: la casilla elegida y la siguiente en la direccion."
    self validarObjetivos: unosObjetivos.
    ^(unosObjetivos first lineaRecortadaDe: 2 hacia: unaDireccion)
        collect: [:unaCoordenada | { unaCoordenada }]
]

{ #category : 'recarga' }
BNAtaqueRapido >> turnosDeRecarga [
    "Sirve para que no encadene dos ataques rapidos en el mismo turno (con el disparo extra)."
    ^1
]

{ #category : 'datos' }
BNAtaqueRapido >> usaDireccion [
    ^true
]
