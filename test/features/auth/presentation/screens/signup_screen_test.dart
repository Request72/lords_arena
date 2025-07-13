import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lords_arena/features/auth/presentation/screens/signup_screen.dart';

void main() {
  group('SignupScreen UI Test', () {
    testWidgets('input fields and signup button', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      expect(find.byKey(Key('usernameField')), findsOneWidget);
      expect(find.byKey(Key('emailField')), findsOneWidget);
      expect(find.byKey(Key('passwordField')), findsOneWidget);
      expect(find.byKey(Key('signupButton')), findsOneWidget);
    });

    testWidgets('input fields', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      await tester.enterText(find.byKey(Key('usernameField')), 'Request');
      await tester.enterText(find.byKey(Key('emailField')), 'request@mail.com');
      await tester.enterText(find.byKey(Key('passwordField')), '123456');

      expect(find.text('Request'), findsOneWidget);
      expect(find.text('request@mail.com'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);
    });
  });
}
