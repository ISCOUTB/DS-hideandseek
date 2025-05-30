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

  testWidgets('MenuButton se puede presionar', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(home: MenuButton('Test', onPressed: () => pressed = true)),
    );
    expect(find.text('Test'), findsOneWidget);
    await tester.tap(find.text('Test'));
    expect(pressed, true);
  });

  testWidgets('CloudBackground se puede renderizar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CloudBackground())),
    );
    expect(find.byType(CloudBackground), findsOneWidget);
  });
}
