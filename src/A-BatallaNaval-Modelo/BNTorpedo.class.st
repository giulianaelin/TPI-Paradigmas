"
Torpedo del crucero: un tiro que pega en 3 casillas en linea recta (horizontal o vertical) desde la casilla elegida. Las casillas que quedarian fuera del tablero se descartan.
"
Class {
	#name : 'BNTorpedo',
	#superclass : 'BNArma',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos' }
BNTorpedo >> nombre [
    ^'Torpedo'
]

{ #category : 'disparo' }
BNTorpedo >> tirosDesde: unosObjetivos hacia: unaDireccion [
    "Un solo tiro que cubre 3 casillas en linea."
    self validarObjetivos: unosObjetivos.
    ^{ unosObjetivos first lineaRecortadaDe: 3 hacia: unaDireccion }
]

{ #category : 'recarga' }
BNTorpedo >> turnosDeRecarga [
    "El torpedo pega en 3 casillas: hay que esperar para volver a usarlo."
    ^2
]

{ #category : 'datos' }
BNTorpedo >> usaDireccion [
    ^true
]
