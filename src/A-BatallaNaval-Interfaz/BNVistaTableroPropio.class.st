"
Muestro el tablero del jugador: sus islas, sus naves y lo que le pego la computadora. Las minas armadas solo se ven mientras mostrarMinas es verdadero (al empezar la partida, unos segundos, para memorizarlas).
"
Class {
	#name : 'BNVistaTableroPropio',
	#superclass : 'BNVistaTablero',
	#instVars : [
		'mostrarMinas'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'dibujo' }
BNVistaTableroPropio >> dibujaAtenuada: unaNave [

	"Las naves ocultas (el submarino sumergido) se ven medio transparentes, como bajo el agua."
	^unaNave estaOculta
]

{ #category : 'dibujo' }
BNVistaTableroPropio >> dibujarMarcasDe: unaCasilla en: unCanvas con: unosRecursos [

	(self muestraMinas and: [unaCasilla tieneMinaActiva]) ifTrue: [
		self pegar: 'mina' en: unaCasilla coordenada canvas: unCanvas con: unosRecursos].
	self dibujarAtaqueEn: unaCasilla canvas: unCanvas con: unosRecursos
]

{ #category : 'dibujo' }
BNVistaTableroPropio >> dibujarNavesEn: unCanvas con: unosRecursos [

	self navesEnElTablero do: [:unaNave | self dibujarNave: unaNave en: unCanvas con: unosRecursos]
]

{ #category : 'accessing' }
BNVistaTableroPropio >> mostrarMinas: unBooleano [

	mostrarMinas := unBooleano
]

{ #category : 'accessing' }
BNVistaTableroPropio >> muestraMinas [

	^mostrarMinas == true
]

{ #category : 'dibujo' }
BNVistaTableroPropio >> seVeElImpactoEn: unaCasilla [

	"En el tablero propio se ve todo el dano, aunque el enemigo no lo sepa."
	^true
]

{ #category : 'dibujo' }
BNVistaTableroPropio >> seVeLaIslaEn: unaCoordenada [

	"En el tablero propio las islas se ven siempre."
	^true
]
