"
Posicion inmutable de un tablero de 12x12: fila 1..12 y columna A..L. Valida limites, se compara por valor, convierte desde texto y entrega sus vecinos.
"
Class {
	#name : 'BNCoordenada',
	#superclass : 'Object',
	#instVars : [
		'fila',
		'columna'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}

{ #category : 'as yet unclassified' }
BNCoordenada class >> desdeArray: unArray [
    "Crea una coordenada a partir de dos numeros: fila y columna."
    ^self fila: unArray first columna: unArray last
]

{ #category : 'as yet unclassified' }
BNCoordenada class >> desdeTexto: unTexto [
    "Convierte un texto como C8 o L12 en una coordenada."
    | texto columna fila |

    texto := unTexto asString trimBoth asUppercase.

    texto size < 2 ifTrue: [
        ^self errorPorTexto: unTexto
    ].

    (texto allButFirst allSatisfy: [:caracter | caracter isDigit])
        ifFalse: [
            ^self errorPorTexto: unTexto
        ].

    columna := texto first asciiValue - $A asciiValue + 1.
    fila := texto allButFirst asInteger.

    ^(self esValidaFila: fila columna: columna)
        ifTrue: [self fila: fila columna: columna]
        ifFalse: [self errorPorTexto: unTexto]
]

{ #category : 'configuracion' }
BNCoordenada class >> dimension [
	"Cantidad de filas y de columnas del tablero."
	^12
]

{ #category : 'as yet unclassified' }
BNCoordenada class >> errorPorTexto: unTexto [
    "Muestra un error cuando una coordenada esta mal escrita."
    ^BNCoordenadaInvalida signal:
        'Texto de coordenada invalido: ', unTexto printString
]

{ #category : 'as yet unclassified' }
BNCoordenada class >> esValidaFila: unaFila columna: unaColumna [
"Comprueba si una posicion esta dentro del tablero"
    ^(unaFila isInteger and: [unaColumna isInteger])
        and: [(unaFila between: 1 and: self dimension)
            and: [unaColumna between: 1 and: self dimension]]
]

{ #category : 'as yet unclassified' }
BNCoordenada class >> fila: unaFila columna: unaColumna [
    "Crea una coordenada si esta dentro del tablero."
    (self esValidaFila: unaFila columna: unaColumna)
        ifFalse: [
            ^BNCoordenadaInvalida signal: 'La coordenada se encuentra fuera del tablero'
        ].
    ^self new setFila: unaFila columna: unaColumna
]

{ #category : 'as yet unclassified' }
BNCoordenada class >> letraDeColumna: unNumeroDeColumna [
    "Convierte un numero de columna en su letra"
    ^Character value: ($A asciiValue + unNumeroDeColumna - 1)
]

{ #category : 'as yet unclassified' }
BNCoordenada class >> letrasDeColumnas [
    "Devuelve las ltras desde A hasta L"
    ^(1 to: self dimension) collect: [ :i |
        self letraDeColumna: i ]
]

{ #category : 'as yet unclassified' }
BNCoordenada class >> todas [
    "Crea una lista con las 144 coordenadas del tablero."
    | coordenadas |

    coordenadas := OrderedCollection new.

    1 to: self dimension do: [:fila |
        1 to: self dimension do: [:columna |
            coordenadas add: (self fila: fila columna: columna)
        ]
    ].

    ^coordenadas
]

{ #category : 'comparing' }
BNCoordenada >> = otraCoordenada [
    "Comprueba si dos coordenadas tienen la misma fila y columna."
    ^(self class == otraCoordenada class)
        and: [fila = otraCoordenada fila
            and: [columna = otraCoordenada columna]]
]

{ #category : 'converting' }
BNCoordenada >> asArray [
    "Devuelve la coordenada como una lista de dos numeros."
    ^{fila. columna}
]

{ #category : 'accessing' }
BNCoordenada >> columna [
    "Devuelve el numero de columna."
    ^columna
]

{ #category : 'as yet unclassified' }
BNCoordenada >> etiqueta [
    "Convierte una coordenada en texto, por ejemplo C8."
    ^(String with: self letraDeColumna) , fila printString
]

{ #category : 'accessing' }
BNCoordenada >> fila [
    "Devuelve el numero de fila de la coordenada."
    ^fila
]

{ #category : 'comparing' }
BNCoordenada >> hash [
    "Calcula un numero que identifica la coordenada."
    ^(self fila * 31) + self columna
]

{ #category : 'as yet unclassified' }
BNCoordenada >> letraDeColumna [
    "Devuelve la letra correspondiente a esta columna."
    ^self class letraDeColumna: columna
]

{ #category : 'printing' }
BNCoordenada >> printOn: unStream [
    "Muestra una coordenada de forma clara."
    unStream
        nextPutAll: 'BNCoordenada(';
        nextPutAll: self etiqueta;
        nextPut: $)
]

{ #category : 'initialization' }
BNCoordenada >> setFila: unaFila columna: unaColumna [
    "Guarda la fila y columna de una coordenada."
    fila := unaFila.
    columna := unaColumna.
    ^self
]

{ #category : 'as yet unclassified' }
BNCoordenada >> vecinosConDesplazamientos: unosDesplazamientos [
    "Busca las casillas vecinas sin salirse del tablero."
    | vecinos |

    vecinos := OrderedCollection new.

    unosDesplazamientos do: [:desplazamiento |
        | nuevaFila nuevaColumna |

        nuevaFila := fila + desplazamiento first.
        nuevaColumna := columna + desplazamiento last.

        (self class esValidaFila: nuevaFila columna: nuevaColumna)
            ifTrue: [
                vecinos add: (self class fila: nuevaFila columna: nuevaColumna)
            ]
    ].

    ^vecinos
]

{ #category : 'as yet unclassified' }
BNCoordenada >> vecinosConDiagonales [
    "Devuelve las ocho casillas que rodean una posicion.Este método incluye las diagonales. Nos sirve, por ejemplo, para comprobar que las islas estén separadas."
    ^self vecinosConDesplazamientos:
        #((-1 -1) (-1 0) (-1 1)
          (0 -1) (0 1)
          (1 -1) (1 0) (1 1))
]

{ #category : 'as yet unclassified' }
BNCoordenada >> vecinosOrtogonales [
    "Devuelve las casillas de arriba, abajo, izquierda y derecha."
    ^self vecinosConDesplazamientos:
        #((-1 0) (1 0) (0 -1) (0 1))
]
