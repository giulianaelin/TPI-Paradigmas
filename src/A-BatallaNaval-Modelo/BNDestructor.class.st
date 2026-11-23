"
Nave de 2 casillas. Ataque rapido: dispara 2 veces seguidas.
"
Class {
	#name : 'BNDestructor',
	#superclass : 'BNNave',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos del tipo' }
BNDestructor >> arma [
    "El arma con la que dispara este tipo de nave."
    ^BNAtaqueRapido new
]

{ #category : 'datos del tipo' }
BNDestructor >> nombre [
    "Nombre para mostrar en los mensajes del juego."
    ^'Destructor'
]

{ #category : 'datos del tipo' }
BNDestructor >> probabilidadDeImpacto [
    "Porcentaje de que el disparo salga donde se apunto."
    ^85
]

{ #category : 'datos del tipo' }
BNDestructor >> tamano [
    "Cantidad de casillas que ocupa."
    ^2
]
