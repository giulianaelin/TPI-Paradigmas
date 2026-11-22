# Batalla Naval

Trabajo Práctico Integrador — Paradigmas de Programación
UTN — Facultad Regional Resistencia

Juego de Batalla Naval para una persona contra la computadora, desarrollado en **Smalltalk (Pharo 14)** con Programación Orientada a Objetos. Tiene interfaz gráfica en pixel art, una nutria pirata que va contando lo que pasa y el modelo del juego separado de la interfaz.

## Requisitos

- **Pharo 14** (imagen de 64 bits, por ejemplo desde Pharo Launcher).
- **No hace falta internet**: todo el código y las imágenes están en esta carpeta.
- Windows para escuchar la música (en otros sistemas el juego funciona igual, sin sonido).

## Cómo ejecutarlo

La carpeta del proyecto tiene:

```
src/                      código en formato Tonel (3 paquetes)
  A-BatallaNaval-Modelo/      el juego (reglas, tableros, naves, partida)
  A-BatallaNaval-Tests/       pruebas SUnit
  A-BatallaNaval-Interfaz/    interfaz gráfica
imagenes/                 imágenes, tipografía y música que usa la interfaz
```

### Opción A: cargar desde la carpeta (recomendada, sin Iceberg)

1. Abrir una imagen limpia de Pharo 14.
2. Abrir un Playground (`Browse > Playground`) y ejecutar con **Do it** (Ctrl+D), cambiando `RUTA` por la carpeta donde se descomprimió el proyecto:

```smalltalk
| carpeta |
carpeta := 'RUTA\TPI-Paradigmas' asFileReference.
#('A-BatallaNaval-Modelo' 'A-BatallaNaval-Tests' 'A-BatallaNaval-Interfaz') do: [:unPaquete |
	[(TonelReader on: carpeta / 'src' fileName: unPaquete) version load]
		on: MCMergeOrLoadWarning do: [:w | w resume: true]].
(Smalltalk at: #BNRecursos) usarCarpeta: (carpeta / 'imagenes') fullName.
(Smalltalk at: #BNJuegoMorph) abrir.
```

### Opción B: con Iceberg

1. En Pharo, abrir Iceberg (`Browse > Git Repositories browser`).
2. `Add` > `Import from existing clone` y elegir la carpeta del proyecto.
3. Cargar los paquetes `A-BatallaNaval-Modelo`, `A-BatallaNaval-Tests` y `A-BatallaNaval-Interfaz` (clic derecho > `Load`).
4. En un Playground: `BNJuegoMorph abrir.` (las imágenes se encuentran solas, junto al repositorio).

Para volver a abrir el juego en cualquier momento: `BNJuegoMorph abrir.`
El juego mide 1280x720; si la ventana de Pharo es más chica, se achica solo para entrar.

## Cómo se juega

1. **Menú**: Nueva partida, Cargar partida (si hay una guardada), Opciones (dificultad y volumen de la música) y Salir.
2. **Ubicación**: al empezar se ven tus 4 minas durante unos segundos y después se esconden: hay que recordarlas. Elegí una nave de la lista, pasá el mouse por tu mar (sombra blanca = entra, roja = no entra) y hacé clic. **R** o el botón **Girar** cambia entre horizontal y vertical. También está **Ubicar al azar**.
3. **Batalla**: elegí una nave tuya (en la lista o en tu mar) y hacé clic en el mar enemigo para disparar con su arma. Al pasar el mouse se ve dónde pegaría.
   - Si el disparo daña una nave enemiga, volvés a disparar.
   - Cada disparo tiene una probabilidad de acierto según la nave; si falla, se desvía a una casilla vecina.
   - Disparar a una mina enemiga le cuesta 1 vida a la nave que disparó.
   - Con las **flechas** (botones o teclado) se mueve la nave elegida una casilla (gasta el turno; una nave herida no se mueve).
   - **Guardar** guarda la partida para seguirla desde el menú.
4. Gana quien hunde toda la flota enemiga.

### Flota (11 naves por jugador)

| Nave | Casillas | Arma | Acierto |
|---|---|---|---|
| Portaaviones (x2) | 5 | Bombardeo aéreo: 2 casillas a elección | 75 % |
| Acorazado (x2) | 4 | Cañón | 95 % |
| Crucero (x2) | 3 | Torpedo: 3 casillas en línea (Apuntar elige la dirección) | 70 % |
| Submarino (x2) | 3 | Cañón + ataque sigiloso | 80 % |
| Destructor (x2) | 2 | Ataque rápido: 2 tiros seguidos | 85 % |
| Barreminas (x1) | 2 | Cañón + Sonar | 80 % |

- **Recarga**: el torpedo y el bombardeo necesitan 2 turnos para volver a usarse, el ataque rápido 1 y el sonar 3. Mientras tanto la nave dispara con un cañón común (el panel muestra un relojito).
- **Submarino (ataque sigiloso)**: mientras está sumergido, si el enemigo le pega cree que fue agua. Cuando ataca sale a la superficie y sus impactos se ven hasta su próximo turno; si ya atacó y está herido, se ven para siempre.
- **Barreminas (característica propia)**: es inmune a las minas. Su **Sonar** (botón Sonar y clic en el mar enemigo) explora una zona de 3x3 sin probabilidad: marca las minas que encuentra y dice cuántas casillas con naves hay (también detecta submarinos sumergidos).
- **Dificultad**: Fácil (la computadora dispara al azar) o Intermedio (cuando acierta, sigue tirando alrededor hasta hundir).

## Pruebas

Las pruebas SUnit están en el paquete `A-BatallaNaval-Tests` (108 pruebas). Se corren desde el **Test Runner** (`Browse > Test Runner`, filtrar por `A-BatallaNaval`) o desde un Playground con **Print it** (Ctrl+P):

```smalltalk
(TestSuite named: 'Batalla Naval') in: [:suite |
	(Smalltalk globals allClasses select: [:c | (c category beginsWith: 'A-BatallaNaval-Tests') and: [c isTestCase]])
		do: [:c | suite addTests: c buildSuite tests].
	suite run]
```

## Organización del código

- **`A-BatallaNaval-Modelo`** (no sabe nada de la interfaz):
  - `BNPartida`: fases, turnos, disparos (probabilidad, desvío, minas, disparo extra), movimiento, sonar y ganador. Lleva un registro de lo que pasa.
  - `BNJugador`, `BNFlota`, `BNTablero`, `BNCasilla`, `BNCoordenada`, `BNConfiguracionTerreno`, `BNGeneradorTerreno`.
  - `BNNave` (abstracta) y sus subclases `BNPortaaviones`, `BNAcorazado`, `BNCrucero`, `BNSubmarino`, `BNDestructor`, `BNBarreminas`.
  - `BNArma` (abstracta) y `BNCanon`, `BNTorpedo`, `BNBombardeo`, `BNAtaqueRapido`; `BNSonar`.
  - `BNEstrategiaAleatoria` y `BNEstrategiaCazadora` (dificultad de la computadora).
  - `BNArchivoDePartida`: guarda y carga la partida con Fuel.
  - `BNError` y sus subclases, con mensajes en español.
- **`A-BatallaNaval-Interfaz`**: `BNJuegoMorph` (la ventana) y las pantallas `BNPantallaMenu`, `BNPantallaOpciones`, `BNPantallaUbicacion`, `BNPantallaBatalla`, `BNPantallaFin`; vistas de tablero, panel de flota, nutria, botones, tipografía pixel propia, recursos y música.
- **`A-BatallaNaval-Tests`**: pruebas SUnit de las clases centrales del modelo.

## Créditos

- Música del menú: "Pirate Music" de audiodollar (Pixabay, licencia de contenido de Pixabay). Ver `imagenes/musica/creditos.txt`.
- Imágenes: generadas con herramientas de IA (ChatGPT / Gemini) a partir de un diseño propio y después editadas y pasadas a pixel art. La tipografía pixel y los carteles de la interfaz se dibujan por código.
- Durante el desarrollo se usaron asistentes de IA como apoyo; ver el informe.
