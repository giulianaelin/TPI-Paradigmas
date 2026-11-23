"
Cañon estandar: un tiro a una sola casilla. Lo usan el acorazado (con su alta probabilidad de impacto) y el submarino.
"
Class {
	#name : 'BNCanon',
	#superclass : 'BNArma',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos' }
BNCanon >> nombre [
    ^'Cañon'
]

{ #category : 'disparo' }
BNCanon >> tirosDesde: unosObjetivos hacia: unaDireccion [
    "Un solo tiro a la casilla elegida."
    self validarObjetivos: unosObjetivos.
    ^{ { unosObjetivos first } }
]
