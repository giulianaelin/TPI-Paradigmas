"
Nave de 3 casillas. Ataque sigiloso: esta oculto salvo cuando ataca. Mientras esta sumergido, si el enemigo le pega cree que fue agua (no se entera del dano). Cuando ataca sale a la superficie y sus impactos se ven hasta que empieza el proximo turno de su duenio. Si ya ataco alguna vez y esta herido (antes o despues de atacar), sus impactos se ven para siempre: con el casco danado no puede volver a sumergirse. Su posicion nunca se revela: solo el dano.
"
Class {
	#name : 'BNSubmarino',
	#superclass : 'BNNave',
	#instVars : [
		'atacoAlgunaVez',
		'aLaVista'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'sigilo' }
BNSubmarino >> alAtacar [
    "Al disparar sale a la superficie: el enemigo ve sus impactos durante su proximo turno."
    atacoAlgunaVez := true.
    aLaVista := true
]

{ #category : 'sigilo' }
BNSubmarino >> alEmpezarSuTurno [
    "Como toda nave avanza su recarga, y ademas se sumerge de nuevo (si puede)."
    super alEmpezarSuTurno.
    aLaVista := false
]

{ #category : 'datos del tipo' }
BNSubmarino >> arma [
    "El arma con la que dispara este tipo de nave."
    ^BNCanon new
]

{ #category : 'sigilo' }
BNSubmarino >> estaOculta [
    "Sumergido: el enemigo no se entera de sus impactos. Hundido ya no se puede esconder."
    ^self estaAFlote and: [self muestraSusImpactos not]
]

{ #category : 'initialization' }
BNSubmarino >> initialize [
    "Un submarino nuevo esta sumergido y nunca ataco."
    super initialize.
    atacoAlgunaVez := false.
    aLaVista := false
]

{ #category : 'sigilo' }
BNSubmarino >> muestraSusImpactos [
    "Sus impactos se ven si acaba de atacar, o si ya ataco alguna vez y esta herido."
    ^aLaVista == true or: [atacoAlgunaVez == true and: [self estaHerida]]
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
