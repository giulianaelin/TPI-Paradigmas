"
Soy un lienzo de pixeles ""logicos"" donde se dibujan los carteles con estilo pixel art: ventanas, botones, globos de dialogo, iconos y brillitos. Despues me agrando con ampliadoPor: copiando cada pixel como un cuadrado, sin suavizar, asi se mantiene el aspecto pixelado. Del lado de clase guardo la paleta rosa pastel de la interfaz y los dibujitos (iconos) hechos con texto.
"
Class {
	#name : 'BNLienzoPixel',
	#superclass : 'Object',
	#instVars : [
		'forma'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'ampliacion' }
BNLienzoPixel class >> ampliar: unaForma por: unFactor [

	"Devuelve una copia agrandada: cada pixel pasa a ser un cuadrado de unFactor x unFactor. Pinta de una vez los tramos horizontales del mismo color, asi es rapido."
	| grande lienzo |
	unFactor = 1 ifTrue: [^unaForma].
	grande := Form extent: unaForma extent * unFactor depth: 32.
	lienzo := FormCanvas on: grande.
	0 to: unaForma height - 1 do: [:y |
		| x |
		x := 0.
		[x < unaForma width] whileTrue: [
			| valor inicio |
			valor := unaForma pixelValueAt: x @ y.
			inicio := x.
			[x < unaForma width and: [(unaForma pixelValueAt: x @ y) = valor]] whileTrue: [x := x + 1].
			(valor bitShift: -24) > 0 ifTrue: [
				lienzo
					fillRectangle: ((inicio @ y) * unFactor extent: ((x - inicio) @ 1) * unFactor)
					color: (Color colorFromPixelValue: valor depth: 32)]]].
	^grande
]

{ #category : 'paleta' }
BNLienzoPixel class >> apagado [

	"Fondo de los botones deshabilitados."
	^Color fromHexString: 'EADDE2'
]

{ #category : 'paleta' }
BNLienzoPixel class >> blanco [

	^Color white
]

{ #category : 'dibujitos' }
BNLienzoPixel class >> brillo [

	^#('..#..' '..#..' '##o##' '..#..' '..#..')
]

{ #category : 'paleta' }
BNLienzoPixel class >> claro [

	"Fondo de los paneles."
	^Color fromHexString: 'FCE4E4'
]

{ #category : 'dibujitos' }
BNLienzoPixel class >> colaDeGlobo [

	"La colita del globo de dialogo, que apunta a la nutria."
	^#('.......#' '.....##o' '...##ooo' '.##ooooo' '#ooooooo' '.##ooooo' '...##ooo' '.....##o' '.......#')
]

{ #category : 'paleta' }
BNLienzoPixel class >> corazon [

	^Color fromHexString: 'F56E9E'
]

{ #category : 'dibujitos' }
BNLienzoPixel class >> corazonChico [

	^#('.##.##.' '#######' '#######' '.#####.' '..###..' '...#...')
]

{ #category : 'paleta' }
BNLienzoPixel class >> crema [

	^Color fromHexString: 'FFF3F3'
]

{ #category : 'instance creation' }
BNLienzoPixel class >> extent: unTamano [

	"Crea un lienzo transparente de ese tamano, en pixeles logicos."
	^self new setForma: (Form extent: unTamano depth: 32)
]

{ #category : 'paleta' }
BNLienzoPixel class >> franja [

	"Lineas de la cuadricula y sombras suaves."
	^Color fromHexString: 'F9D2D8'
]

{ #category : 'dibujitos' }
BNLienzoPixel class >> iconos [

	"Iconos de 7x7 para los botones. # contorno, o color, w relleno claro."
	^Dictionary new
		at: #jugar put: #('#......' '##.....' '#o#....' '#oo#...' '#o#....' '##.....' '#......');
		at: #cargar put: #('.#####.' '#ooooo#' '#o###o#' '#ooooo#' '#######' '#ww#ww#' '#######');
		at: #opciones put: #('..#.#..' '.#####.' '##o.o##' '.#...#.' '##o.o##' '.#####.' '..#.#..');
		at: #salir put: #('.####..' '.#ww#..' '.#ww#.#' '.#ww###' '.#ww#.#' '.#ww#..' '.####..');
		at: #arriba put: #('...#...' '..###..' '.#####.' '#######' '..###..' '..###..' '..###..');
		at: #abajo put: #('..###..' '..###..' '..###..' '#######' '.#####.' '..###..' '...#...');
		at: #izquierda put: #('...#...' '..##...' '.######' '#######' '.######' '..##...' '...#...');
		at: #derecha put: #('...#...' '...##..' '######.' '#######' '######.' '...##..' '...#...');
		at: #girar put: #('.####..' '#....#.' '#...###' '#....#.' '#......' '#....#.' '.####..');
		at: #azar put: #('#######' '#ow.wo#' '#wwwww#' '#ww#ww#' '#wwwww#' '#ow.wo#' '#######');
		at: #mas put: #('..###..' '..#o#..' '###o###' '#ooooo#' '###o###' '..#o#..' '..###..');
		at: #menos put: #('.......' '.......' '#######' '#ooooo#' '#######' '.......' '.......');
		at: #guardar put: #('#######' '#w#ww##' '#w#ww##' '#######' '#ooooo#' '#ooooo#' '#######');
		at: #reloj put: #('#######' '#wwwww#' '.#ooo#.' '..#o#..' '.#wow#.' '#ooooo#' '#######');
		at: #sonar put: #('.#####.' '#wwwww#' '#w###w#' '#w#o#w#' '#w###w#' '#wwwww#' '.#####.');
		at: #menu put: #('...#...' '..#w#..' '.#www#.' '#wwwww#' '.#w#w#.' '.#w#w#.' '.#####.');
		yourself
]

{ #category : 'paleta' }
BNLienzoPixel class >> oscuro [

	"Contorno de todos los carteles."
	^Color fromHexString: 'C2577F'
]

{ #category : 'paleta' }
BNLienzoPixel class >> rosa [

	^Color fromHexString: 'F08ABA'
]

{ #category : 'paleta' }
BNLienzoPixel class >> rosa2 [

	^Color fromHexString: 'F6B3CB'
]

{ #category : 'paleta' }
BNLienzoPixel class >> sombra [

	^Color fromHexString: 'D76A8A'
]

{ #category : 'paleta' }
BNLienzoPixel class >> texto [

	"Color de las letras: malva oscuro."
	^Color fromHexString: '8A3B5E'
]

{ #category : 'paleta' }
BNLienzoPixel class >> textoApagado [

	^Color fromHexString: 'B8A2AC'
]

{ #category : 'conversion' }
BNLienzoPixel >> ampliadoPor: unFactor [

	^self class ampliar: forma por: unFactor
]

{ #category : 'dibujo de carteles' }
BNLienzoPixel >> botonEn: unRectangulo estado: unEstado [

	"Boton redondeado. El estado es #normal, #resaltado (mouse encima o elegido) o #apagado (deshabilitado)."
	unEstado = #resaltado ifTrue: [
		^self caja: unRectangulo radio: 3 relleno: (Color fromHexString: 'F7A8C8') borde: self class oscuro
			luz: (Color fromHexString: 'FBCDDE') oscuro: (Color fromHexString: 'EA86AE') sombra: self class oscuro].
	unEstado = #apagado ifTrue: [
		^self caja: unRectangulo radio: 3 relleno: self class apagado borde: self class textoApagado
			luz: (Color fromHexString: 'F4ECEF') oscuro: nil sombra: self class textoApagado].
	self caja: unRectangulo radio: 3 relleno: self class crema borde: self class oscuro
		luz: self class blanco oscuro: self class franja sombra: self class sombra
]

{ #category : 'dibujo de carteles' }
BNLienzoPixel >> brilloEn: unPunto [

	self sprite: self class brillo en: unPunto
		colores: (Dictionary new at: $# put: (Color fromHexString: 'FBCDDE'); at: $o put: self class blanco; yourself) escala: 2
]

{ #category : 'dibujo basico' }
BNLienzoPixel >> caja: unRectangulo radio: r relleno: unRelleno borde: unBorde luz: unaLuz oscuro: unOscuro sombra: unaSombra [

	"Caja redondeada con contorno de 1 pixel, luz arriba, parte oscura abajo y sombra proyectada (cualquiera puede ser nil)."
	| x0 y0 w h |
	x0 := unRectangulo left.
	y0 := unRectangulo top.
	w := unRectangulo width.
	h := unRectangulo height.
	unaSombra ifNotNil: [
		0 to: h - 1 do: [:y | 0 to: w - 1 do: [:x |
			(self dentro: x y: y ancho: w alto: h radio: r)
				ifTrue: [self pintar: unaSombra en: (x0 + x) @ (y0 + y + 2)]]]].
	0 to: h - 1 do: [:y | 0 to: w - 1 do: [:x |
		(self dentro: x y: y ancho: w alto: h radio: r) ifTrue: [
			| color |
			color := unRelleno.
			(unOscuro notNil and: [(self dentro: x y: y + 2 ancho: w alto: h radio: r) not])
				ifTrue: [color := unOscuro].
			(unaLuz notNil and: [(self dentro: x y: y - 2 ancho: w alto: h radio: r) not])
				ifTrue: [color := unaLuz].
			(self esBorde: x y: y ancho: w alto: h radio: r) ifTrue: [color := unBorde].
			self pintar: color en: (x0 + x) @ (y0 + y)]]]
]

{ #category : 'dibujo basico' }
BNLienzoPixel >> dentro: x y: y ancho: w alto: h radio: r [

	"Verdadero si el pixel (x, y) cae dentro de un rectangulo de w x h con las esquinas redondeadas (radio r)."
	| cx cy |
	(x < 0 or: [y < 0 or: [x >= w or: [y >= h]]]) ifTrue: [^false].
	x < r
		ifTrue: [cx := r]
		ifFalse: [x > (w - r - 1) ifTrue: [cx := w - r - 1] ifFalse: [^true]].
	y < r
		ifTrue: [cy := r]
		ifFalse: [y > (h - r - 1) ifTrue: [cy := h - r - 1] ifFalse: [^true]].
	^(x - cx) squared + (y - cy) squared <= ((r * r) + 0.5)
]

{ #category : 'dibujo basico' }
BNLienzoPixel >> esBorde: x y: y ancho: w alto: h radio: r [

	"Un pixel es borde si alguno de sus cuatro vecinos queda afuera."
	^#(#(1 0) #(-1 0) #(0 1) #(0 -1)) anySatisfy: [:d |
		(self dentro: x + d first y: y + d last ancho: w alto: h radio: r) not]
]

{ #category : 'accessing' }
BNLienzoPixel >> forma [

	^forma
]

{ #category : 'dibujo de carteles' }
BNLienzoPixel >> globoEn: unRectangulo [

	"Globo de dialogo con la colita a la izquierda (los primeros 8 pixeles son para la colita)."
	| caja |
	caja := (unRectangulo left + 8) @ unRectangulo top corner: unRectangulo corner.
	self caja: caja radio: 5 relleno: self class crema borde: self class oscuro luz: self class blanco oscuro: self class franja sombra: self class sombra.
	self sprite: self class colaDeGlobo en: (unRectangulo left + 1) @ (unRectangulo top + (unRectangulo height // 2) - 4)
		colores: (Dictionary new at: $# put: self class oscuro; at: $o put: self class crema; yourself) escala: 1.
	self sprite: self class corazonChico en: (caja right - 12) @ (caja top + 5)
		colores: (Dictionary new at: $# put: self class corazon; yourself) escala: 1
]

{ #category : 'dibujo basico' }
BNLienzoPixel >> grillaEn: unRectangulo paso: unPaso [

	"Fondo cuadriculado, como una hoja de cuaderno."
	0 to: unRectangulo height - 1 do: [:y | 0 to: unRectangulo width - 1 do: [:x |
		self
			pintar: (((x \\ unPaso) = 0 or: [(y \\ unPaso) = 0])
				ifTrue: [self class franja]
				ifFalse: [self class claro])
			en: unRectangulo origin + (x @ y)]]
]

{ #category : 'dibujo de carteles' }
BNLienzoPixel >> icono: unNombre en: unPunto escala: k apagado: estaApagado [

	| colores |
	colores := Dictionary new.
	estaApagado
		ifTrue: [colores at: $# put: self class textoApagado; at: $o put: self class textoApagado; at: $w put: self class apagado]
		ifFalse: [colores at: $# put: self class oscuro; at: $o put: self class corazon; at: $w put: self class crema].
	self sprite: (self class iconos at: unNombre) en: unPunto colores: colores escala: k
]

{ #category : 'dibujo basico' }
BNLienzoPixel >> pintar: unColor en: unPunto [

	"Pinta un pixel logico. Lo que cae afuera del lienzo se ignora."
	(forma boundingBox containsPoint: unPunto) ifTrue: [forma colorAt: unPunto put: unColor]
]

{ #category : 'initialization' }
BNLienzoPixel >> setForma: unaForma [

	forma := unaForma
]

{ #category : 'dibujo basico' }
BNLienzoPixel >> sprite: unasFilas en: unPunto colores: unDiccionario escala: k [

	"Dibuja un dibujito hecho con texto: cada caracter es un pixel de k x k. Los caracteres que no estan en el diccionario quedan transparentes."
	unasFilas withIndexDo: [:fila :iy |
		fila withIndexDo: [:caracter :ix |
			unDiccionario at: caracter ifPresent: [:color |
				0 to: k - 1 do: [:a | 0 to: k - 1 do: [:b |
					self pintar: color en: unPunto + ((((ix - 1) * k) + a) @ (((iy - 1) * k) + b))]]]]]
]

{ #category : 'dibujo de carteles' }
BNLienzoPixel >> ventanaEn: unRectangulo [

	"Ventanita: contorno, marco rosa, barra de titulo con tres puntitos y un corazon, e interior cuadriculado."
	| x0 y0 w h iy |
	x0 := unRectangulo left.
	y0 := unRectangulo top.
	w := unRectangulo width.
	h := unRectangulo height.
	self caja: unRectangulo radio: 4 relleno: self class rosa borde: self class oscuro luz: nil oscuro: nil sombra: self class sombra.
	3 to: w - 4 do: [:x | self pintar: self class rosa2 en: (x0 + x) @ (y0 + 1)].
	self caja: ((x0 + 3) @ (y0 + 3) extent: (w - 6) @ 12) radio: 2 relleno: self class rosa2 borde: self class oscuro luz: self class crema oscuro: nil sombra: nil.
	0 to: 2 do: [:i |
		self sprite: #('##' '##') en: (x0 + 7 + (i * 5)) @ (y0 + 7) colores: (Dictionary new at: $# put: self class crema; yourself) escala: 1].
	self sprite: self class corazonChico en: (x0 + w - 13) @ (y0 + 6) colores: (Dictionary new at: $# put: self class corazon; yourself) escala: 1.
	iy := y0 + 17.
	self caja: ((x0 + 3) @ iy extent: (w - 6) @ (h - (iy - y0) - 3)) radio: 2 relleno: self class claro borde: self class oscuro luz: nil oscuro: nil sombra: nil.
	self grillaEn: ((x0 + 4) @ (iy + 1) extent: (w - 8) @ (h - (iy - y0) - 5)) paso: 8
]
