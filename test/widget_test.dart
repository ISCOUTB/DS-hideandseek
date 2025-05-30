// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba/main.dart';

void main() {
  testWidgets('MainMenu se muestra y tiene botones principales', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text('Hide and Seek'), findsOneWidget);
    expect(find.text('Iniciar'), findsOneWidget);
    expect(find.text('Opciones'), findsOneWidget);
    expect(find.text('Créditos'), findsOneWidget);
  });

  testWidgets('Navega a OptionsScreen y muestra controles', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OptionsScreen()));
    expect(find.text('Opciones'), findsOneWidget);
    expect(find.text('Volumen'), findsOneWidget);
    expect(find.text('Idioma'), findsOneWidget);
    expect(find.text('Atrás'), findsOneWidget);
  });

  testWidgets('Navega a CreditsScreen y muestra créditos', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreditsScreen()));
    expect(find.text('Créditos'), findsOneWidget);
    expect(find.text('• Eddy Lara'), findsOneWidget); // Cambiado para coincidir con el texto real
    expect(find.text('Atrás'), findsOneWidget);
  });

  testWidgets('MazeGameScreen muestra el laberinto y controles', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MazeGameScreen()));
    await tester.pumpAndSettle();

    // Busca el botón "¡Estoy listo!"
    expect(find.text('¡Estoy listo!'), findsOneWidget);

    // Busca el botón "Menú principal"
    expect(find.text('Menú principal'), findsOneWidget);

    // Busca el texto que contiene "Tiempo restante"
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data != null && widget.data!.contains('Tiempo restante'),
      ),
      findsOneWidget,
    );

    // Busca el texto que contiene "Dificultad"
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data != null && widget.data!.contains('Dificultad'),
      ),
      findsOneWidget,
    );
  });
}
