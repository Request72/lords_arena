import 'package:flutter_test/flutter_test.dart';
import 'package:lords_arena/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  group('AuthEvent Test', () {
    test('LoginRequested holds correct email and password', () {
      final event = LoginRequested('test@mail.com', '123456');
      expect(event.email, 'test@mail.com');
      expect(event.password, '123456');
    });

    test('SignupRequested holds correct username, email, and password', () {
      final event = SignupRequested('Request', 'request@mail.com', '123456');
      expect(event.username, 'Request');
      expect(event.email, 'request@mail.com');
      expect(event.password, '123456');
    });

    test('LogoutRequested can be created without error', () {
      final event = LogoutRequested();
      expect(event, isA<LogoutRequested>());
    });
  });
}
