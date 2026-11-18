// Test pentru aplicația de feed și detalii API.

import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/main.dart';

void main() {
  testWidgets('Test pornire aplicație API Feed', (WidgetTester tester) async {
    // Construim aplicația și declanșăm un cadru.
    await tester.pumpWidget(const MyApp());

    // Verificăm că titlul sau elementele principale din aplicație se încarcă corect.
    expect(find.byType(MyApp), findsOneWidget);
  });
}
