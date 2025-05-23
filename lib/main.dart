import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      body: Stack(
        children: [
          const CloudBackground(),
          Center(
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
                MenuButton(
                  "Iniciar",
                  onPressed: () {
                    Navigator.of(context).push(_createRoute());
                  },
                ),
                MenuButton(
                  "Opciones",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OptionsScreen(),
                      ),
                    );
                  },
                ),
                MenuButton(
                  "Créditos",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreditsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Transición entre Pantallas ---------------- //
PageRouteBuilder _createRoute() {
  return PageRouteBuilder(
    pageBuilder:
        (context, animation, secondaryAnimation) => const MazeGameScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

// ---------------- Fondo con Nubes ---------------- //
class CloudBackground extends StatefulWidget {
  const CloudBackground({super.key});

  @override
  _CloudBackgroundState createState() => _CloudBackgroundState();
}

class _CloudBackgroundState extends State<CloudBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Cloud> clouds = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateClouds();
    });
  }

  void _generateClouds() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      clouds = List.generate(8, (index) {
        return Cloud(
          left: Random().nextDouble() * screenWidth,
          top: Random().nextDouble() * screenHeight,
          speed: Random().nextDouble() * 2 + 1,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var cloud in clouds) {
          cloud.left += cloud.speed;
          if (cloud.left > MediaQuery.of(context).size.width) {
            cloud.left = -100;
          }
        }
        return Container(
          color: const Color.fromARGB(255, 100, 202, 246),
          child: Stack(
            children:
                clouds.map((cloud) {
                  return Positioned(
                    left: cloud.left,
                    top: cloud.top,
                    child: Image.asset(
                      "assets/imagen/cloud.png",
                      width: 120,
                      height: 80,
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Cloud {
  double left;
  double top;
  double speed;

  Cloud({required this.left, required this.top, required this.speed});
}

// ---------------- Botones del Menú ---------------- //
class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton(this.text, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

// ---------------- Pantalla de Opciones ---------------- //
class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  double volume = 50;
  String selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CloudBackground(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Opciones",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Volumen",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Slider(
                    value: volume,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: volume.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        volume = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Idioma",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  DropdownButton<String>(
                    value: selectedLanguage,
                    dropdownColor: Colors.blue[100],
                    iconEnabledColor: Colors.white,
                    items:
                        <String>['Español', 'Inglés']
                            .map(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLanguage = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  MenuButton(
                    "Atrás",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Versión: 1.2.01",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Pantalla de Créditos ---------------- //
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CloudBackground(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Créditos",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Desarrolladores:",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 5),
                const Text(
                  "• Eddy Lara",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const Text(
                  "• David Pelaez",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const Text(
                  "• Jose Pereira",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const Text(
                  "• Juan caicedo",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Agradecimientos a: copilot",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                MenuButton(
                  "Atrás",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
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
  int seekerCol = 1;

  bool seekerActive = false;
  Timer? seekerTimer;
  Timer? countdownTimer;
  int countdown = 30; // duración inicial
  bool gameEnded = false;

  // Variables para exploración
  Set<String> seekerVisited = {};
  List<List<int>> seekerPath = [];
  int seekerTargetRow = 1;
  int seekerTargetCol = 1;

  // Nueva variable para la zona segura del seeker
  Set<String> seekerSafeZone = {};

  // Modifica startSeeker para iniciar el temporizador y la búsqueda autónoma
  void startSeeker() {
    setState(() {
      seekerActive = true;
      gameEnded = false;
      countdown = 30; // reinicia a 30 segundos
      seekerVisited.clear();
      seekerPath.clear();
      seekerTargetRow = seekerRow;
      seekerTargetCol = seekerCol;
    });
    seekerTimer?.cancel();
    countdownTimer?.cancel();
    seekerTimer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => moveSeekerAuto(),
    );
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!seekerActive) return;
      setState(() {
        countdown--;
      });
      if (countdown <= 0) {
        seekerActive = false;
        seekerTimer?.cancel();
        countdownTimer?.cancel();
        if (!gameEnded) {
          gameEnded = true;
          showVictoryDialog();
        }
      }
    });
  }

  // Nueva función para encontrar la siguiente celda no visitada más cercana
  List<int>? findNextUnvisitedCell() {
    Queue<List<int>> queue = Queue();
    Set<String> localVisited = {};
    queue.add([seekerRow, seekerCol]);
    localVisited.add('$seekerRow,$seekerCol');
    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      int row = current[0];
      int col = current[1];
      if (maze[row][col] == 0 &&
          !seekerVisited.contains('$row,$col') &&
          !seekerSafeZone.contains('$row,$col')) {
        return [row, col];
      }
      for (var dir in [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
      ]) {
        int nRow = row + dir[0];
        int nCol = col + dir[1];
        if (nRow >= 0 &&
            nRow < maze.length &&
            nCol >= 0 &&
            nCol < maze[0].length &&
            maze[nRow][nCol] == 0 &&
            !localVisited.contains('$nRow,$nCol')) {
          queue.add([nRow, nCol]);
          localVisited.add('$nRow,$nCol');
        }
      }
    }
    return null;
  }

  List<int>? findNextUnvisitedCellAvoidingVisited() {
    Queue<List<int>> queue = Queue();
    Set<String> localVisited = {};
    queue.add([seekerRow, seekerCol]);
    localVisited.add('$seekerRow,$seekerCol');
    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      int row = current[0];
      int col = current[1];
      if (maze[row][col] == 0 && !seekerVisited.contains('$row,$col')) {
        return [row, col];
      }
      for (var dir in [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
      ]) {
        int nRow = row + dir[0];
        int nCol = col + dir[1];
        if (nRow >= 0 &&
            nRow < maze.length &&
            nCol >= 0 &&
            nCol < maze[0].length &&
            maze[nRow][nCol] == 0 &&
            !localVisited.contains('$nRow,$nCol') &&
            !seekerVisited.contains('$nRow,$nCol')) {
          queue.add([nRow, nCol]);
          localVisited.add('$nRow,$nCol');
        }
      }
    }
    return null;
  }

  // Algoritmo de movimiento autónomo (aleatorio con preferencia hacia el hider)
  void moveSeekerAuto() {
    if (!seekerActive || gameEnded) return;

    // Si el seeker encuentra al hider
    if (seekerRow == playerRow && seekerCol == playerCol) {
      seekerActive = false;
      seekerTimer?.cancel();
      countdownTimer?.cancel();
      if (!gameEnded) {
        gameEnded = true;
        showDefeatDialog();
      }
      return;
    }

    // Si el hider está a 4 bloques o menos (distancia Manhattan)
    int dist = (seekerRow - playerRow).abs() + (seekerCol - playerCol).abs();
    if (dist <= 4) {
      final path = findPathAStar(seekerRow, seekerCol, playerRow, playerCol);
      if (path.isNotEmpty) {
        final nextStep = path.first;
        setState(() {
          seekerRow = nextStep[0];
          seekerCol = nextStep[1];
          seekerVisited.add('$seekerRow,$seekerCol');
          marcarZonaSegura(seekerRow, seekerCol);
        });
        return;
      }
    }

    // Marca la celda actual como visitada y zona segura
    seekerVisited.add('$seekerRow,$seekerCol');
    marcarZonaSegura(seekerRow, seekerCol);

    // Busca la siguiente celda no visitada más cercana (permitiendo retroceder y evitando zona segura)
    List<int>? next = findNextUnvisitedCellAllowingBacktrack();
    if (next == null) {
      // Ya visitó todo y no encontró al hider
      seekerActive = false;
      seekerTimer?.cancel();
      countdownTimer?.cancel();
      if (!gameEnded) {
        gameEnded = true;
        showVictoryDialog();
      }
      return;
    }

    // Calcula el camino (puede pasar por visitadas si es necesario para salir)
    final path = findPathAStar(seekerRow, seekerCol, next[0], next[1]);
    if (path.isNotEmpty) {
      final nextStep = path.first;
      setState(() {
        seekerRow = nextStep[0];
        seekerCol = nextStep[1];
        seekerVisited.add('$seekerRow,$seekerCol');
        marcarZonaSegura(seekerRow, seekerCol);
      });
    }
  }

  // Muestra modal de victoria
  void showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('¡Victoria!'),
            content: const Text('¡El seeker no te encontró en 30 segundos!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Volver al menú principal
                },
                child: const Text('Volver al menú'),
              ),
            ],
          ),
    );
  }

  // Muestra modal de derrota
  void showDefeatDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('¡Derrota!'),
            content: const Text('¡El seeker te ha encontrado!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Volver al menú principal
                },
                child: const Text('Volver al menú'),
              ),
            ],
          ),
    );
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
    seekerTimer?.cancel();
    countdownTimer?.cancel();
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
              child: SingleChildScrollView(
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
                    SizedBox(
                      width: maxWidth < 900 ? maxWidth : 900,
                      height: maxHeight < 600 ? maxHeight : 600,
                      child: Stack(
                        children: [
                          // Dibuja las celdas
                          for (int r = 0; r < maze.length; r++)
                            for (int c = 0; c < maze[r].length; c++)
                              Positioned(
                                left: c * tileSize,
                                top: r * tileSize,
                                child: Container(
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
                    const SizedBox(height: 16),
                    // Muestra el temporizador
                    Text(
                      'Tiempo restante: $countdown s',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<List<int>> findPathAStar(
    int startRow,
    int startCol,
    int goalRow,
    int goalCol,
  ) {
    final openSet = <List<int>>[
      [startRow, startCol],
    ];
    final cameFrom = <String, List<int>>{};
    final gScore = <String, int>{};
    final fScore = <String, int>{};

    String key(int row, int col) => "$row,$col";

    gScore[key(startRow, startCol)] = 0;
    fScore[key(startRow, startCol)] =
        (goalRow - startRow).abs() + (goalCol - startCol).abs();

    while (openSet.isNotEmpty) {
      // Encuentra el nodo con menor fScore
      openSet.sort(
        (a, b) => fScore[key(a[0], a[1])]!.compareTo(fScore[key(b[0], b[1])]!),
      );
      final current = openSet.removeAt(0);
      final row = current[0];
      final col = current[1];

      if (row == goalRow && col == goalCol) {
        // Reconstruir el camino
        final path = <List<int>>[];
        var curr = current;
        while (cameFrom.containsKey(key(curr[0], curr[1]))) {
          path.insert(0, curr);
          curr = cameFrom[key(curr[0], curr[1])]!;
        }
        return path;
      }

      final neighbors = [
        [row - 1, col], // arriba
        [row + 1, col], // abajo
        [row, col - 1], // izquierda
        [row, col + 1], // derecha
      ];

      for (final neighbor in neighbors) {
        final nRow = neighbor[0];
        final nCol = neighbor[1];

        if (nRow < 0 ||
            nRow >= maze.length ||
            nCol < 0 ||
            nCol >= maze[0].length) {
          continue;
        }
        if (maze[nRow][nCol] == 1) continue; // pared

        final tentativeG = gScore[key(row, col)]! + 1;

        if (tentativeG < (gScore[key(nRow, nCol)] ?? double.infinity)) {
          cameFrom[key(nRow, nCol)] = [row, col];
          gScore[key(nRow, nCol)] = tentativeG;
          fScore[key(nRow, nCol)] =
              tentativeG + (goalRow - nRow).abs() + (goalCol - nCol).abs();

          if (!openSet.any((n) => n[0] == nRow && n[1] == nCol)) {
            openSet.add([nRow, nCol]);
          }
        }
      }
    }

    return []; // No se encontró camino
  }

  List<List<int>> findPathAStarAvoidingVisited(
    int startRow,
    int startCol,
    int goalRow,
    int goalCol,
  ) {
    final openSet = <List<int>>[
      [startRow, startCol],
    ];
    final cameFrom = <String, List<int>>{};
    final gScore = <String, int>{};
    final fScore = <String, int>{};

    String key(int row, int col) => "$row,$col";

    gScore[key(startRow, startCol)] = 0;
    fScore[key(startRow, startCol)] =
        (goalRow - startRow).abs() + (goalCol - startCol).abs();

    while (openSet.isNotEmpty) {
      openSet.sort(
        (a, b) => fScore[key(a[0], a[1])]!.compareTo(fScore[key(b[0], b[1])]!),
      );
      final current = openSet.removeAt(0);
      final row = current[0];
      final col = current[1];

      if (row == goalRow && col == goalCol) {
        final path = <List<int>>[];
        var curr = current;
        while (cameFrom.containsKey(key(curr[0], curr[1]))) {
          path.insert(0, curr);
          curr = cameFrom[key(curr[0], curr[1])]!;
        }
        return path;
      }

      final neighbors = [
        [row - 1, col],
        [row + 1, col],
        [row, col - 1],
        [row, col + 1],
      ];

      for (final neighbor in neighbors) {
        final nRow = neighbor[0];
        final nCol = neighbor[1];

        if (nRow < 0 ||
            nRow >= maze.length ||
            nCol < 0 ||
            nCol >= maze[0].length)
          continue;
        if (maze[nRow][nCol] == 1) continue; // pared
        if (seekerVisited.contains('$nRow,$nCol')) continue; // evita visitados

        final tentativeG = gScore[key(row, col)]! + 1;

        if (tentativeG < (gScore[key(nRow, nCol)] ?? double.infinity)) {
          cameFrom[key(nRow, nCol)] = [row, col];
          gScore[key(nRow, nCol)] = tentativeG;
          fScore[key(nRow, nCol)] =
              tentativeG + (goalRow - nRow).abs() + (goalCol - nCol).abs();

          if (!openSet.any((n) => n[0] == nRow && n[1] == nCol)) {
            openSet.add([nRow, nCol]);
          }
        }
      }
    }

    return [];
  }

  List<int>? findNextUnvisitedCellAllowingBacktrack() {
    // BFS: busca la celda no visitada más cercana, aunque tenga que pasar por visitadas,
    // pero ignora las que están en la zona segura
    Queue<List<int>> queue = Queue();
    Set<String> localVisited = {};
    queue.add([seekerRow, seekerCol]);
    localVisited.add('$seekerRow,$seekerCol');
    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      int row = current[0];
      int col = current[1];
      if (maze[row][col] == 0 &&
          !seekerVisited.contains('$row,$col') &&
          !seekerSafeZone.contains('$row,$col')) {
        return [row, col];
      }
      for (var dir in [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
      ]) {
        int nRow = row + dir[0];
        int nCol = col + dir[1];
        if (nRow >= 0 &&
            nRow < maze.length &&
            nCol >= 0 &&
            nCol < maze[0].length &&
            maze[nRow][nCol] == 0 &&
            !localVisited.contains('$nRow,$nCol')) {
          queue.add([nRow, nCol]);
          localVisited.add('$nRow,$nCol');
        }
      }
    }
    return null;
  }

  void marcarZonaSegura(int row, int col) {
    for (int dr = -4; dr <= 4; dr++) {
      for (int dc = -4; dc <= 4; dc++) {
        if ((dr.abs() + dc.abs()) <= 4) {
          int nr = row + dr;
          int nc = col + dc;
          if (nr >= 0 &&
              nr < maze.length &&
              nc >= 0 &&
              nc < maze[0].length &&
              maze[nr][nc] == 0) {
            seekerSafeZone.add('$nr,$nc');
          }
        }
      }
    }
  }
}
