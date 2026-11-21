"
Prueba BNPartida: la preparacion (terreno y flota de la computadora), la fase de ubicacion, los turnos y que una partida completa termine con un ganador. Usa un Random con semilla fija.
"
Class {
	#name : 'BNPartidaTest',
	#superclass : 'TestCase',
	#instVars : [
		'partida'
	],
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'utilidades' }
BNPartidaTest >> jugarHastaElFinal [
    "El jugador dispara al azar (con la misma estrategia que la computadora) hasta que alguien gana."
    | estrategia vueltas |
    estrategia := BNEstrategiaAleatoria new.
    vueltas := 0.
    [partida estaTerminada or: [vueltas > 2000]] whileFalse: [
        | nave |
        nave := partida jugador navesAFlote
            detect: [:unaNave | unaNave arma cantidadDeObjetivos = 1]
            ifNone: [partida jugador navesAFlote first].
        partida
            disparar: nave
            a: (estrategia elegirObjetivos: nave arma cantidadDeObjetivos en: partida computadora tablero con: partida)
            hacia: BNCoordenada horizontal.
        vueltas := vueltas + 1]
]

{ #category : 'running' }
BNPartidaTest >> setUp [
    "Partida con semilla fija."
    super setUp.
    partida := BNPartida conRandom: (Random seed: 7)
]

{ #category : 'tests' }
BNPartidaTest >> testAlEmpezarSeUbicanLasNaves [
    "La partida arranca en ubicacion, con la flota de la computadora ya ubicada y la del jugador sin ubicar."
    self assert: partida fase equals: #ubicacion.
    self assert: partida computadora navesSinUbicar isEmpty.
    self assert: partida jugador navesSinUbicar size equals: 10
]

{ #category : 'tests' }
BNPartidaTest >> testDespuesDeDispararVuelveATocarleAlJugador [
    "La computadora juega sola: cuando termina el metodo, le toca de nuevo al jugador (o termino la partida)."
    | nave objetivo |
    partida ubicarFlotaDelJugadorAlAzar.
    nave := partida jugador naves detect: [:unaNave | unaNave class == BNAcorazado].
    objetivo := partida computadora tablero coordenadasSinAtacar first.
    partida disparar: nave a: { objetivo } hacia: BNCoordenada horizontal.
    self assert: (partida estaTerminada or: [partida turno == partida jugador]).
    self assert: partida registro notEmpty
]

{ #category : 'tests' }
BNPartidaTest >> testLosDosTablerosTienenTerreno [
    "Cada tablero tiene sus 3 islas."
    self assert: partida jugador tablero islas size equals: 3.
    self assert: partida computadora tablero islas size equals: 3
]

{ #category : 'tests' }
BNPartidaTest >> testNoSePuedeDispararDosVecesALaMismaCasilla [
    "Una casilla ya atacada no se elige de nuevo."
    | nave objetivo |
    partida ubicarFlotaDelJugadorAlAzar.
    nave := partida jugador naves detect: [:unaNave | unaNave class == BNAcorazado].
    objetivo := partida computadora tablero coordenadasSinAtacar first.
    (partida computadora tablero casillaEn: objetivo) marcarAtacada.
    self
        should: [partida disparar: nave a: { objetivo } hacia: BNCoordenada horizontal]
        raise: BNOperacionInvalida
]

{ #category : 'tests' }
BNPartidaTest >> testNoSePuedeDispararDuranteLaUbicacion [
    "Antes de la batalla no se dispara."
    self
        should: [partida disparar: partida jugador naves first a: { BNCoordenada desdeTexto: 'A1' } hacia: BNCoordenada horizontal]
        raise: BNOperacionInvalida
]

{ #category : 'tests' }
BNPartidaTest >> testUbicarLaUltimaNaveEmpiezaLaBatalla [
    "Al ubicar todas las naves empieza la batalla y dispara primero el jugador."
    partida ubicarFlotaDelJugadorAlAzar.
    self assert: partida fase equals: #batalla.
    self assert: partida turno equals: partida jugador.
    self assert: partida jugador navesSinUbicar isEmpty
]

{ #category : 'tests' }
BNPartidaTest >> testUnaPartidaCompletaTerminaConUnGanador [
    "Jugando hasta el final, uno gana y el otro tiene la flota destruida."
    partida ubicarFlotaDelJugadorAlAzar.
    self jugarHastaElFinal.
    self assert: partida estaTerminada.
    self assert: partida ganador notNil.
    self deny: partida ganador estaDerrotado.
    self assert: (partida enemigoDe: partida ganador) estaDerrotado
]
