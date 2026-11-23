"
Coordino una partida entre la persona y la computadora: preparo los tableros (terreno al azar y flota de la computadora), controlo las fases (#ubicacion, #batalla, #terminada) y los turnos, resuelvo los disparos (probabilidad de impacto, desvio, minas, disparo extra al acertar) y detecto al ganador. Llevo un registro con lo que pasa en cada turno. Todo el azar pasa por elegirUnaDe: y aciertaTiradaDe:, asi en los tests se usa un Random con semilla fija. No se nada de la interfaz.
"
Class {
	#name : 'BNPartida',
	#superclass : 'Object',
	#instVars : [
		'jugador',
		'computadora',
		'fase',
		'turno',
		'ganador',
		'random',
		'estrategia',
		'registro'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'instance creation' }
BNPartida class >> conRandom: unRandom [
    "Crea una partida lista para que el jugador ubique sus naves. En los tests se le pasa un Random con semilla fija."
    ^self new setRandom: unRandom
]

{ #category : 'instance creation' }
BNPartida class >> nueva [
    "Crea una partida con azar real."
    ^self conRandom: Random new
]

{ #category : 'azar' }
BNPartida >> aciertaTiradaDe: unaNave [
    "Sortea un numero de 1 a 100: el disparo sale donde se apunto si no supera la probabilidad de la nave."
    ^(random nextInteger: 100) <= unaNave probabilidadDeImpacto
]

{ #category : 'registro' }
BNPartida >> anotar: unTexto [
    registro add: unTexto
]

{ #category : 'turnos' }
BNPartida >> aplicarMinaA: unaNave [
    "Disparar a una mina enemiga le cuesta 1 vida a la nave que disparo."
    | antes |
    unaNave estaAFlote ifFalse: [^self].
    antes := unaNave resistenciaRestante.
    unaNave recibirDanioDeMina.
    unaNave resistenciaRestante < antes
        ifTrue: [self anotar: '  ¡Mina! ', unaNave nombre, ' pierde 1 vida.']
        ifFalse: [self anotar: '  ¡Mina! Al ', unaNave nombre, ' no le hace nada.']
]

{ #category : 'turnos' }
BNPartida >> avisarQueAtaca: unaNave [
    "Le avisa a la nave que esta atacando. Si estaba oculta y por atacar queda a la vista, se anota."
    | estabaOculta |
    estabaOculta := unaNave estaOculta.
    unaNave alAtacar.
    (estabaOculta and: [unaNave estaOculta not]) ifTrue: [
        self anotar: '  ¡', unaNave nombre, ' sale a la superficie: ahora se ven sus impactos!']
]

{ #category : 'turnos' }
BNPartida >> comenzarBatalla [
    fase := #batalla.
    self pasarElTurnoA: jugador.
    self anotar: '¡Comienza la batalla! Te toca disparar.'.
    self verificarFin
]

{ #category : 'accessing' }
BNPartida >> computadora [
    ^computadora
]

{ #category : 'turnos' }
BNPartida >> desviar: unTiro [
    "Corre el tiro entero una casilla hacia una vecina al azar de la primera coordenada. Lo que queda fuera del tablero se pierde."
    | origen vecina desplazamiento |
    origen := unTiro first.
    vecina := self elegirUnaDe: origen vecinosConDiagonales.
    desplazamiento := origen desplazamientoHasta: vecina.
    ^(unTiro select: [:unaCoordenada | unaCoordenada puedeDesplazarseEn: desplazamiento])
        collect: [:unaCoordenada | unaCoordenada desplazadaEn: desplazamiento]
]

{ #category : 'turnos' }
BNPartida >> disparar: unaNave a: unosObjetivos hacia: unaDireccion [
    "Accion del jugador: dispara con una de sus naves. Si no acierta, el turno pasa a la computadora."
    self validarTurnoDe: jugador.
    self ejecutarDisparoDe: jugador con: unaNave a: unosObjetivos hacia: unaDireccion
]

{ #category : 'turnos' }
BNPartida >> ejecutarDisparoDe: unAtacante con: unaNave a: unosObjetivos hacia: unaDireccion [
    "Resuelve un disparo completo. Si dano alguna nave (y no piso una mina), el atacante vuelve a disparar; si no, pasa el turno."
    | enemigo arma tiros huboDanio huboMina |
    ((unAtacante tieneLaNave: unaNave) and: [unaNave estaAFlote]) ifFalse: [
        ^BNOperacionInvalida signal: 'Esa nave no puede disparar'].
    enemigo := self enemigoDe: unAtacante.
    (unosObjetivos anySatisfy: [:unObjetivo | (enemigo tablero casillaEn: unObjetivo) fueAtacada])
        ifTrue: [^BNOperacionInvalida signal: 'Ya se disparo en esa casilla'].
    arma := unaNave armaDisponible.
    tiros := arma tirosDesde: unosObjetivos hacia: unaDireccion.
    unaNave registrarUsoDe: arma.
    self anotar: unAtacante nombre, ': ', unaNave nombre, ' usa ', arma nombre, '.'.
    self avisarQueAtaca: unaNave.
    huboDanio := false.
    huboMina := false.
    tiros do: [:unTiro |
        | resultados |
        resultados := self resolverTiro: unTiro de: unaNave contra: enemigo.
        (resultados anySatisfy: [:unResultado | unResultado = #impacto or: [unResultado = #hundido]])
            ifTrue: [huboDanio := true].
        (resultados includes: #mina) ifTrue: [huboMina := true]].
    self verificarFin.
    self estaTerminada ifTrue: [^self].
    (huboDanio and: [huboMina not])
        ifTrue: [self anotar: '  ¡Acerto! ', unAtacante nombre, ' vuelve a disparar.']
        ifFalse: [self pasarElTurnoA: enemigo]
]

{ #category : 'azar' }
BNPartida >> elegirUnaDe: unaColeccion [
    "Elige un elemento al azar. Todo el azar de la partida pasa por aca y por aciertaTiradaDe:."
    ^unaColeccion asArray atRandom: random
]

{ #category : 'testing' }
BNPartida >> enBatalla [
    ^fase = #batalla
]

{ #category : 'testing' }
BNPartida >> enUbicacion [
    ^fase = #ubicacion
]

{ #category : 'accessing' }
BNPartida >> enemigoDe: unJugador [
    "El rival de ese jugador."
    ^unJugador == jugador
        ifTrue: [computadora]
        ifFalse: [jugador]
]

{ #category : 'testing' }
BNPartida >> estaTerminada [
    ^fase = #terminada
]

{ #category : 'computadora' }
BNPartida >> estrategia [
	^estrategia
]

{ #category : 'accessing' }
BNPartida >> fase [
    "#ubicacion, #batalla o #terminada."
    ^fase
]

{ #category : 'accessing' }
BNPartida >> ganador [
    "El jugador que gano, o nil si la partida sigue."
    ^ganador
]

{ #category : 'accessing' }
BNPartida >> jugador [
    ^jugador
]

{ #category : 'computadora' }
BNPartida >> jugarTurnoDeLaComputadora [
    "La computadora hace un disparo. Si acierta, le sigue tocando a ella."
    self validarTurnoDe: computadora.
    self jugarUnDisparoDeLaComputadora
]

{ #category : 'computadora' }
BNPartida >> jugarTurnosDeLaComputadora [
    "Mientras le toque a la computadora, dispara."
    [self estaTerminada not and: [turno == computadora]] whileTrue: [
        self jugarUnDisparoDeLaComputadora]
]

{ #category : 'computadora' }
BNPartida >> jugarUnDisparoDeLaComputadora [
    "La computadora elige al azar una nave a flote, una direccion y los objetivos."
    | disponibles naves nave objetivos direccion |
    disponibles := jugador tablero coordenadasSinAtacar size.
    naves := computadora navesAFlote select: [:unaNave |
        unaNave armaDisponible cantidadDeObjetivos <= disponibles].
    naves isEmpty ifTrue: [^self pasarElTurnoA: jugador].
    nave := self elegirUnaDe: naves.
    direccion := self elegirUnaDe: { BNCoordenada horizontal. BNCoordenada vertical }.
    objetivos := estrategia
        elegirObjetivos: nave armaDisponible cantidadDeObjetivos
        en: jugador tablero
        con: self.
    self ejecutarDisparoDe: computadora con: nave a: objetivos hacia: direccion
]

{ #category : 'computadora' }
BNPartida >> leTocaALaComputadora [
    "Verdadero si la batalla sigue y es el turno de la computadora."
    ^self enBatalla and: [turno == computadora]
]

{ #category : 'turnos' }
BNPartida >> mover: unaNave hacia: unDesplazamiento [
    "Accion del jugador: mueve una nave sana una casilla. Gasta el turno."
    self validarTurnoDe: jugador.
    (jugador tieneLaNave: unaNave) ifFalse: [
        ^BNOperacionInvalida signal: 'Esa nave no es tuya'].
    jugador tablero mover: unaNave hacia: unDesplazamiento.
    self anotar: 'Jugador: mueve su ', unaNave nombre, '.'.
    unaNave estaHerida ifTrue: [
        self anotar: '  ¡Mina! Tu ', unaNave nombre, ' perdio 1 vida.'].
    self verificarFin.
    self estaTerminada ifTrue: [^self].
    self pasarElTurnoA: computadora
]

{ #category : 'turnos' }
BNPartida >> pasarElTurnoA: unJugador [
    "Le da el turno a ese jugador. Sus naves empiezan su turno (por ejemplo, el submarino que salio a atacar se vuelve a sumergir)."
    turno := unJugador.
    unJugador naves do: [:unaNave | unaNave alEmpezarSuTurno]
]

{ #category : 'accessing' }
BNPartida >> registro [
    "Lo que fue pasando en la partida, linea por linea."
    ^registro copy
]

{ #category : 'turnos' }
BNPartida >> resolverTiro: unTiro de: unaNave contra: unEnemigo [
    "Hace la tirada de probabilidad (si falla, el tiro se desvia) y dispara a cada casilla todavia sin atacar. Devuelve los resultados."
    | objetivo resultados |
    objetivo := unTiro.
    (self aciertaTiradaDe: unaNave) ifFalse: [
        objetivo := self desviar: unTiro.
        self anotar: '  ¡Disparo desviado!'].
    resultados := OrderedCollection new.
    objetivo do: [:unaCoordenada |
        | casilla resultado |
        casilla := unEnemigo tablero casillaEn: unaCoordenada.
        casilla fueAtacada ifFalse: [
            resultado := self resultadoVisible: (unEnemigo tablero recibirDisparoEn: unaCoordenada) en: casilla de: unEnemigo.
            resultados add: resultado.
            self anotar: '  ', unaCoordenada etiqueta, ': ', (self textoDe: resultado en: casilla).
            resultado = #mina ifTrue: [self aplicarMinaA: unaNave]]].
    resultados isEmpty ifTrue: [self anotar: '  El disparo no tuvo efecto.'].
    ^resultados
]

{ #category : 'turnos' }
BNPartida >> resultadoVisible: unResultado en: unaCasilla de: unEnemigo [
    "Lo que se entera el que dispara. Si le pego a una nave oculta (un submarino sumergido), para el fue agua: no sabe que acerto, no vuelve a disparar y no lo puede rematar."
    (unResultado = #impacto and: [unaCasilla ocupante estaOculta]) ifFalse: [^unResultado].
    unEnemigo == jugador ifTrue: [
        self anotar: '  Tu ', unaCasilla ocupante nombre, ' sumergido recibio un impacto sin que el enemigo se entere.'].
    ^#agua
]

{ #category : 'initialization' }
BNPartida >> setRandom: unRandom [
    "Prepara la partida: terreno al azar en los dos tableros y flota de la computadora ubicada al azar."
    | generador |
    random := unRandom.
    registro := OrderedCollection new.
    estrategia := BNEstrategiaAleatoria new.
    jugador := BNJugador nombre: 'Jugador'.
    computadora := BNJugador nombre: 'Computadora'.
    generador := BNGeneradorTerreno conRandom: random.
    { jugador. computadora } do: [:unJugador |
        generador generarEn: unJugador tablero segun: BNConfiguracionTerreno estandar].
    self ubicarAlAzarFlotaDe: computadora.
    fase := #ubicacion.
    turno := jugador.
    self anotar: 'Ubica tus naves en tu tablero.'
]

{ #category : 'turnos' }
BNPartida >> sondear: unaCoordenada con: unaNave [
    "Accion del jugador: usa el sonar de una nave (el barreminas) en la zona de esa coordenada del tablero enemigo. No tiene probabilidad. Gasta el turno. Devuelve cuantas casillas con naves detecto."
    | sonar naves minas |
    self validarTurnoDe: jugador.
    ((jugador tieneLaNave: unaNave) and: [unaNave estaAFlote]) ifFalse: [
        ^BNOperacionInvalida signal: 'Esa nave no puede usar el sonar'].
    unaNave puedeSondear ifFalse: [
        ^BNOperacionInvalida signal: 'Esa nave no tiene sonar o lo esta recargando'].
    sonar := unaNave sonar.
    naves := sonar explorar: unaCoordenada en: computadora tablero.
    minas := ((sonar zonaAlrededorDe: unaCoordenada) select: [:otra |
        computadora tablero tieneMinaDescubiertaEn: otra]) size.
    unaNave registrarUsoDe: sonar.
    self anotar: jugador nombre, ': ', unaNave nombre, ' usa Sonar en ', unaCoordenada etiqueta, '.'.
    self anotar: '  El sonar detecta ', naves printString, ' casilla(s) con naves y ', minas printString, ' mina(s).'.
    self pasarElTurnoA: computadora.
    ^naves
]

{ #category : 'turnos' }
BNPartida >> terminarConGanador: unJugador [
    ganador := unJugador.
    fase := #terminada.
    self anotar: '¡', unJugador nombre, ' gana la partida!'
]

{ #category : 'registro' }
BNPartida >> textoDe: unResultado en: unaCasilla [
    "Texto para el registro de cada resultado de disparo."
    unResultado = #agua ifTrue: [^'Agua'].
    unResultado = #isla ifTrue: [^'Isla'].
    unResultado = #mina ifTrue: [^'¡Mina!'].
    unResultado = #impacto ifTrue: [^'¡Impacto!'].
    unResultado = #restos ifTrue: [^'Restos de una nave hundida'].
    ^'¡Hundido! (', unaCasilla ocupante nombre, ')'
]

{ #category : 'accessing' }
BNPartida >> turno [
    "El jugador al que le toca."
    ^turno
]

{ #category : 'ubicacion' }
BNPartida >> ubicacionesPosiblesDe: unaNave en: unTablero [
    "Todas las formas de ubicar la nave: pares {coordenada. direccion} validos."
    | opciones |
    opciones := OrderedCollection new.
    unTablero casillas do: [:unaCasilla |
        { BNCoordenada horizontal. BNCoordenada vertical } do: [:unaDireccion |
            (unTablero puedeUbicar: unaNave desde: unaCasilla coordenada hacia: unaDireccion)
                ifTrue: [opciones add: { unaCasilla coordenada. unaDireccion }]]].
    ^opciones
]

{ #category : 'ubicacion' }
BNPartida >> ubicar: unaNave desde: unaCoordenada hacia: unaDireccion [
    "El jugador ubica una de sus naves. Cuando ubica la ultima, empieza la batalla."
    self enUbicacion ifFalse: [
        ^BNOperacionInvalida signal: 'Ya no se pueden ubicar naves'].
    unaNave isNil ifTrue: [
        ^BNOperacionInvalida signal: 'Elegi una nave para ubicar'].
    (jugador navesSinUbicar anySatisfy: [:otra | otra == unaNave]) ifFalse: [
        ^BNOperacionInvalida signal: 'Esa nave ya esta ubicada'].
    jugador tablero ubicar: unaNave desde: unaCoordenada hacia: unaDireccion.
    unaNave estaHerida ifTrue: [
        self anotar: '¡Mina! Tu ', unaNave nombre, ' cayo sobre una mina y perdio 1 vida.'].
    jugador navesSinUbicar isEmpty ifTrue: [self comenzarBatalla]
]

{ #category : 'ubicacion' }
BNPartida >> ubicarAlAzar: unaNave de: unJugador [
    "Ubica la nave en un lugar valido elegido al azar."
    | opciones eleccion |
    opciones := self ubicacionesPosiblesDe: unaNave en: unJugador tablero.
    opciones isEmpty ifTrue: [
        ^BNOperacionInvalida signal: 'No hay lugar para ubicar ', unaNave nombre].
    eleccion := self elegirUnaDe: opciones.
    unJugador tablero ubicar: unaNave desde: eleccion first hacia: eleccion last
]

{ #category : 'ubicacion' }
BNPartida >> ubicarAlAzarFlotaDe: unJugador [
    "Ubica al azar todas las naves que le faltan al jugador."
    unJugador navesSinUbicar do: [:unaNave | self ubicarAlAzar: unaNave de: unJugador]
]

{ #category : 'ubicacion' }
BNPartida >> ubicarFlotaDelJugadorAlAzar [
    "Ubica al azar las naves que le faltan al jugador y empieza la batalla."
    self enUbicacion ifFalse: [
        ^BNOperacionInvalida signal: 'Ya no se pueden ubicar naves'].
    jugador navesSinUbicar do: [:unaNave |
        self ubicarAlAzar: unaNave de: jugador.
        unaNave estaHerida ifTrue: [
            self anotar: '¡Mina! Tu ', unaNave nombre, ' cayo sobre una mina y perdio 1 vida.']].
    self comenzarBatalla
]

{ #category : 'computadora' }
BNPartida >> usarEstrategia: unaEstrategia [
	"La computadora va a elegir sus disparos con esa estrategia (BNEstrategiaAleatoria = facil, BNEstrategiaCazadora = intermedio)."
	estrategia := unaEstrategia
]

{ #category : 'turnos' }
BNPartida >> validarTurnoDe: unJugador [
    self enBatalla ifFalse: [
        ^BNOperacionInvalida signal: 'La partida no esta en batalla'].
    turno == unJugador ifFalse: [
        ^BNOperacionInvalida signal: 'No es tu turno']
]

{ #category : 'turnos' }
BNPartida >> verificarFin [
    "Si alguna flota quedo destruida, termina la partida."
    jugador estaDerrotado ifTrue: [^self terminarConGanador: computadora].
    computadora estaDerrotado ifTrue: [^self terminarConGanador: jugador]
]
