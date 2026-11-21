"
Nave de 5 casillas. Su arma es el bombardeo aereo (2 celdas distintas).
"
Class {
	#name : 'BNPortaaviones',
	#superclass : 'BNNave',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos del tipo' }
BNPortaaviones >> nombre [
    "Nombre para mostrar en los mensajes del juego."
    ^'Portaaviones'
]

{ #category : 'datos del tipo' }
BNPortaaviones >> probabilidadDeImpacto [
    "Porcentaje de que el disparo salga donde se apunto."
    ^75
]

{ #category : 'datos del tipo' }
BNPortaaviones >> tamano [
    "Cantidad de casillas que ocupa."
    ^5
]
