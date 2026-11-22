"
Cargo y guardo (una sola vez) todo lo que la interfaz necesita de la carpeta imagenes: las imagenes PNG, sus versiones agrandadas o giradas, la tipografia y los carteles ya dibujados (ventanas, globos). La carpeta se busca junto al repositorio del proyecto o junto a la imagen de Pharo; si esta en otro lado: BNRecursos usarCarpeta: 'ruta'.
"
Class {
	#name : 'BNRecursos',
	#superclass : 'Object',
	#instVars : [
		'carpeta',
		'formas',
		'fuente'
	],
	#classVars : [
		'Actual'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNRecursos class >> actual [

	"Los recursos que usa la interfaz. Se cargan una sola vez."
	^Actual ifNil: [Actual := self enCarpeta: self carpetaPorDefecto]
]

{ #category : 'instance creation' }
BNRecursos class >> carpetaPorDefecto [

	"Busca la carpeta imagenes: primero en los repositorios de Iceberg, despues junto a la imagen de Pharo."
	| candidatas |
	candidatas := OrderedCollection new.
	(Smalltalk globals at: #IceRepository ifAbsent: [nil]) ifNotNil: [:claseRepositorio |
		claseRepositorio registry do: [:unRepositorio |
			[unRepositorio location ifNotNil: [:lugar | candidatas add: lugar asFileReference / 'imagenes']]
				on: Error do: [:e | nil]]].
	candidatas add: FileLocator imageDirectory asFileReference / 'imagenes'.
	^candidatas
		detect: [:unaCarpeta | (unaCarpeta / 'agua.png') exists]
		ifNone: [self error: 'No encuentro la carpeta imagenes. Usa: BNRecursos usarCarpeta: ''ruta de la carpeta imagenes''']
]

{ #category : 'instance creation' }
BNRecursos class >> enCarpeta: unaCarpeta [

	^self new setCarpeta: unaCarpeta
]

{ #category : 'instance creation' }
BNRecursos class >> olvidar [

	"Descarta lo cargado (por ejemplo, si se cambiaron las imagenes)."
	Actual := nil
]

{ #category : 'instance creation' }
BNRecursos class >> usarCarpeta: unaRuta [

	"Por si la carpeta imagenes esta en otro lugar."
	Actual := self enCarpeta: unaRuta asFileReference
]

{ #category : 'imagenes' }
BNRecursos >> atenuar: unaForma [

	"Copia de la forma con cada pixel a menos de la mitad de opacidad."
	| copia |
	copia := Form extent: unaForma extent depth: 32.
	0 to: unaForma width - 1 do: [:x | 0 to: unaForma height - 1 do: [:y |
		| color |
		color := unaForma colorAt: x @ y.
		color alpha > 0 ifTrue: [copia colorAt: x @ y put: (color alpha: color alpha * 0.45)]]].
	^copia
]

{ #category : 'carteles' }
BNRecursos >> brillo [

	"Brillito de cuatro puntas para decorar."
	^formas at: 'brillo' ifAbsentPut: [
		| lienzo |
		lienzo := BNLienzoPixel extent: 10 @ 10.
		lienzo brilloEn: 0 @ 0.
		lienzo ampliadoPor: 3]
]

{ #category : 'accessing' }
BNRecursos >> carpeta [

	^carpeta
]

{ #category : 'accessing' }
BNRecursos >> fuente [

	^fuente ifNil: [
		fuente := BNFuentePixel
			forma: (self imagen: 'fuente')
			descripcion: (carpeta / 'fuente-caracteres.txt') contents]
]

{ #category : 'imagenes' }
BNRecursos >> girar: unaForma [

	| girada |
	girada := Form extent: unaForma height @ unaForma width depth: 32.
	0 to: unaForma width - 1 do: [:x | 0 to: unaForma height - 1 do: [:y |
		girada pixelValueAt: (unaForma height - 1 - y) @ x put: (unaForma pixelValueAt: x @ y)]].
	^girada
]

{ #category : 'carteles' }
BNRecursos >> globo: unTamano [

	"Globo de dialogo de la nutria."
	^formas at: 'globo' , unTamano printString ifAbsentPut: [
		| lienzo |
		lienzo := BNLienzoPixel extent: (unTamano // 3) + (0 @ 3).
		lienzo globoEn: (0 @ 0 extent: unTamano // 3).
		lienzo ampliadoPor: 3]
]

{ #category : 'carteles' }
BNRecursos >> icono: unNombre [

	"Un icono de los botones, suelto (por ejemplo, el reloj de recarga del panel de flota)."
	^formas at: 'icono-' , unNombre ifAbsentPut: [
		| lienzo |
		lienzo := BNLienzoPixel extent: 7 @ 7.
		lienzo icono: unNombre en: 0 @ 0 escala: 1 apagado: false.
		lienzo ampliadoPor: 3]
]

{ #category : 'imagenes' }
BNRecursos >> imagen: unNombre [

	"La imagen unNombre.png de la carpeta."
	^formas at: unNombre ifAbsentPut: [
		(ImageReadWriter formFromFileNamed: (carpeta / (unNombre , '.png')) fullName) asFormOfDepth: 32]
]

{ #category : 'imagenes' }
BNRecursos >> imagen: unNombre ampliada: unFactor [

	"La imagen agrandada sin suavizar (pixel art)."
	^formas
		at: unNombre , '@' , unFactor printString
		ifAbsentPut: [BNLienzoPixel ampliar: (self imagen: unNombre) por: unFactor]
]

{ #category : 'imagenes' }
BNRecursos >> imagenDeNave: unNombre vertical: esVertical atenuada: esAtenuada [

	"La imagen de una nave, girada si esta vertical y medio transparente si esta oculta."
	| clave |
	clave := unNombre , (esVertical ifTrue: ['@v'] ifFalse: ['@h']) , (esAtenuada ifTrue: ['@a'] ifFalse: ['']).
	^formas at: clave ifAbsentPut: [
		| base |
		base := esVertical ifTrue: [self imagenVertical: unNombre] ifFalse: [self imagen: unNombre].
		esAtenuada ifTrue: [self atenuar: base] ifFalse: [base]]
]

{ #category : 'imagenes' }
BNRecursos >> imagenVertical: unNombre [

	"La imagen girada 90 grados a la derecha: las naves se dibujan horizontales con la proa a la derecha, asi que giradas quedan con la proa para abajo."
	^formas at: unNombre , '@vertical' ifAbsentPut: [self girar: (self imagen: unNombre)]
]

{ #category : 'initialization' }
BNRecursos >> setCarpeta: unaCarpeta [

	carpeta := unaCarpeta.
	formas := Dictionary new
]

{ #category : 'carteles' }
BNRecursos >> ventana: unTamano [

	"Ventanita rosa del tamano pedido (en pixeles de pantalla, multiplo de 3)."
	^formas at: 'ventana' , unTamano printString ifAbsentPut: [
		| lienzo |
		lienzo := BNLienzoPixel extent: (unTamano // 3) + (0 @ 3).
		lienzo ventanaEn: (0 @ 0 extent: unTamano // 3).
		lienzo ampliadoPor: 3]
]
