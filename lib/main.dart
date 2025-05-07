import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart' as f;
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

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
      home: const PaginaSimulacion(), // Cambiar a PaginaSimulacion
    );
  }
}

class MyAppState extends ChangeNotifier {}

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

class GridOverlay extends Component with HasGameRef<FlameGame> {
  final double tileSize;
  final Paint linePaint;

  GridOverlay({required this.tileSize})
    : linePaint =
          Paint()
            ..color = const Color(0xFF000000) // línea semitransparente blanca
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1;

  @override
  void render(Canvas canvas) {
    final size = gameRef.size;
    // líneas verticales
    for (double x = 0; x <= size.x; x += tileSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), linePaint);
    }
    // líneas horizontales
    for (double y = 0; y <= size.y; y += tileSize) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), linePaint);
    }
  }
}

class MiMundo extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  static const tileSize = 64.0;

  @override
  Future<void> onLoad() async {
    //mapa
    add(TileMap());

    // Posiciones de inicio (fila, columna)
    const hiderRow = 3;
    const hiderCol = 2;
    const seekerRow = 8;
    const seekerCol = 12;

    // cuadrícula
    //add(GridOverlay(tileSize: tileSize));

    //personajes
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

class TileMap extends Component with HasGameRef {
  @override
  Future<void> onLoad() async {
    // Cargar la imagen del mapa
    final mapImage = await gameRef.images.load('maps/room1.png');

    // Tamaño de cada tile (ajusta según tu diseño)
    const tileSize = 64.0;

    // Dividir la imagen en tiles
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: mapImage,
      columns: (mapImage.width / tileSize).floor(),
      rows: (mapImage.height / tileSize).floor(),
    );

    // Crear los tiles y agregarlos al juego
    for (int row = 0; row < spriteSheet.rows; row++) {
      for (int col = 0; col < spriteSheet.columns; col++) {
        final tileSprite = spriteSheet.getSprite(row, col);
        add(
          SpriteComponent(
            sprite: tileSprite,
            size: Vector2.all(tileSize),
            position: Vector2(col * tileSize, row * tileSize),
          ),
        );
      }
    }
  }
}

class Hider extends SpriteAnimationComponent with HasGameRef, KeyboardHandler {
  Hider({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(64),
        anchor: Anchor.bottomCenter,
      );

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _moveUpAnimation;
  late final SpriteAnimation _moveDownAnimation;
  late final SpriteAnimation _moveLeftAnimation;
  late final SpriteAnimation _moveRightAnimation;

  final double speed = 100;

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load('characters/hider.png');
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 4, // Number of columns in the sprite sheet
      rows: 3, // Number of rows in the sprite sheet
    );

    // Animaciones
    _idleAnimation = SpriteAnimation.spriteList(
      [spriteSheet.getSprite(0, 0)], // solo el fotograma (fila 0, columna 0)
      stepTime: double.infinity, // nunca avanza al siguiente fotograma
    );
    _moveDownAnimation = spriteSheet.createAnimation(
      row: 0,
      from: 1,
      to: 2,
      stepTime: 0.2,
      loop: true,
    );
    _moveLeftAnimation = spriteSheet.createAnimation(
      row: 0,
      from: 1,
      to: 2,
      stepTime: 0.2,
    );
    _moveRightAnimation = spriteSheet.createAnimation(
      row: 0,
      from: 1,
      to: 2,
      stepTime: 0.2,
    );
    _moveUpAnimation = spriteSheet.createAnimation(
      row: 0,
      from: 1,
      to: 2,
      stepTime: 0.2,
    );

    animation = _idleAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Movimiento continuo basado en la velocidad
    if (velocity != Vector2.zero()) {
      position.add(velocity * dt);
    }
  }

  Vector2 velocity = Vector2.zero();

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    velocity.setZero();
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      velocity.y = -speed;
      animation = _moveUpAnimation;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      velocity.y = speed;
      animation = _moveDownAnimation;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -speed;
      animation = _moveLeftAnimation;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = speed;
      animation = _moveRightAnimation;
    } else {
      animation = _idleAnimation;
    }
    return true;
  }
}

class Seeker extends SpriteAnimationComponent with HasGameRef {
  Seeker({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(64),
        anchor: Anchor.bottomCenter,
      );

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load('characters/seeker.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 4,
      rows: 3,
    );

    // Solo el fotograma (fila 0, columna 0), sin animar
    animation = SpriteAnimation.spriteList([
      sheet.getSprite(0, 0),
    ], stepTime: double.infinity);
  }
}
