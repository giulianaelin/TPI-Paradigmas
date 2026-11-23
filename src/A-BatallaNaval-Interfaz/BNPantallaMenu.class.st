"
Soy el menu inicial: Nueva partida, Cargar partida (habilitado solo si hay una partida guardada), Opciones y Salir, sobre la portada, con la nutria asomada al cartel.
"
Class {
	#name : 'BNPantallaMenu',
	#superclass : 'BNPantalla',
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'initialization' }
BNPantallaMenu >> crearBotones [

	(self agregarBoton: (384 @ 309 extent: 510 @ 72) texto: 'Nueva partida' icono: #jugar accion: [juego nuevaPartida]).
	(self agregarBoton: (384 @ 405 extent: 510 @ 72) texto: 'Cargar partida' icono: #cargar accion: [juego cargarPartida])
		habilitado: juego archivo existe.
	self agregarBoton: (384 @ 501 extent: 510 @ 72) texto: 'Opciones' icono: #opciones accion: [juego mostrarOpciones].
	self agregarBoton: (384 @ 597 extent: 510 @ 72) texto: 'Salir' icono: #salir accion: [juego cerrar]
]

{ #category : 'dibujo' }
BNPantallaMenu >> dibujarContenidoEn: unCanvas [

	| recursos |
	recursos := self recursos.
	unCanvas translucentImage: (recursos imagen: 'logo-chico') at: 693 @ 24.
	self dibujarVentana: (339 @ 228 extent: 600 @ 474) titulo: 'Menú principal' en: unCanvas.
	#(#(285 348) #(957 270) #(975 558) #(297 618) #(849 186) #(951 660)) do: [:unPar |
		unCanvas translucentImage: recursos brillo at: unPar first @ unPar last].
	unCanvas translucentImage: (recursos imagen: 'vida-sana' ampliada: 3) at: 903 @ 672.
	unCanvas translucentImage: (recursos imagen: 'nutria-asomada' ampliada: 2) at: 317 @ 38
]
