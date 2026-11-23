"
Nave de 2 casillas (caracteristica propia del juego). Ataca con un canon comun, asi siempre puede pelear, y ademas tiene un Sonar: una habilidad que explora una zona del tablero enemigo, descubre las minas y cuenta cuantas casillas con naves hay. Es inmune a las minas: redefine recibirDanioDeMina para no perder vida.
"
Class {
	#name : 'BNBarreminas',
	#superclass : 'BNNave',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos del tipo' }
BNBarreminas >> arma [
    "Ataca con un canon comun: aunque quede sola, puede seguir peleando."
    ^BNCanon new
]

{ #category : 'datos del tipo' }
BNBarreminas >> nombre [
    "Nombre para mostrar en los mensajes del juego."
    ^'Barreminas'
]

{ #category : 'datos del tipo' }
BNBarreminas >> probabilidadDeImpacto [
    "Porcentaje de que el disparo de su canon salga donde se apunto."
    ^80
]

{ #category : 'sonar' }
BNBarreminas >> puedeSondear [
    "Puede usar el sonar si no lo esta recargando."
    ^self estaRecargando not
]

{ #category : 'minas' }
BNBarreminas >> recibirDanioDeMina [
    "Es inmune a las minas: no pierde vida."
    ^self
]

{ #category : 'sonar' }
BNBarreminas >> sonar [
    "Su habilidad especial."
    ^BNSonar new
]

{ #category : 'datos del tipo' }
BNBarreminas >> tamano [
    "Cantidad de casillas que ocupa."
    ^2
]
