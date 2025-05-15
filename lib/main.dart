import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // para LogicalKeyboardKey

// =============================================================================
// main() y App scaffold
// =============================================================================
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hide And Seek',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 59, 87, 211),
        ),
      ),
      home: const MainMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// =============================================================================
// 1) MainMenu: pantalla inicial con opciones
// =============================================================================
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF64CAF6),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Hide and Seek",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _MenuButton(
                  "Iniciar",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MazeGameScreen()),
                    );
                  },
                ),
                _MenuButton("Opciones", onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _MenuButton(this.text, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

// =====================
// Pantalla del laberinto
// =====================
class MazeGameScreen extends StatefulWidget {
  const MazeGameScreen({super.key});

  @override
  State<MazeGameScreen> createState() => _MazeGameScreenState();
}

class _MazeGameScreenState extends State<MazeGameScreen> {
  // 1 = pared, 0 = vacío
  final List<List<int>> maze = [
    // 20 filas x 30 columnas
    [
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      1,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      1,
      1,
      1,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      1,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      1,
      1,
      1,
      1,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      0,
      1,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      0,
      1,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      1,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      1,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      0,
      0,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      1,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
    ],
    [
      1,
      0,
      1,
      0,
      0,
      0,
      1,
      0,
      1,
      1,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      1,
      0,
      0,
      0,
      1,
      0,
      1,
      1,
      0,
      1,
      0,
      0,
      1,
      1,
      1,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      1,
      1,
    ],
    [
      1,
      0,
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      1,
      1,
      1,
      1,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
    ],
    [
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
    ],
  ];
  // Posición inicial del personaje (fila, columna)
  int playerRow = 1;
  int playerCol = 1;

  // Posición inicial del seeker (buscador)
  int seekerRow = 18;
  int seekerCol = 28;

  bool seekerActive = false;

  void startSeeker() {
    setState(() {
      seekerActive = true;
    });
    moveSeeker();
  }

  void moveSeeker() async {
    while (seekerActive && (seekerRow != playerRow || seekerCol != playerCol)) {
      await Future.delayed(const Duration(milliseconds: 250));
      int dRow = playerRow - seekerRow;
      int dCol = playerCol - seekerCol;
      int stepRow = dRow == 0 ? 0 : dRow ~/ dRow.abs();
      int stepCol = dCol == 0 ? 0 : dCol ~/ dCol.abs();

      // Prioridad: primero fila, luego columna
      int nextRow = seekerRow + (stepRow != 0 ? stepRow : 0);
      int nextCol = seekerCol + (stepRow == 0 && stepCol != 0 ? stepCol : 0);

      // Verifica si puede moverse a la siguiente celda
      if (maze[nextRow][nextCol] == 0) {
        setState(() {
          seekerRow = nextRow;
          seekerCol = nextCol;
        });
      } else if (stepRow != 0 && maze[seekerRow + stepRow][seekerCol] == 0) {
        setState(() {
          seekerRow += stepRow;
        });
      } else if (stepCol != 0 && maze[seekerRow][seekerCol + stepCol] == 0) {
        setState(() {
          seekerCol += stepCol;
        });
      } else {
        break; // No puede avanzar
      }
      // Si el seeker alcanza al jugador, termina
      if (seekerRow == playerRow && seekerCol == playerCol) {
        seekerActive = false;
        // Aquí puedes mostrar un mensaje de "¡Te encontró!"
      }
    }
  }

  void movePlayer(int dRow, int dCol) {
    final newRow = playerRow + dRow;
    final newCol = playerCol + dCol;
    if (newRow >= 0 &&
        newRow < maze.length &&
        newCol >= 0 &&
        newCol < maze[0].length &&
        maze[newRow][newCol] == 0) {
      setState(() {
        playerRow = newRow;
        playerCol = newCol;
      });
    }
  }

  // Soporte para teclado (desktop)
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF64CAF6),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calcula el tamaño máximo disponible
            final double maxWidth = constraints.maxWidth;
            final double maxHeight = constraints.maxHeight;

            // Calcula el tamaño de cada celda para que quepa el laberinto completo
            final double maxMazeWidth = maxWidth < 900 ? maxWidth : 900;
            final double maxMazeHeight = maxHeight < 600 ? maxHeight : 600;
            final double tileSizeWidth = maxMazeWidth / maze[0].length;
            final double tileSizeHeight = maxMazeHeight / maze.length;
            final double tileSize =
                tileSizeWidth < tileSizeHeight ? tileSizeWidth : tileSizeHeight;

            return RawKeyboardListener(
              focusNode: focusNode,
              autofocus: true,
              onKey: (event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    movePlayer(-1, 0);
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    movePlayer(1, 0);
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                    movePlayer(0, -1);
                  } else if (event.logicalKey ==
                      LogicalKeyboardKey.arrowRight) {
                    movePlayer(0, 1);
                  }
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón para volver al menú principal
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Menú principal"),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      // Laberinto con límite de tamaño máximo
                      SizedBox(
                        width: maxWidth < 900 ? maxWidth : 900,
                        height: maxHeight < 600 ? maxHeight : 600,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int r = 0; r < maze.length; r++)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int c = 0; c < maze[r].length; c++)
                                    Container(
                                      width: tileSize,
                                      height: tileSize,
                                      decoration: BoxDecoration(
                                        color:
                                            maze[r][c] == 1
                                                ? Colors.grey[800]
                                                : Colors.white,
                                        border: Border.all(
                                          color: Colors.grey[400]!,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      // Personaje Hider
                      Positioned(
                        left: playerCol * tileSize,
                        top: playerRow * tileSize,
                        child: SizedBox(
                          width: tileSize,
                          height: tileSize,
                          child: Image.asset(
                            'assets/characters/hider.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Personaje Seeker
                      Positioned(
                        left: seekerCol * tileSize,
                        top: seekerRow * tileSize,
                        child: SizedBox(
                          width: tileSize,
                          height: tileSize,
                          child: Image.asset(
                            'assets/characters/seeker.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Botón para iniciar al seeker
                  ElevatedButton.icon(
                    onPressed: seekerActive ? null : startSeeker,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("¡Estoy listo!"),
                  ),
                  const SizedBox(height: 16),
                  // Controles para móvil
                  Wrap(
                    spacing: 10,
                    children: [
                      ElevatedButton(
                        onPressed: () => movePlayer(-1, 0),
                        child: const Icon(Icons.arrow_upward),
                      ),
                      ElevatedButton(
                        onPressed: () => movePlayer(1, 0),
                        child: const Icon(Icons.arrow_downward),
                      ),
                      ElevatedButton(
                        onPressed: () => movePlayer(0, -1),
                        child: const Icon(Icons.arrow_back),
                      ),
                      ElevatedButton(
                        onPressed: () => movePlayer(0, 1),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
