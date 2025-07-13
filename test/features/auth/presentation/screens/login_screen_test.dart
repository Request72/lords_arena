import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/auth/presentation/screens/login_screen.dart';
import 'package:lords_arena/features/auth/presentation/cubit/login_cubit.dart';
import 'package:mockito/mockito.dart';

class MockLoginCubit extends Mock implements LoginCubit {}

void main() {
  testWidgets('Login screen UI elements test', (WidgetTester tester) async {
    final mockLoginCubit = MockLoginCubit();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // email + password
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
