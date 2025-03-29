import 'package:flutter/material.dart';
import 'dart:async';
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
      home: const MainMenu(), // Pantalla principal
    );
  }
}

// 📌 Widget del menú principal
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CloudBackground(), // Fondo animado con nubes
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
                  "Jugar",
                  onPressed: () {
                    // Acción cuando el botón "Jugar" es presionado
                  },
                ),
                MenuButton(
                  "Opciones",
                  onPressed: () {
                    // Navegar al menú de opciones cuando se presiona el botón
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OptionsScreen(),
                      ),
                    );
                  },
                ),
                MenuButton(
                  "Salir",
                  onPressed: () {
                    // Acción para salir o cerrar el juego
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

// 📌 Widget para el fondo con nubes animadas
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

    // Iniciar las nubes cuando el frame está construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateClouds();
    });

    // Redibujar cada vez que el controlador cambia
    _controller.addListener(() {
      setState(() {
        for (var cloud in clouds) {
          cloud.left += cloud.speed;
          if (cloud.left > MediaQuery.of(context).size.width) {
            cloud.left = -100; // Reiniciar la nube cuando salga de pantalla
          }
        }
      });
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
          speed: Random().nextDouble() * 2 + 1, // Velocidad entre 1 y 3
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 100, 202, 246), // Color azul cielo
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
  }
}

// 📌 Clase para manejar las nubes
class Cloud {
  double left;
  double top;
  double speed;

  Cloud({required this.left, required this.top, required this.speed});
}

// 📌 Widget para los botones del menú con sombra y animaciones
class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton(this.text, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(3, 3),
            ),
          ],
        ),
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
          child: Text(text),
        ),
      ),
    );
  }
}

// 📌 Nueva pantalla de opciones (igual que el menú principal pero con diferentes opciones)
class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CloudBackground(), // Fondo animado con nubes
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
                const SizedBox(height: 20),
                MenuButton(
                  "Volumen",
                  onPressed: () {
                    // Acción para cambiar volumen
                  },
                ),
                MenuButton(
                  "Idioma",
                  onPressed: () {
                    // Acción para cambiar idioma
                  },
                ),
                MenuButton(
                  "Controles",
                  onPressed: () {
                    // Acción para cambiar controles
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
      ),
    );
  }
}
