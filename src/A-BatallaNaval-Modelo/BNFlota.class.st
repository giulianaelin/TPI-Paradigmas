"
Represento el conjunto de naves de un jugador. La flota estandar es la de la consigna (2 naves de cada uno de los 5 tipos); la del juego suma un barreminas (conBarreminas). Respondo cuantas casillas necesito, que naves siguen a flote y si estoy destruida (todas hundidas), que es la condicion de derrota.
"
Class {
	#name : 'BNFlota',
	#superclass : 'Object',
	#instVars : [
		'naves'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'instance creation' }
BNFlota class >> conBarreminas [
    "La flota del juego: la estandar de la consigna mas un barreminas (caracteristica propia)."
    ^self conNaves: self estandar naves , { BNBarreminas new }
]

{ #category : 'as yet unclassified' }
BNFlota class >> conNaves: unasNaves [
    "Crea una flota con esas naves."
    ^self new setNaves: unasNaves
]

{ #category : 'as yet unclassified' }
BNFlota class >> estandar [
    "Flota que pidio el profe: 2 naves de cada tipo, 10 en total."
    | naves |
    naves := OrderedCollection new.
    self tiposDeNave do: [:unTipo |
        2 timesRepeat: [naves add: unTipo new]].
    ^self conNaves: naves
]

{ #category : 'as yet unclassified' }
BNFlota class >> tiposDeNave [
    "Los 5 tipos de nave de la consigna."
    ^{ BNPortaaviones. BNAcorazado. BNCrucero. BNSubmarino. BNDestructor }
]

{ #category : 'as yet unclassified' }
BNFlota >> casillasNecesarias [
    "Cuantas casillas ocupa la flota entera (34 en la estandar)."
    ^naves inject: 0 into: [:suma :unaNave | suma + unaNave tamano]
]

{ #category : 'as yet unclassified' }
BNFlota >> estaDestruida [
    "Verdadero si todas las naves estan hundidas: el dueño de la flota perdio."
    ^naves allSatisfy: [:unaNave | unaNave estaHundida]
]

{ #category : 'accessing' }
BNFlota >> naves [
    "Devuelve una copia de la lista de naves."
    ^naves copy
]

{ #category : 'as yet unclassified' }
BNFlota >> navesAFlote [
    "Las naves que todavia no se hundieron."
    ^naves select: [:unaNave | unaNave estaAFlote]
]

{ #category : 'initialization' }
BNFlota >> setNaves: unasNaves [
    "Guarda una copia de las naves, para que no la modifiquen desde afuera."
    naves := unasNaves asOrderedCollection copy
]
