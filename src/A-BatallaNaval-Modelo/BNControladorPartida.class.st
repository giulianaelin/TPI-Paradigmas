"
Se encarga de organizar los dos tableros del juego: el del jugador y el de la computadora. Tambien utiliza el generador de islas y minas y controla que informacion se puede mostrar de cada tablero. No se encarga de dibujar la interfaz grafica.
"
Class {
	#name : 'BNControladorPartida',
	#superclass : 'Object',
	#instVars : [
		'tableroJugador',
		'tableroComputadora',
		'generador',
		'configuracion',
		'perspectivaPropia',
		'perspectivaEnemiga'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}
