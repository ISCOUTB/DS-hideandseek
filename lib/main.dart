import 'dart:async';
import 'dart:math';
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
  Timer? seekerTimer;
  Timer? countdownTimer;
  int countdown = 30;
  bool gameEnded = false;

  // Modifica startSeeker para iniciar el temporizador y la búsqueda autónoma
  void startSeeker() {
    setState(() {
      seekerActive = true;
      gameEnded = false;
      countdown = 30;
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

  // Algoritmo de movimiento autónomo (aleatorio con preferencia hacia el hider)
  void moveSeekerAuto() {
    if (!seekerActive || gameEnded) return;

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

    List<List<int>> directions = [
      [-1, 0], // arriba
      [1, 0], // abajo
      [0, -1], // izquierda
      [0, 1], // derecha
    ];

    // Ordena las direcciones por cercanía al hider
    directions.sort((a, b) {
      int distA =
          (playerRow - (seekerRow + a[0])).abs() +
          (playerCol - (seekerCol + a[1])).abs();
      int distB =
          (playerRow - (seekerRow + b[0])).abs() +
          (playerCol - (seekerCol + b[1])).abs();
      return distA.compareTo(distB);
    });

    bool moved = false;
    for (var dir in directions) {
      int newRow = seekerRow + dir[0];
      int newCol = seekerCol + dir[1];
      if (newRow >= 0 &&
          newRow < maze.length &&
          newCol >= 0 &&
          newCol < maze[0].length &&
          maze[newRow][newCol] == 0) {
        setState(() {
          seekerRow = newRow;
          seekerCol = newCol;
        });
        moved = true;
        break;
      }
    }

    // Si no puede moverse hacia el hider, intenta moverse aleatoriamente
    if (!moved) {
      var rng = Random();
      directions.shuffle(rng);
      for (var dir in directions) {
        int newRow = seekerRow + dir[0];
        int newCol = seekerCol + dir[1];
        if (newRow >= 0 &&
            newRow < maze.length &&
            newCol >= 0 &&
            newCol < maze[0].length &&
            maze[newRow][newCol] == 0) {
          setState(() {
            seekerRow = newRow;
            seekerCol = newCol;
          });
          break;
        }
      }
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
}
