import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Importation de ton fichier principal
import 'package:alpha_translator/main.dart';

void main() {
  testWidgets('AlphaTranslator smoke test', (WidgetTester tester) async {
    // On remplace "const MyApp()" par "AlphaTranslator()"
    await tester.pumpWidget(MaterialApp(home: AlphaTranslator()));

    // On vérifie que le titre de ton application s'affiche bien
    expect(find.text('Traductions Spécialisées'), findsOneWidget);
  });
}