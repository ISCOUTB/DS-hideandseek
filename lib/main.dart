import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      body: Container(
        color: const Color.fromARGB(255, 100, 202, 246),
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
        ),
      ),
    );
  }
}

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Simulador de Agentes IA - Hide & Seek",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const BouncingBall(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            MenuButton(
              "Atrás",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

PageRouteBuilder _createRoute() {
  return PageRouteBuilder(
    pageBuilder:
        (context, animation, secondaryAnimation) => const SimulationScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton(this.text, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 100, 202, 246),
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
        ),
      ),
    );
  }
}

class BouncingBall extends StatefulWidget {
  const BouncingBall({super.key});

  @override
  State<BouncingBall> createState() => _BouncingBallState();
}

class _BouncingBallState extends State<BouncingBall>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double posX = 0;
  double posY = 0;
  double dx = 0;
  double dy = 0;
  final double radius = 15;
  final double containerSize = 300;
  final double initialSpeed = 5.0; // Velocidad constante

  List<Obstacle> obstacles = [];
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _generateNonOverlappingObstacles();
    _placeBallRandomly();
    _initializeBallVelocity();

    _ticker = createTicker((Duration elapsed) {
      setState(() {
        _updateBallPosition();
      });
    });

    _ticker.start();
  }

  void _generateNonOverlappingObstacles() {
    final int maxAttempts = 100;
    final int maxObstacles = 8;
    final double minSize = 20;
    final double maxSize = 50;

    for (int i = 0; i < maxObstacles; i++) {
      int attempts = 0;
      bool positionFound = false;

      while (!positionFound && attempts < maxAttempts) {
        attempts++;

        double size = minSize + random.nextDouble() * (maxSize - minSize);
        double x = random.nextDouble() * (containerSize - size);
        double y = random.nextDouble() * (containerSize - size);

        Obstacle newObstacle = Obstacle(
          x: x,
          y: y,
          width: size,
          height: size,
          type:
              random.nextBool() ? ObstacleType.circle : ObstacleType.rectangle,
        );

        bool overlaps = false;
        for (var obstacle in obstacles) {
          if (_checkObstacleOverlap(newObstacle, obstacle)) {
            overlaps = true;
            break;
          }
        }

        if (!overlaps) {
          obstacles.add(newObstacle);
          positionFound = true;
        }
      }
    }
  }

  void _placeBallRandomly() {
    final int maxAttempts = 100;
    int attempts = 0;
    bool positionFound = false;

    while (!positionFound && attempts < maxAttempts) {
      attempts++;

      posX = random.nextDouble() * (containerSize - radius * 2);
      posY = random.nextDouble() * (containerSize - radius * 2);

      positionFound = true;
      for (var obstacle in obstacles) {
        if (_checkCollision(obstacle)) {
          positionFound = false;
          break;
        }
      }
    }

    if (!positionFound) {
      posX = radius;
      posY = radius;
    }
  }

  void _initializeBallVelocity() {
    // Velocidad constante con dirección aleatoria
    double angle = random.nextDouble() * 2 * pi;
    dx = initialSpeed * cos(angle);
    dy = initialSpeed * sin(angle);

    // Normalizar para mantener velocidad exacta
    double currentSpeed = sqrt(dx * dx + dy * dy);
    dx = dx * initialSpeed / currentSpeed;
    dy = dy * initialSpeed / currentSpeed;
  }

  void _updateBallPosition() {
    posX += dx;
    posY += dy;

    // Colisiones con los bordes (perfectamente elásticas)
    if (posX <= 0 || posX >= containerSize - radius * 2) {
      dx = -dx; // Rebote perfecto sin pérdida de velocidad
      posX = posX.clamp(0.0, containerSize - radius * 2);
    }
    if (posY <= 0 || posY >= containerSize - radius * 2) {
      dy = -dy;
      posY = posY.clamp(0.0, containerSize - radius * 2);
    }

    // Detección de colisiones con obstáculos
    for (var obstacle in obstacles) {
      if (_checkCollision(obstacle)) {
        _handleCollision(obstacle);
        break;
      }
    }
  }

  bool _checkObstacleOverlap(Obstacle a, Obstacle b) {
    return a.x < b.x + b.width &&
        a.x + a.width > b.x &&
        a.y < b.y + b.height &&
        a.y + a.height > b.y;
  }

  bool _checkCollision(Obstacle obstacle) {
    double ballCenterX = posX + radius;
    double ballCenterY = posY + radius;

    if (obstacle.type == ObstacleType.circle) {
      double obstacleCenterX = obstacle.x + obstacle.width / 2;
      double obstacleCenterY = obstacle.y + obstacle.height / 2;
      double distance = sqrt(
        pow(ballCenterX - obstacleCenterX, 2) +
            pow(ballCenterY - obstacleCenterY, 2),
      );
      return distance < radius + obstacle.width / 2;
    } else {
      double closestX = ballCenterX.clamp(
        obstacle.x,
        obstacle.x + obstacle.width,
      );
      double closestY = ballCenterY.clamp(
        obstacle.y,
        obstacle.y + obstacle.height,
      );

      double distanceX = ballCenterX - closestX;
      double distanceY = ballCenterY - closestY;

      double distance = sqrt(distanceX * distanceX + distanceY * distanceY);
      return distance < radius;
    }
  }

  void _handleCollision(Obstacle obstacle) {
    double ballCenterX = posX + radius;
    double ballCenterY = posY + radius;

    if (obstacle.type == ObstacleType.circle) {
      // Colisión con círculo (rebote perfectamente elástico)
      double obstacleCenterX = obstacle.x + obstacle.width / 2;
      double obstacleCenterY = obstacle.y + obstacle.height / 2;

      // Vector normal de la colisión
      double nx = ballCenterX - obstacleCenterX;
      double ny = ballCenterY - obstacleCenterY;
      double distance = sqrt(nx * nx + ny * ny);
      nx /= distance;
      ny /= distance;

      // Producto punto para el rebote perfecto
      double dotProduct = dx * nx + dy * ny;
      dx = dx - 2 * dotProduct * nx;
      dy = dy - 2 * dotProduct * ny;

      // Ajuste de posición para evitar superposición
      double overlap = radius + obstacle.width / 2 - distance;
      posX += overlap * nx * 0.5;
      posY += overlap * ny * 0.5;

      // Mantener velocidad constante
      _normalizeVelocity();
    } else {
      // Colisión con rectángulo (rebote perfectamente elástico)
      double closestX = ballCenterX.clamp(
        obstacle.x,
        obstacle.x + obstacle.width,
      );
      double closestY = ballCenterY.clamp(
        obstacle.y,
        obstacle.y + obstacle.height,
      );

      if ((closestX == obstacle.x || closestX == obstacle.x + obstacle.width) &&
          (closestY != obstacle.y &&
              closestY != obstacle.y + obstacle.height)) {
        // Colisión lateral
        dx = -dx;
        if (closestX == obstacle.x) {
          posX = obstacle.x - radius * 2;
        } else {
          posX = obstacle.x + obstacle.width;
        }
      } else {
        // Colisión superior/inferior
        dy = -dy;
        if (closestY == obstacle.y) {
          posY = obstacle.y - radius * 2;
        } else {
          posY = obstacle.y + obstacle.height;
        }
      }

      // Mantener velocidad constante
      _normalizeVelocity();
    }
  }

  void _normalizeVelocity() {
    // Asegurar que la velocidad se mantenga constante
    double currentSpeed = sqrt(dx * dx + dy * dy);
    if (currentSpeed > 0) {
      dx = dx * initialSpeed / currentSpeed;
      dy = dy * initialSpeed / currentSpeed;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: CustomPaint(painter: BallPainter(posX, posY, radius, obstacles)),
    );
  }
}

enum ObstacleType { circle, rectangle }

class Obstacle {
  double x;
  double y;
  double width;
  double height;
  ObstacleType type;

  Obstacle({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.type,
  });
}

class BallPainter extends CustomPainter {
  final double x;
  final double y;
  final double radius;
  final List<Obstacle> obstacles;

  BallPainter(this.x, this.y, this.radius, this.obstacles);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    for (var obstacle in obstacles) {
      final obstaclePaint =
          Paint()
            ..color =
                obstacle.type == ObstacleType.circle
                    ? Colors.blue
                    : Colors.green
            ..style = PaintingStyle.fill;

      if (obstacle.type == ObstacleType.circle) {
        canvas.drawCircle(
          Offset(
            obstacle.x + obstacle.width / 2,
            obstacle.y + obstacle.height / 2,
          ),
          obstacle.width / 2,
          obstaclePaint,
        );
      } else {
        canvas.drawRect(
          Rect.fromLTWH(
            obstacle.x,
            obstacle.y,
            obstacle.width,
            obstacle.height,
          ),
          obstaclePaint,
        );
      }
    }

    final ballPaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x + radius, y + radius), radius, ballPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
