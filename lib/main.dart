import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Hiden And Seek',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 59, 87, 211),
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 2, 2),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 59, 87, 211),
                Color.fromARGB(255, 2, 2, 2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(50),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Hiden And Seek",
                style: GoogleFonts.pressStart2p(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              BotonInicio(
                texto: "Iniciar",
                accion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaSimulacion(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              BotonInicio(texto: "Opciones", accion: () {}),
              const SizedBox(height: 10),
              BotonInicio(texto: "Acerca de", accion: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class BotonInicio extends StatelessWidget {
  const BotonInicio({super.key, required this.texto, required this.accion});

  final VoidCallback accion;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      onPressed: accion,
      child: Text(texto, style: const TextStyle(color: Colors.black)),
    );
  }
}

class PaginaSimulacion extends StatelessWidget {
  const PaginaSimulacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hiden And Seek')),
      body: Expanded(child: GameWidget(game: FlameGame(world: MiMundo()))),
    );
  }
}

class MiMundo extends World {
  @override
  Future<void> onLoad() async {
    add(Player(position: Vector2(0, 0)));
  }
}

class Player extends SpriteComponent {
  Player({super.position})
    : super(size: Vector2.all(200), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
  }
}
