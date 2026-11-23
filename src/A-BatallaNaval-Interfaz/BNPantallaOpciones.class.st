"
Pantalla de opciones: la dificultad (Facil = el enemigo dispara al azar; Intermedio = caza y remata) y el volumen de la musica, con un corazon por cada punto de volumen. La eleccion queda guardada en el juego y se usa al crear la proxima partida.
"
Class {
	#name : 'BNPantallaOpciones',
	#superclass : 'BNPantalla',
	#instVars : [
		'botonFacil',
		'botonIntermedio'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'initialization' }
BNPantallaOpciones >> crearBotones [

	botonFacil := self agregarBoton: (471 @ 300 extent: 168 @ 54) texto: 'Fácil' icono: nil accion: [self elegirDificultad: #facil].
	botonIntermedio := self agregarBoton: (651 @ 300 extent: 168 @ 54) texto: 'Intermedio' icono: nil accion: [self elegirDificultad: #intermedio].
	self marcarDificultad.
	self agregarBoton: (471 @ 462 extent: 54 @ 54) texto: '' icono: #menos accion: [juego musica bajarVolumen].
	self agregarBoton: (765 @ 462 extent: 54 @ 54) texto: '' icono: #mas accion: [juego musica subirVolumen].
	self agregarBoton: (471 @ 543 extent: 348 @ 54) texto: 'Volver' icono: #izquierda accion: [juego mostrarMenu]
]

{ #category : 'dibujo' }
BNPantallaOpciones >> dibujarContenidoEn: unCanvas [

	unCanvas translucentImage: (self recursos imagen: 'logo-chico') at: 693 @ 24.
	self dibujarVentana: (429 @ 180 extent: 423 @ 450) titulo: 'Opciones' en: unCanvas.
	self escribir: 'Dificultad' en: 471 @ 255 escala: 3 en: unCanvas.
	self
		escribirParrafos: (Array with: (juego dificultad = #intermedio
			ifTrue: ['Si te pega, sigue tirando alrededor hasta hundirte.']
			ifFalse: ['El enemigo dispara al azar.']))
		en: 471 @ 366 ancho: 348 en: unCanvas.
	self escribir: 'Volumen de la música' en: 471 @ 420 escala: 3 en: unCanvas.
	1 to: 10 do: [:i |
		unCanvas
			translucentImage: (self recursos imagen: (i <= juego musica volumen ifTrue: ['vida-sana'] ifFalse: ['vida-perdida']) ampliada: 2)
			at: (537 + ((i - 1) * 22)) @ 477]
]

{ #category : 'acciones' }
BNPantallaOpciones >> elegirDificultad: unaDificultad [

	juego dificultad: unaDificultad.
	self marcarDificultad
]

{ #category : 'acciones' }
BNPantallaOpciones >> marcarDificultad [

	"Resalta el boton de la dificultad elegida."
	botonFacil elegido: juego dificultad = #facil.
	botonIntermedio elegido: juego dificultad = #intermedio
]
