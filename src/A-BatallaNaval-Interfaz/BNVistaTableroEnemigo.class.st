"
Muestro el tablero de la computadora como lo ve el jugador: solo las casillas que ya ataco (agua, isla, mina detonada, impacto), las naves enemigas que ya hundio y las minas que descubrio el sonar. Las naves a flote, las minas sin detonar y los impactos a un submarino sumergido quedan ocultos. Tambien marco la ultima zona que exploro el sonar.
"
Class {
	#name : 'BNVistaTableroEnemigo',
	#superclass : 'BNVistaTablero',
	#instVars : [
		'zonaSonar'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'sonar' }
BNVistaTableroEnemigo >> borrarSonar [

	zonaSonar := nil
]

{ #category : 'dibujo' }
BNVistaTableroEnemigo >> dibujaAtenuada: unaNave [

	^false
]

{ #category : 'sonar' }
BNVistaTableroEnemigo >> dibujarEn: unCanvas con: unosRecursos [

	super dibujarEn: unCanvas con: unosRecursos.
	zonaSonar ifNotNil: [
		| zona |
		zona := zonaSonar inject: (self rectanguloDe: zonaSonar first) into: [:total :unaCoordenada |
			total merge: (self rectanguloDe: unaCoordenada)].
		zonaSonar do: [:unaCoordenada |
			unCanvas fillRectangle: (self rectanguloDe: unaCoordenada) color: (Color white alpha: 0.3)].
		unCanvas frameRectangle: zona width: 3 color: BNLienzoPixel rosa]
]

{ #category : 'dibujo' }
BNVistaTableroEnemigo >> dibujarMarcasDe: unaCasilla en: unCanvas con: unosRecursos [

	(tablero tieneMinaDescubiertaEn: unaCasilla coordenada) ifTrue: [
		self pegar: 'mina' en: unaCasilla coordenada canvas: unCanvas con: unosRecursos].
	self dibujarAtaqueEn: unaCasilla canvas: unCanvas con: unosRecursos
]

{ #category : 'dibujo' }
BNVistaTableroEnemigo >> dibujarNavesEn: unCanvas con: unosRecursos [

	(self navesEnElTablero select: [:unaNave | unaNave estaHundida])
		do: [:unaNave | self dibujarNave: unaNave en: unCanvas con: unosRecursos]
]

{ #category : 'sonar' }
BNVistaTableroEnemigo >> mostrarSonar: unasCoordenadas [

	zonaSonar := unasCoordenadas
]

{ #category : 'dibujo' }
BNVistaTableroEnemigo >> seVeElImpactoEn: unaCasilla [

	"A una nave oculta (submarino sumergido) se le pego sin saberlo: se ve como agua."
	^unaCasilla ocupante estaOculta not
]

{ #category : 'dibujo' }
BNVistaTableroEnemigo >> seVeLaIslaEn: unaCoordenada [

	"En el tablero enemigo, una casilla de isla se descubre cuando se le dispara."
	^(tablero casillaEn: unaCoordenada) fueAtacada
]
