"
Reproduzco la musica del juego en bucle, con el reproductor de Windows (winmm.dll, por FFI), porque Pharo 14 no trae un paquete de sonido. Las canciones son archivos MP3 de la carpeta imagenes/musica. El volumen va de 0 a 10. Si no estoy en Windows o falta el archivo, no suena nada y el juego sigue igual.
"
Class {
	#name : 'BNMusica',
	#superclass : 'Object',
	#instVars : [
		'carpeta',
		'sonando',
		'volumen'
	],
	#category : 'A-BatallaNaval-Interfaz',
	#package : 'A-BatallaNaval-Interfaz'
}

{ #category : 'instance creation' }
BNMusica class >> enCarpeta: unaCarpeta [

	^self new setCarpeta: unaCarpeta
]

{ #category : 'reproduccion' }
BNMusica >> aplicarVolumen [

	sonando ifNotNil: [self enviar: 'setaudio bnmusica volume to ' , (volumen * 100) printString]
]

{ #category : 'reproduccion' }
BNMusica >> bajarVolumen [

	self volumen: volumen - 1
]

{ #category : 'reproduccion' }
BNMusica >> detener [

	sonando isNil ifTrue: [^self].
	self enviar: 'close bnmusica'.
	sonando := nil
]

{ #category : 'windows' }
BNMusica >> enviar: unComando [

	"Manda un comando al reproductor de Windows. Devuelve 0 si salio bien; si no se puede (otro sistema operativo), devuelve -1."
	^[self mci: unComando] on: Error do: [:error | -1]
]

{ #category : 'windows' }
BNMusica >> mci: unComando [

	^self ffiCall: #(int mciSendStringA(String unComando, void* 0, int 0, void* 0)) module: 'winmm.dll'
]

{ #category : 'reproduccion' }
BNMusica >> reproducir: unNombre [

	"Hace sonar en bucle la cancion unNombre.mp3. Con nil, silencio. Si ya esta sonando, la deja seguir."
	| archivo |
	sonando = unNombre ifTrue: [^self].
	self detener.
	unNombre isNil ifTrue: [^self].
	archivo := carpeta / (unNombre , '.mp3').
	archivo exists ifFalse: [^self].
	(self enviar: 'open "' , archivo fullName , '" type mpegvideo alias bnmusica') = 0 ifFalse: [^self].
	sonando := unNombre.
	self aplicarVolumen.
	self enviar: 'play bnmusica repeat'
]

{ #category : 'initialization' }
BNMusica >> setCarpeta: unaCarpeta [

	carpeta := unaCarpeta.
	volumen := 6
]

{ #category : 'accessing' }
BNMusica >> sonando [

	"El nombre de la cancion que suena, o nil."
	^sonando
]

{ #category : 'reproduccion' }
BNMusica >> subirVolumen [

	self volumen: volumen + 1
]

{ #category : 'accessing' }
BNMusica >> volumen [

	^volumen
]

{ #category : 'reproduccion' }
BNMusica >> volumen: unNumero [

	volumen := (unNumero max: 0) min: 10.
	self aplicarVolumen
]
