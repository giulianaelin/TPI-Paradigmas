"
Prueba BNFlota: la flota estandar (2 naves de cada tipo, 10 en total) y la condicion de derrota (todas las naves hundidas).
"
Class {
	#name : 'BNFlotaTest',
	#superclass : 'TestCase',
	#instVars : [
		'flota'
	],
	#category : 'A-BatallaNaval-Tests',
	#package : 'A-BatallaNaval-Tests'
}

{ #category : 'utilidades' }
BNFlotaTest >> hundir: unaNave [
    "Le da a la nave todos los impactos que resiste."
    unaNave resistencia timesRepeat: [unaNave recibirImpacto]
]

{ #category : 'running' }
BNFlotaTest >> setUp [
    "Cada test arranca con una flota estandar nueva."
    super setUp.
    flota := BNFlota estandar
]

{ #category : 'tests' }
BNFlotaTest >> testHayDosNavesDeCadaTipo [
    "Dos portaaviones, dos acorazados, dos cruceros, dos submarinos y dos destructores."
    BNFlota tiposDeNave do: [:unTipo |
        self assert: (flota naves select: [:unaNave | unaNave class == unTipo]) size equals: 2]
]

{ #category : 'tests' }
BNFlotaTest >> testLaFlotaEstandarTieneDiezNaves [
    "La consigna pide 10 naves por jugador."
    self assert: flota naves size equals: 10.
    self assert: flota navesAFlote size equals: 10
]

{ #category : 'tests' }
BNFlotaTest >> testOcupaTreintaYCuatroCasillas [
    "2 x (5 + 4 + 3 + 3 + 2) = 34 casillas."
    self assert: flota casillasNecesarias equals: 34
]

{ #category : 'tests' }
BNFlotaTest >> testSeDestruyeCuandoSeHundenTodas [
    "Mientras quede una nave a flote, la flota no esta destruida."
    | naves |
    naves := flota naves.
    naves allButLast do: [:unaNave | self hundir: unaNave].
    self deny: flota estaDestruida.
    self hundir: naves last.
    self assert: flota estaDestruida
]

{ #category : 'tests' }
BNFlotaTest >> testUnaFlotaNuevaNoEstaDestruida [
    "Recien creada, ninguna nave esta hundida."
    self deny: flota estaDestruida
]

{ #category : 'tests' }
BNFlotaTest >> testUnaNaveHundidaNoCuentaComoAFlote [
    "Al hundir una nave, quedan 9 a flote."
    self hundir: flota naves first.
    self assert: flota navesAFlote size equals: 9.
    self deny: flota estaDestruida
]
