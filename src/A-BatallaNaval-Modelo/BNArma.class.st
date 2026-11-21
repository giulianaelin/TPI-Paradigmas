"
Soy la base abstracta de las armas de las naves. Cada arma sabe a que casillas pega a partir de las casillas elegidas y de una direccion, y lo devuelve como una lista de tiros: cada tiro es una lista de coordenadas que se resuelve con una sola tirada de probabilidad (si falla, el tiro entero se desvia). Las subclases redefinen tirosDesde:hacia: (polimorfismo).
"
Class {
	#name : 'BNArma',
	#superclass : 'Object',
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'datos' }
BNArma >> cantidadDeObjetivos [
    "Cuantas casillas tiene que elegir el jugador para usar esta arma. Casi todas usan una."
    ^1
]

{ #category : 'datos' }
BNArma >> nombre [
    "Nombre del arma para los mensajes del juego."
    ^self subclassResponsibility
]

{ #category : 'disparo' }
BNArma >> tirosDesde: unosObjetivos hacia: unaDireccion [
    "Devuelve los tiros que hace el arma: una coleccion de tiros, cada uno con sus coordenadas."
    ^self subclassResponsibility
]

{ #category : 'datos' }
BNArma >> usaDireccion [
    "Verdadero si el arma necesita una direccion (horizontal o vertical)."
    ^false
]

{ #category : 'disparo' }
BNArma >> validarObjetivos: unosObjetivos [
    "Controla que se hayan elegido tantas casillas como pide el arma."
    unosObjetivos size = self cantidadDeObjetivos ifFalse: [
        ^BNOperacionInvalida signal:
            self nombre, ' necesita ', self cantidadDeObjetivos printString, ' casilla(s)']
]
