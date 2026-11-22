"
Soy la vista de un tablero en la pantalla: dibujo el agua, las letras de las columnas y los numeros de las filas, y lo que corresponde mostrar de cada casilla. Tambien traduzco un punto de la pantalla a una coordenada del tablero y puedo resaltar casillas (donde caeria una nave o un disparo). Soy abstracta: mis subclases deciden que se ve (BNVistaTableroPropio muestra todo lo del jugador; BNVistaTableroEnemigo solo lo que ya se ataco). Solo leo el tablero, nunca lo modifico.
"
Class {
	#name : 'BNVistaTablero',
	#superclass : 'Object',
	#instVars : [
		'tablero',
		'origen',
		'marcadas',
		'marcasValidas',
		'carteles'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNVistaTablero class >> tablero: unTablero origen: unPunto [

	^self new setTablero: unTablero origen: unPunto
]

{ #category : 'cartelitos' }
BNVistaTablero >> agregarCartel: unTexto en: unaCoordenada [

	"Un textito (por ejemplo ¡Boom!) que aparece sobre la casilla, sube un poco y desaparece."
	self carteles add: { unTexto. unaCoordenada. Time millisecondClockValue }
]

{ #category : 'cartelitos' }
BNVistaTablero >> carteles [

	^carteles ifNil: [carteles := OrderedCollection new]
]

{ #category : 'cartelitos' }
BNVistaTablero >> coloresDeCartel: unTexto [

	"Color de la letra y de su sombra segun el cartel."
	unTexto = '¡Splash!' ifTrue: [^{ Color fromHexString: 'DFF7FF'. Color fromHexString: '0A4E72' }].
	unTexto = '¡Ping!' ifTrue: [^{ Color fromHexString: '6CCFD6'. Color fromHexString: '0A4E72' }].
	unTexto = '¡Hundido!' ifTrue: [^{ BNLienzoPixel corazon. Color fromHexString: '240C10' }].
	^{ Color fromHexString: 'FFD21F'. Color fromHexString: '240C10' }
]

{ #category : 'geometria' }
BNVistaTablero >> coordenadaEn: unPunto [

	"La coordenada de la casilla que esta en ese punto de la pantalla, o nil si el punto cae afuera."
	| relativo |
	(self rectangulo containsPoint: unPunto) ifFalse: [^nil].
	relativo := (unPunto - origen) // self lado.
	^BNCoordenada fila: relativo y + 1 columna: relativo x + 1
]

{ #category : 'marcas' }
BNVistaTablero >> desmarcar [

	^self marcar: #() validas: true
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujaAtenuada: unaNave [

	"Si la nave se dibuja medio transparente. Lo decide cada subclase."
	self subclassResponsibility
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarAguaEn: unCanvas con: unosRecursos [

	"Cada casilla toma su pedazo de la textura de agua, asi las olas quedan continuas."
	| agua |
	agua := unosRecursos imagen: 'agua'.
	tablero casillas do: [:unaCasilla |
		| coordenada |
		coordenada := unaCasilla coordenada.
		unCanvas
			drawImage: agua
			at: (self rectanguloDe: coordenada) origin
			sourceRect: (((((coordenada columna - 1) * self lado) \\ agua width) @ (((coordenada fila - 1) * self lado) \\ agua height)) extent: self lado asPoint)].
	1 to: tablero dimension - 1 do: [:i |
		unCanvas fillRectangle: ((origen x + (i * self lado)) @ origen y extent: 1 @ self rectangulo height) color: (Color white alpha: 0.2).
		unCanvas fillRectangle: (origen x @ (origen y + (i * self lado)) extent: self rectangulo width @ 1) color: (Color white alpha: 0.2)]
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarAtaqueEn: unaCasilla canvas: unCanvas con: unosRecursos [

	"Lo que se ve en una casilla ya atacada: mina detonada, impacto o restos de nave hundida, o salpicadura en el agua."
	unaCasilla fueAtacada ifFalse: [^self].
	unaCasilla esIsla ifTrue: [^self].
	unaCasilla minaDetonada ifTrue: [self pegar: 'mina-detonada' en: unaCasilla coordenada canvas: unCanvas con: unosRecursos].
	(unaCasilla estaOcupada and: [self seVeElImpactoEn: unaCasilla]) ifTrue: [
		^self
			pegar: (unaCasilla ocupante estaHundida ifTrue: ['hundido'] ifFalse: ['impacto'])
			en: unaCasilla coordenada canvas: unCanvas con: unosRecursos].
	unaCasilla minaDetonada ifFalse: [self pegar: 'agua-atacada' en: unaCasilla coordenada canvas: unCanvas con: unosRecursos]
]

{ #category : 'cartelitos' }
BNVistaTablero >> dibujarCartelesEn: unCanvas con: unosRecursos [

	| ahora |
	ahora := Time millisecondClockValue.
	self carteles do: [:unCartel |
		| pasado colores forma rect |
		pasado := ahora - unCartel third.
		pasado <= self duracionDeCartel ifTrue: [
			colores := self coloresDeCartel: unCartel first.
			forma := unosRecursos fuente formaDe: unCartel first escala: 3 color: colores first sombra: colores last.
			rect := self rectanguloDe: unCartel second.
			unCanvas
				translucentImage: forma
				at: (rect center x - (forma width // 2)) @ (rect top - 14 - (pasado * 26 // self duracionDeCartel))]]
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarEn: unCanvas con: unosRecursos [

	self dibujarAguaEn: unCanvas con: unosRecursos.
	self dibujarEtiquetasEn: unCanvas con: unosRecursos.
	self dibujarIslasEn: unCanvas con: unosRecursos.
	self dibujarNavesEn: unCanvas con: unosRecursos.
	tablero casillas do: [:unaCasilla | self dibujarMarcasDe: unaCasilla en: unCanvas con: unosRecursos].
	self dibujarResaltadoEn: unCanvas.
	unCanvas frameRectangle: (self rectangulo expandBy: 3) width: 3 color: BNLienzoPixel oscuro.
	self dibujarCartelesEn: unCanvas con: unosRecursos
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarEtiquetasEn: unCanvas con: unosRecursos [

	"Letras arriba (columnas) y numeros a la izquierda (filas)."
	| fuente |
	fuente := unosRecursos fuente.
	1 to: tablero dimension do: [:i |
		| letra numero |
		letra := fuente formaDe: (BNCoordenada letraDeColumna: i) asString escala: 2 color: BNLienzoPixel texto sombra: BNLienzoPixel crema.
		unCanvas translucentImage: letra at: (origen x + ((i - 1) * self lado) + ((self lado - letra width) // 2)) @ (origen y - 24).
		numero := fuente formaDe: i printString escala: 2 color: BNLienzoPixel texto sombra: BNLienzoPixel crema.
		unCanvas translucentImage: numero at: (origen x - 8 - numero width) @ (origen y + ((i - 1) * self lado) + 9)]
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarIsla: unasCoordenadas en: unCanvas con: unosRecursos [

	"Dibuja solo las casillas de la isla que se ven; cada casilla toma su pedazo de la imagen de la isla entera."
	| ordenadas imagen |
	ordenadas := self ordenar: unasCoordenadas.
	imagen := self imagenDeIsla: ordenadas con: unosRecursos.
	ordenadas withIndexDo: [:unaCoordenada :i |
		(self seVeLaIslaEn: unaCoordenada) ifTrue: [
			unCanvas
				translucentImage: imagen
				at: (self rectanguloDe: unaCoordenada) origin
				sourceRect: (((self esHorizontal: ordenadas)
					ifTrue: [((i - 1) * self lado) @ 0]
					ifFalse: [0 @ ((i - 1) * self lado)]) extent: self lado asPoint)]]
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarIslasEn: unCanvas con: unosRecursos [

	tablero islas do: [:unaIsla | self dibujarIsla: unaIsla en: unCanvas con: unosRecursos]
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarMarcasDe: unaCasilla en: unCanvas con: unosRecursos [

	self subclassResponsibility
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarNave: unaNave en: unCanvas con: unosRecursos [

	"La nave entera, horizontal o girada segun como esta ubicada."
	| coordenadas imagen |
	coordenadas := (tablero casillasDe: unaNave) collect: [:unaCasilla | unaCasilla coordenada].
	coordenadas isEmpty ifTrue: [^self].
	coordenadas := self ordenar: coordenadas.
	imagen := unosRecursos
		imagenDeNave: unaNave nombre asLowercase
		vertical: (self esHorizontal: coordenadas) not
		atenuada: (self dibujaAtenuada: unaNave).
	unCanvas translucentImage: imagen at: (self rectanguloDe: coordenadas first) origin
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarNavesEn: unCanvas con: unosRecursos [

	self subclassResponsibility
]

{ #category : 'dibujo' }
BNVistaTablero >> dibujarResaltadoEn: unCanvas [

	| relleno borde |
	relleno := marcasValidas
		ifTrue: [Color white alpha: 0.45]
		ifFalse: [(Color r: 1 g: 0.25 b: 0.35) alpha: 0.55].
	borde := marcasValidas
		ifTrue: [Color white]
		ifFalse: [Color r: 0.8 g: 0.1 b: 0.25].
	marcadas do: [:unaCoordenada |
		| rect |
		rect := self rectanguloDe: unaCoordenada.
		unCanvas fillRectangle: rect color: relleno.
		unCanvas frameRectangle: rect width: 2 color: borde]
]

{ #category : 'cartelitos' }
BNVistaTablero >> duracionDeCartel [

	"Milisegundos que dura un cartelito en pantalla."
	^1400
]

{ #category : 'geometria' }
BNVistaTablero >> esHorizontal: unasCoordenadasOrdenadas [

	^unasCoordenadasOrdenadas first fila = unasCoordenadasOrdenadas last fila
]

{ #category : 'dibujo' }
BNVistaTablero >> imagenDeIsla: unasCoordenadasOrdenadas con: unosRecursos [

	"Islita de una casilla, o la isla grande horizontal o vertical."
	unasCoordenadasOrdenadas size = 1 ifTrue: [^unosRecursos imagen: 'isla'].
	^(self esHorizontal: unasCoordenadasOrdenadas)
		ifTrue: [unosRecursos imagen: 'isla-doble']
		ifFalse: [unosRecursos imagen: 'isla-doble-vertical']
]

{ #category : 'geometria' }
BNVistaTablero >> lado [

	"Cada casilla mide 32 pixeles."
	^32
]

{ #category : 'marcas' }
BNVistaTablero >> marcar: unasCoordenadas validas: unBooleano [

	"Resalta esas casillas (en blanco si la jugada es valida, en rojo si no). Devuelve true si cambio algo."
	| cambio |
	cambio := (marcadas = unasCoordenadas asArray and: [marcasValidas = unBooleano]) not.
	marcadas := unasCoordenadas asArray.
	marcasValidas := unBooleano.
	^cambio
]

{ #category : 'dibujo' }
BNVistaTablero >> navesEnElTablero [

	"Las naves que ocupan alguna casilla."
	^(tablero casillas select: [:unaCasilla | unaCasilla estaOcupada])
		inject: IdentitySet new
		into: [:naves :unaCasilla | naves add: unaCasilla ocupante; yourself]
]

{ #category : 'geometria' }
BNVistaTablero >> ordenar: unasCoordenadas [

	"De arriba a abajo y de izquierda a derecha."
	^(unasCoordenadas asSortedCollection: [:a :b |
		a fila < b fila or: [a fila = b fila and: [a columna <= b columna]]]) asArray
]

{ #category : 'dibujo' }
BNVistaTablero >> pegar: unNombre en: unaCoordenada canvas: unCanvas con: unosRecursos [

	unCanvas translucentImage: (unosRecursos imagen: unNombre) at: (self rectanguloDe: unaCoordenada) origin
]

{ #category : 'geometria' }
BNVistaTablero >> rectangulo [

	^origen extent: (tablero dimension * self lado) asPoint
]

{ #category : 'geometria' }
BNVistaTablero >> rectanguloDe: unaCoordenada [

	^(origen + (((unaCoordenada columna - 1) @ (unaCoordenada fila - 1)) * self lado)) extent: self lado asPoint
]

{ #category : 'dibujo' }
BNVistaTablero >> seVeElImpactoEn: unaCasilla [

	"Si en esa casilla atacada con una nave se muestra el impacto. Lo decide cada subclase."
	self subclassResponsibility
]

{ #category : 'dibujo' }
BNVistaTablero >> seVeLaIslaEn: unaCoordenada [

	"Si esa casilla de isla se muestra. Lo decide cada subclase."
	self subclassResponsibility
]

{ #category : 'initialization' }
BNVistaTablero >> setTablero: unTablero origen: unPunto [

	tablero := unTablero.
	origen := unPunto.
	marcadas := #().
	marcasValidas := true
]

{ #category : 'cartelitos' }
BNVistaTablero >> tieneCarteles [

	"Verdadero si hay cartelitos animandose (hay que redibujar seguido)."
	| ahora |
	ahora := Time millisecondClockValue.
	self carteles removeAllSuchThat: [:unCartel | ahora - unCartel third > self duracionDeCartel].
	^self carteles notEmpty
]
