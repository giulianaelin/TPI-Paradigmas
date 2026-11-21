"
Nave de 4 casillas. Sus cañones pesados le dan la mayor probabilidad de impacto.
"
Class {
	#name : 'BNAcorazado',
	#superclass : 'BNNave',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos del tipo' }
BNAcorazado >> nombre [
    "Nombre para mostrar en los mensajes del juego."
    ^'Acorazado'
]

{ #category : 'datos del tipo' }
BNAcorazado >> probabilidadDeImpacto [
    "Porcentaje de que el disparo salga donde se apunto."
    ^95
]

{ #category : 'datos del tipo' }
BNAcorazado >> tamano [
    "Cantidad de casillas que ocupa."
    ^4
]
