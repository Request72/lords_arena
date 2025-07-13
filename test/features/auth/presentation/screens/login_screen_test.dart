import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lords_arena/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('Login screen UI elements test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // email + password
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
