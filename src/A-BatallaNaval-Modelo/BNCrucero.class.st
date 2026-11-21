"
Nave de 3 casillas. Dispara torpedos a 3 celdas en linea recta.
"
Class {
	#name : 'BNCrucero',
	#superclass : 'BNNave',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos del tipo' }
BNCrucero >> nombre [
    "Nombre para mostrar en los mensajes del juego."
    ^'Crucero'
]

{ #category : 'datos del tipo' }
BNCrucero >> probabilidadDeImpacto [
    "Porcentaje de que el disparo salga donde se apunto."
    ^70
]

{ #category : 'datos del tipo' }
BNCrucero >> tamano [
    "Cantidad de casillas que ocupa."
    ^3
]
