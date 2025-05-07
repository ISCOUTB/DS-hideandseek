import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart' as f;
import 'package:flame/input.dart';
import 'package:flutter/services.dart'; // para LogicalKeyboardKey

// =============================================================================
// main() y App scaffold
// =============================================================================
void main() {
  f.Flame.images.prefix = '';
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
      home: const MainMenu(), // Aquí abrimos el menú principal
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
                      MaterialPageRoute(
                        builder: (_) => const PaginaSimulacion(),
                      ),
                    );
                  },
                ),
                _MenuButton(
                  "Opciones",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const OptionsScreen()),
                    );
                  },
                ),
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

// =============================================================================
// 2) OptionsScreen: la pantalla de Opciones (vacía por ahora)
// =============================================================================
class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Opciones")),
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
                  "Opciones",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _MenuButton("Volumen", onPressed: () {}),
                _MenuButton("Idioma", onPressed: () {}),
                _MenuButton("Atrás", onPressed: () => Navigator.pop(context)),
                const SizedBox(height: 12),
                const Text(
                  "Versión: 1.0.0",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 3) PaginaSimulacion: donde cargamos tu juego en Flame
// =============================================================================
class PaginaSimulacion extends StatelessWidget {
  const PaginaSimulacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: MiMundo(),
        focusNode: FocusNode(),
        autofocus: true,
      ),
    );
  }
}

// =============================================================================
// 4) Tu código del juego: MiMundo, TileMap, Hider y Seeker (sin cambios)
// =============================================================================
class MiMundo extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  static const tileSize = 64.0;

  @override
  Future<void> onLoad() async {
    add(TileMap());

    const hiderRow = 3, hiderCol = 2;
    const seekerRow = 8, seekerCol = 12;

    add(
      Hider(
        position: Vector2(
          hiderCol * tileSize + tileSize / 2,
          hiderRow * tileSize + tileSize,
        ),
      ),
    );
    add(
      Seeker(
        position: Vector2(
          seekerCol * tileSize + tileSize / 2,
          seekerRow * tileSize + tileSize,
        ),
      ),
    );
  }
}

class TileMap extends Component with HasGameRef<FlameGame> {
  @override
  Future<void> onLoad() async {
    final mapImage = await gameRef.images.load('maps/room1.png');
    const tileSize = 64.0;
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: mapImage,
      columns: (mapImage.width / tileSize).floor(),
      rows: (mapImage.height / tileSize).floor(),
    );
    for (int r = 0; r < sheet.rows; r++) {
      for (int c = 0; c < sheet.columns; c++) {
        add(
          SpriteComponent(
            sprite: sheet.getSprite(r, c),
            size: Vector2.all(tileSize),
            position: Vector2(c * tileSize, r * tileSize),
          ),
        );
      }
    }
  }
}

class Hider extends SpriteAnimationComponent
    with HasGameRef<FlameGame>, KeyboardHandler {
  Hider({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(64),
        anchor: Anchor.bottomCenter,
      );

  late final SpriteAnimation _idle, _up, _down, _left, _right;
  final speed = 100.0;
  Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    final img = await gameRef.images.load('characters/hider.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: img,
      columns: 4,
      rows: 3,
    );

    _idle = SpriteAnimation.spriteList([
      sheet.getSprite(0, 0),
    ], stepTime: double.infinity);
    _down = sheet.createAnimation(row: 0, from: 1, to: 2, stepTime: 0.2);
    _left = sheet.createAnimation(row: 0, from: 1, to: 2, stepTime: 0.2);
    _right = sheet.createAnimation(row: 0, from: 1, to: 2, stepTime: 0.2);
    _up = sheet.createAnimation(row: 0, from: 1, to: 2, stepTime: 0.2);

    animation = _idle;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (velocity != Vector2.zero()) position += velocity * dt;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    velocity.setZero();
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      velocity.y = -speed;
      animation = _up;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      velocity.y = speed;
      animation = _down;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -speed;
      animation = _left;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = speed;
      animation = _right;
    } else {
      animation = _idle;
    }
    return true;
  }
}

class Seeker extends SpriteAnimationComponent with HasGameRef<FlameGame> {
  Seeker({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(64),
        anchor: Anchor.bottomCenter,
      );

  @override
  Future<void> onLoad() async {
    final img = await gameRef.images.load('characters/seeker.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: img,
      columns: 4,
      rows: 3,
    );

    // Un solo fotograma estático
    animation = SpriteAnimation.spriteList([
      sheet.getSprite(0, 0),
    ], stepTime: double.infinity);
  }
}
