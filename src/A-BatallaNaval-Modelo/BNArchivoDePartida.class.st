"
Guardo una partida en un archivo y la recupero, usando Fuel (el serializador de objetos que trae Pharo). Como todo el estado de la partida vive en objetos del modelo (BNPartida con sus jugadores, tableros, naves, estrategia, registro y azar), alcanza con guardar la partida entera: no hace falta elegir que datos escribir.
"
Class {
	#name : 'BNArchivoDePartida',
	#superclass : 'Object',
	#instVars : [
		'archivo'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'instance creation' }
BNArchivoDePartida class >> en: unaRuta [
	"Un archivo de partida en esa ruta."
	^self new setArchivo: unaRuta asFileReference
]

{ #category : 'instance creation' }
BNArchivoDePartida class >> estandar [
	"El archivo que usa el juego: junto a la imagen de Pharo."
	^self en: FileLocator imageDirectory asFileReference / 'batalla-naval-partida.fuel'
]

{ #category : 'guardado' }
BNArchivoDePartida >> borrar [
	archivo ensureDelete
]

{ #category : 'guardado' }
BNArchivoDePartida >> cargar [
	"Devuelve la partida guardada, tal como estaba."
	self existe ifFalse: [^BNOperacionInvalida signal: 'No hay ninguna partida guardada'].
	^FLMaterializer materializeFromFileNamed: archivo fullName
]

{ #category : 'guardado' }
BNArchivoDePartida >> existe [
	"Verdadero si hay una partida guardada."
	^archivo exists
]

{ #category : 'guardado' }
BNArchivoDePartida >> guardar: unaPartida [
	"Guarda la partida entera (reemplaza la que hubiera)."
	archivo ensureDelete.
	FLSerializer serialize: unaPartida toFileNamed: archivo fullName
]

{ #category : 'initialization' }
BNArchivoDePartida >> setArchivo: unArchivo [
	archivo := unArchivo
]
