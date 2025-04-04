import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainMenu(),
    );
  }
}

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Pantalla de Simulación ---------------- //
class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

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
                  "Simulación en Desarrollo",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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

// ---------------- Animación de Transición ---------------- //
PageRouteBuilder _createRoute() {
  return PageRouteBuilder(
    pageBuilder:
        (context, animation, secondaryAnimation) => const SimulationScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Desliza desde la derecha
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
class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

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
                  "Opciones",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                MenuButton("Volumen", onPressed: () {}),
                MenuButton("Idioma", onPressed: () {}),
                MenuButton(
                  "Atrás",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Versión: 1.0.0",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
