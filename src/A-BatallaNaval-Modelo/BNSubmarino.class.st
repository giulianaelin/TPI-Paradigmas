"
Nave de 3 casillas. Ataque sigiloso: esta oculto salvo cuando ataca.
"
Class {
	#name : 'BNSubmarino',
	#superclass : 'BNNave',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos del tipo' }
BNSubmarino >> arma [
    "El arma con la que dispara este tipo de nave."
    ^BNCanon new
]

{ #category : 'datos del tipo' }
BNSubmarino >> nombre [
    "Nombre para mostrar en los mensajes del juego."
    ^'Submarino'
]

{ #category : 'datos del tipo' }
BNSubmarino >> probabilidadDeImpacto [
    "Porcentaje de que el disparo salga donde se apunto."
    ^80
]

{ #category : 'datos del tipo' }
BNSubmarino >> tamano [
    "Cantidad de casillas que ocupa."
    ^3
]
