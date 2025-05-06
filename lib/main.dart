import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';

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
      home: const PaginaSimulacion(), // Cambiar a PaginaSimulacion
    );
  }
}

class MyAppState extends ChangeNotifier {}

class PaginaSimulacion extends StatelessWidget {
  const PaginaSimulacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: MiMundo()));
  }
}

class MiMundo extends FlameGame with HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    //mapa
    add(TileMap());

    //personajes
    add(Hider(position: Vector2(100, 100)));
    add(Seeker(position: Vector2(300, 100)));
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

class Hider extends SpriteAnimationComponent with HasGameRef {
  Hider({required Vector2 position})
    : super(position: position, size: Vector2.all(64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load('characters/hider.png');
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 4, // Number of columns in the sprite sheet
      rows: 3, // Number of rows in the sprite sheet
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1);
  }
}

class Seeker extends SpriteAnimationComponent with HasGameRef {
  Seeker({required Vector2 position})
    : super(position: position, size: Vector2.all(64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load('characters/seeker.png');
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 4, // Número de columnas en el spritesheet
      rows: 3, // Número de filas en el spritesheet
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1);
  }
}
