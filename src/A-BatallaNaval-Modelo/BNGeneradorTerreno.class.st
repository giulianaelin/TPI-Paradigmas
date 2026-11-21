Class {
	#name : 'BNGeneradorTerreno',
	#superclass : 'Object',
	#instVars : [
		'random'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'as yet unclassified' }
BNGeneradorTerreno class >> conRandom: unRandom [
    "Crea un generador que usa ese Random. En los tests se le pasa uno con semilla fija."
    ^self new setRandom: unRandom
]

{ #category : 'as yet unclassified' }
BNGeneradorTerreno >> elegirUnaDe: unaColeccion [
    "Elige un elemento al azar. Todo el azar del generador pasa por aca."
    ^unaColeccion atRandom: random
]

{ #category : 'as yet unclassified' }
BNGeneradorTerreno >> generarEn: unTablero segun: unaConfiguracion [
    "Ubica las islas y las minas que pide la configuracion. Primero las islas, porque las minas no pueden ir sobre ellas."
    unaConfiguracion tamanosDeIslas do: [:unTamano |
        self ubicarIslaDe: unTamano en: unTablero].
    unaConfiguracion cantidadDeMinas timesRepeat: [
        self ubicarMinaEn: unTablero].
    ^unTablero
]

{ #category : 'initialization' }
BNGeneradorTerreno >> initialize [
    "Por defecto usa un Random nuevo: cada partida sale distinta."
    super initialize.
    random := Random new
]

{ #category : 'initialization' }
BNGeneradorTerreno >> setRandom: unRandom [
    "Reemplaza el generador de azar (lo usa conRandom:)."
    random := unRandom
]

{ #category : 'as yet unclassified' }
BNGeneradorTerreno >> ubicacionesPosiblesDeIslaDe: unTamano en: unTablero [
    "Todas las lineas de ese tamaño, horizontales y verticales, donde el tablero acepta una isla."
    | opciones |
    opciones := OrderedCollection new.
    unTablero casillasLibres do: [:unaCasilla |
        { BNCoordenada horizontal. BNCoordenada vertical } do: [:unaDireccion |
            (unaCasilla coordenada cabeLineaDe: unTamano hacia: unaDireccion) ifTrue: [
                | linea |
                linea := unaCasilla coordenada lineaDe: unTamano hacia: unaDireccion.
                (unTablero puedeAgregarIslaEn: linea) ifTrue: [opciones add: linea]]]].
    ^opciones
]

{ #category : 'as yet unclassified' }
BNGeneradorTerreno >> ubicarIslaDe: unTamano en: unTablero [
    "Elige al azar uno de los lugares donde entra una isla de ese tamaño y la agrega al tablero."
    | opciones |
    opciones := self ubicacionesPosiblesDeIslaDe: unTamano en: unTablero.
    opciones isEmpty ifTrue: [
        ^BNConfiguracionInvalida signal: 'No hay lugar para una isla de ', unTamano printString, ' casillas'].
    unTablero agregarIslaEn: (self elegirUnaDe: opciones)
]

{ #category : 'as yet unclassified' }
BNGeneradorTerreno >> ubicarMinaEn: unTablero [
    "Arma una mina en una casilla libre elegida al azar."
    | libres |
    libres := unTablero casillasLibres.
    libres isEmpty ifTrue: [
        ^BNConfiguracionInvalida signal: 'No quedan casillas libres para otra mina'].
    unTablero armarMinaEn: (self elegirUnaDe: libres) coordenada
]
