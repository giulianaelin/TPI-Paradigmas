"
Bombardeo aereo del portaaviones: dos tiros independientes a dos casillas distintas que elige el jugador.
"
Class {
	#name : 'BNBombardeo',
	#superclass : 'BNArma',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos' }
BNBombardeo >> cantidadDeObjetivos [
    ^2
]

{ #category : 'datos' }
BNBombardeo >> nombre [
    ^'Bombardeo aereo'
]

{ #category : 'disparo' }
BNBombardeo >> tirosDesde: unosObjetivos hacia: unaDireccion [
    "Dos tiros, uno a cada casilla elegida. Tienen que ser distintas."
    self validarObjetivos: unosObjetivos.
    unosObjetivos first = unosObjetivos last ifTrue: [
        ^BNOperacionInvalida signal: 'El bombardeo necesita dos casillas distintas'].
    ^unosObjetivos collect: [:unObjetivo | { unObjetivo }]
]
