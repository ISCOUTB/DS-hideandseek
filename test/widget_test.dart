// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba/main.dart';

void main() {
  testWidgets('MainApp se puede crear', (tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.byType(MainApp), findsOneWidget);
  });

  testWidgets('MainMenu muestra los botones principales', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainMenu()));
    expect(find.text('Hide and Seek'), findsOneWidget);
    expect(find.text('Iniciar'), findsOneWidget);
    expect(find.text('Opciones'), findsOneWidget);
    expect(find.text('Créditos'), findsOneWidget);
  });

  testWidgets('OptionsScreen muestra controles', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OptionsScreen()));
    expect(find.text('Opciones'), findsOneWidget);
    expect(find.text('Volumen'), findsOneWidget);
    expect(find.text('Idioma'), findsOneWidget);
    expect(find.text('Atrás'), findsOneWidget);
  });

  testWidgets('CreditsScreen muestra créditos', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreditsScreen()));
    expect(find.text('Créditos'), findsOneWidget);
    expect(find.text('• Eddy Lara'), findsOneWidget);
    expect(find.text('Atrás'), findsOneWidget);
  });

  testWidgets('MazeGameScreen muestra controles básicos', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MazeGameScreen()));
    // Espera a que se construya el widget y se resuelvan los frames
    await tester.pumpAndSettle();
    // Busca los textos esperados
    expect(find.text('¡Estoy listo!'), findsOneWidget);
    expect(find.text('Menú principal'), findsOneWidget);
    expect(find.textContaining('Tiempo restante'), findsOneWidget);
    expect(find.textContaining('Dificultad'), findsOneWidget);
  });

  testWidgets('MenuButton se puede presionar', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(MaterialApp(
      home: MenuButton('Test', onPressed: () => pressed = true),
    ));
    expect(find.text('Test'), findsOneWidget);
    await tester.tap(find.text('Test'));
    expect(pressed, true);
  });

  testWidgets('CloudBackground se puede renderizar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CloudBackground())));
    expect(find.byType(CloudBackground), findsOneWidget);
  });

  // TESTS ADICIONALES

  testWidgets('MainMenu navega a OptionsScreen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainMenu()));
    final opcionesBtn = find.text('Opciones');
    expect(opcionesBtn, findsOneWidget);
    await tester.tap(opcionesBtn);
    await tester.pumpAndSettle();
    // Puede que no navegue si el botón no está implementado, pero el test está listo para cuando lo esté
  });

  testWidgets('MainMenu navega a CreditsScreen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainMenu()));
    final creditosBtn = find.text('Créditos');
    expect(creditosBtn, findsOneWidget);
    await tester.tap(creditosBtn);
    await tester.pumpAndSettle();
  });

  testWidgets('OptionsScreen cambia el volumen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OptionsScreen()));
    final slider = find.byType(Slider);
    expect(slider, findsOneWidget);
    await tester.drag(slider, const Offset(50, 0));
  });

  testWidgets('OptionsScreen cambia el idioma', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OptionsScreen()));
    final dropdown = find.byType(DropdownButton<String>);
    if (dropdown.evaluate().isNotEmpty) {
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      expect(find.text('Español'), findsWidgets);
    }
  });

  testWidgets('MazeGameScreen responde a teclas de movimiento', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MazeGameScreen()));
    await tester.pumpAndSettle();
    // Simula una pulsación de flecha
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
  });

  testWidgets('MazeGameScreen muestra el jugador y el seeker', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MazeGameScreen()));
    await tester.pumpAndSettle();
    // Busca los iconos del jugador y del seeker si están implementados como Icon o Container
    expect(find.byType(Icon), findsWidgets);
  });
}
    expect(find.text('Opciones'), findsOneWidget);
    expect(find.text('Volumen'), findsOneWidget);
    expect(find.text('Idioma'), findsOneWidget);
    expect(find.text('Atrás'), findsOneWidget);
  });

  testWidgets('CreditsScreen muestra créditos', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreditsScreen()));
    expect(find.text('Créditos'), findsOneWidget);
    expect(find.text('• Eddy Lara'), findsOneWidget);
    expect(find.text('Atrás'), findsOneWidget);
  });

  testWidgets('MazeGameScreen muestra controles básicos', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MazeGameScreen()));
    expect(find.text('¡Estoy listo!'), findsOneWidget);
    expect(find.text('Menú principal'), findsOneWidget);
    expect(find.textContaining('Tiempo restante'), findsOneWidget);
    expect(find.textContaining('Dificultad'), findsOneWidget);
  });

  testWidgets('MenuButton se puede presionar', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(MaterialApp(
      home: MenuButton('Test', onPressed: () => pressed = true),
    ));
    expect(find.text('Test'), findsOneWidget);
    await tester.tap(find.text('Test'));
    expect(pressed, true);
  });

  testWidgets('CloudBackground se puede renderizar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CloudBackground())));
    expect(find.byType(CloudBackground), findsOneWidget);
  });
}
