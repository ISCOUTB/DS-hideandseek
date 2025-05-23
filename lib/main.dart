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
          seedColor: const Color.fromARGB(255, 75, 183, 219),
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

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  String selectedDifficulty = 'medio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF64CAF6),
      body: Stack(
        children: [
          const CloudBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hide and Seek",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: selectedDifficulty,
                  items: const [
                    DropdownMenuItem(value: 'facil', child: Text('Fácil')),
                    DropdownMenuItem(value: 'medio', child: Text('Medio')),
                    DropdownMenuItem(value: 'dificil', child: Text('Difícil')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDifficulty = value!;
                    });
                  },
                ),
                MenuButton(
                  "Iniciar",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const MazeGameScreen(), // Sin dificultad
                      ),
                    );
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

  // Nuevas variables para el tamaño anterior
  double _lastWidth = 0;
  double _lastHeight = 0;

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

  void _generateClouds([double? width, double? height]) {
    double screenWidth = width ?? MediaQuery.of(context).size.width;
    double screenHeight = height ?? MediaQuery.of(context).size.height;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Regenera las nubes si el tamaño cambia
        if (clouds.isEmpty ||
            constraints.maxWidth != _lastWidth ||
            constraints.maxHeight != _lastHeight) {
          _lastWidth = constraints.maxWidth;
          _lastHeight = constraints.maxHeight;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _generateClouds(constraints.maxWidth, constraints.maxHeight);
            }
          });
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            for (var cloud in clouds) {
              cloud.left += cloud.speed;
              if (cloud.left > constraints.maxWidth) {
                cloud.left = -100;
              }
            }
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Stack(
                children:
                    clouds.map((cloud) {
                      return Positioned(
                        left: cloud.left,
                        top: cloud.top,
                        child: Image.asset(
                          "assets/imagen/cloud.png",
                          width: 200,
                          height: 140,
                        ),
                      );
                    }).toList(),
              ),
            );
          },
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
      backgroundColor: const Color(0xFF64CAF6),
      body: Stack(
        children: [
          const CloudBackground(),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Opciones",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Volumen",
                      style: TextStyle(fontSize: 20, color: Colors.black87),
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
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                    DropdownButton<String>(
                      value: selectedLanguage,
                      dropdownColor: Colors.blue[100],
                      iconEnabledColor: Colors.black,
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
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
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
      backgroundColor: const Color(0xFF64CAF6),
      body: Stack(
        children: [
          const CloudBackground(),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Créditos",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Desarrolladores:",
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "• Eddy Lara",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const Text(
                      "• David Pelaez",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const Text(
                      "• Jose Pereira",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const Text(
                      "• Juan caicedo",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Agradecimientos a: copilot",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
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
  final String difficulty;
  const MazeGameScreen({super.key, this.difficulty = 'medio'});

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
  late int countdown;

  // Variables para exploración
  Set<String> seekerVisited = {};
  List<List<int>> seekerPath = [];
  int seekerTargetRow = 1;
  int seekerTargetCol = 1;

  // Nueva variable para la zona segura del seeker
  Set<String> seekerSafeZone = {};

  // Variable para el estado del juego
  bool gameEnded = false;

  // Nueva variable para la lógica del seeker
  late String seekerLogic; // 'astar', 'bfs', 'dfs'

  @override
  void initState() {
    super.initState();
    setCountdownByDifficulty();
  }

  void setCountdownByDifficulty() {
    switch (widget.difficulty) {
      case 'facil':
        countdown = 60;
        break;
      case 'dificil':
        countdown = 15;
        break;
      default:
        countdown = 30;
    }
  }

  // Modifica startSeeker para iniciar el temporizador y la búsqueda autónoma
  void startSeeker() {
    setState(() {
      setCountdownByDifficulty();
      seekerActive = true;
      gameEnded = false;
      seekerVisited.clear();
      seekerPath.clear();
      seekerTargetRow = seekerRow;
      seekerTargetCol = seekerCol;
      // Elegir lógica aleatoria
      final logics = ['astar', 'bfs', 'dfs'];
      seekerLogic = logics[Random().nextInt(logics.length)];
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
      for (var dir in <List<int>>[
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
      ]..shuffle()) {
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
      for (var dir in <List<int>>[
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
      ]..shuffle()) {
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
      List<List<int>> path;
      if (seekerLogic == 'astar') {
        path = findPathAStar(seekerRow, seekerCol, playerRow, playerCol);
      } else if (seekerLogic == 'bfs') {
        path = findPathBFS(seekerRow, seekerCol, playerRow, playerCol);
      } else {
        path = findPathDFS(seekerRow, seekerCol, playerRow, playerCol);
      }
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

    // Calcula el camino usando la lógica aleatoria
    List<List<int>> path;
    if (seekerLogic == 'astar') {
      path = findPathAStar(seekerRow, seekerCol, next[0], next[1]);
    } else if (seekerLogic == 'bfs') {
      path = findPathBFS(seekerRow, seekerCol, next[0], next[1]);
    } else {
      path = findPathDFS(seekerRow, seekerCol, next[0], next[1]);
    }
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
            content: const Text('¡El seeker no te encontró en el tiempo!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  resetGame(); // Reinicia el juego
                },
                child: const Text('Cerrar'),
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
                  Navigator.of(context).pop(); // Cierra el diálogo
                  resetGame(); // Reinicia el juego
                },
                child: const Text('Cerrar'),
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
      backgroundColor: const Color(0xFF64CAF6), // Azul cielo
      body: Stack(
        children: [
          const CloudBackground(),
          Center(
            child: RawKeyboardListener(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón Menú principal
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
                    // Selector de dificultad (arriba del mapa)
                    DropdownButton<String>(
                      value: widget.difficulty,
                      items: const [
                        DropdownMenuItem(value: 'facil', child: Text('Fácil')),
                        DropdownMenuItem(value: 'medio', child: Text('Medio')),
                        DropdownMenuItem(
                          value: 'dificil',
                          child: Text('Difícil'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      MazeGameScreen(difficulty: value),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    // Aquí va el Flexible con el mapa...
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Stack(
                        children: [
                          // Dibuja las celdas
                          for (int r = 0; r < maze.length; r++)
                            for (int c = 0; c < maze[r].length; c++)
                              Positioned(
                                left:
                                    c *
                                    (MediaQuery.of(context).size.width /
                                        maze[0].length),
                                top:
                                    r *
                                    (MediaQuery.of(context).size.height *
                                        0.5 /
                                        maze.length),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width /
                                      maze[0].length,
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.5 /
                                      maze.length,
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
                            left:
                                playerCol *
                                (MediaQuery.of(context).size.width /
                                    maze[0].length),
                            top:
                                playerRow *
                                (MediaQuery.of(context).size.height *
                                    0.5 /
                                    maze.length),
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width /
                                  maze[0].length,
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.5 /
                                  maze.length,
                              child: Image.asset(
                                'assets/characters/hider.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Personaje Seeker
                          Positioned(
                            left:
                                seekerCol *
                                (MediaQuery.of(context).size.width /
                                    maze[0].length),
                            top:
                                seekerRow *
                                (MediaQuery.of(context).size.height *
                                    0.5 /
                                    maze.length),
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width /
                                  maze[0].length,
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.5 /
                                  maze.length,
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
                    Text(
                      'Dificultad: ${widget.difficulty == 'facil'
                          ? 'Fácil'
                          : widget.difficulty == 'medio'
                          ? 'Medio'
                          : 'Difícil'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Card(
                        color: Colors.white.withOpacity(0.9),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Instrucciones",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "• Muévete con las flechas o los botones.\n"
                                "• El seeker te detecta si estás a 4 bloques o menos.\n"
                                "• ¡Evita ser atrapado antes de que acabe el tiempo!\n\n"
                                "Dificultad:\n"
                                "• Fácil: 60 segundos para encontrarte el seeker.\n"
                                "• Medio: 30 segundos para encontrarte el seeker.\n"
                                "• Difícil: 15 segundos para encontrarte el seeker.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      playerRow = 1;
      playerCol = 1;
      seekerRow = 18;
      seekerCol = 1;
      seekerActive = false;
      gameEnded = false;
      seekerVisited.clear();
      seekerPath.clear();
      seekerSafeZone.clear();
      setCountdownByDifficulty();
    });
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
      for (var dir in <List<int>>[
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
      ]..shuffle()) {
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

  List<List<int>> findPathBFS(
    int startRow,
    int startCol,
    int goalRow,
    int goalCol,
  ) {
    Queue<List<int>> queue = Queue();
    Map<String, List<int>> cameFrom = {};
    queue.add([startRow, startCol]);
    Set<String> visited = {'$startRow,$startCol'};

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      int row = current[0], col = current[1];
      if (row == goalRow && col == goalCol) {
        // Reconstruir el camino
        final path = <List<int>>[];
        var curr = current;
        while (cameFrom.containsKey('${curr[0]},${curr[1]}')) {
          path.insert(0, curr);
          curr = cameFrom['${curr[0]},${curr[1]}']!;
        }
        return path;
      }
      for (var dir in ([
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
      ]..shuffle())) {
        int nRow = row + dir[0], nCol = col + dir[1];
        if (nRow < 0 ||
            nRow >= maze.length ||
            nCol < 0 ||
            nCol >= maze[0].length)
          continue;
        if (maze[nRow][nCol] == 1) continue;
        if (visited.contains('$nRow,$nCol')) continue;
        queue.add([nRow, nCol]);
        visited.add('$nRow,$nCol');
        cameFrom['$nRow,$nCol'] = [row, col];
      }
    }
    return [];
  }

  List<List<int>> findPathDFS(
    int startRow,
    int startCol,
    int goalRow,
    int goalCol,
  ) {
    List<List<int>> stack = [];
    Map<String, List<int>> cameFrom = {};
    stack.add([startRow, startCol]);
    Set<String> visited = {'$startRow,$startCol'};

    while (stack.isNotEmpty) {
      var current = stack.removeLast();
      int row = current[0], col = current[1];
      if (row == goalRow && col == goalCol) {
        // Reconstruir el camino
        final path = <List<int>>[];
        var curr = current;
        while (cameFrom.containsKey('${curr[0]},${curr[1]}')) {
          path.insert(0, curr);
          curr = cameFrom['${curr[0]},${curr[1]}']!;
        }
        return path;
      }
      for (var dir in ([
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
      ]..shuffle())) {
        int nRow = row + dir[0], nCol = col + dir[1];
        if (nRow < 0 ||
            nRow >= maze.length ||
            nCol < 0 ||
            nCol >= maze[0].length)
          continue;
        if (maze[nRow][nCol] == 1) continue;
        if (visited.contains('$nRow,$nCol')) continue;
        stack.add([nRow, nCol]);
        visited.add('$nRow,$nCol');
        cameFrom['$nRow,$nCol'] = [row, col];
      }
    }
    return [];
  }
}
