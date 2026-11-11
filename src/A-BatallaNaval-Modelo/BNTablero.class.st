"
Administra las 144 casillas de un jugador. Es el unico que modifica las casillas: ofrece consultas y operaciones de islas, minas, ataques y ocupacion. Puede exportar su estado como datos serializables sin objetos graficos.
"
Class {
	#name : 'BNTablero',
	#superclass : 'Object',
	#instVars : [
		'casillas',
		'islas'
	],
	#category : 'A-BatallaNaval-Modelo',
	#package : 'A-BatallaNaval-Modelo'
}
