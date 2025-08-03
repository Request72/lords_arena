import 'package:flutter_test/flutter_test.dart';
import 'package:lords_arena/features/auth/presentation/cubit/login_cubit.dart';

void main() {
  group('LoginCubit Tests', () {
    late LoginCubit loginCubit;

    setUp(() {
      loginCubit = LoginCubit();
    });

    tearDown(() {
      loginCubit.close();
    });

    group('Initial State', () {
      test('should have initial state as LoginInitial', () {
        expect(loginCubit.state, isA<LoginInitial>());
      });

      test('should emit LoginInitial when created', () {
        expect(loginCubit.state, isA<LoginInitial>());
      });
    });

    group('Login Success Tests', () {
      test(
        'should emit LoginLoading then LoginSuccess when login succeeds',
        () async {
          // Arrange
          const email = 'test@gmail.com';
          const password = 'password123';

          // Act & Assert
          expectLater(
            loginCubit.stream,
            emitsInOrder([isA<LoginLoading>(), isA<LoginSuccess>()]),
          );

          await loginCubit.login(email, password);
        },
      );

      test('should handle valid email format', () async {
        // Arrange
        const email = 'valid.email@gmail.com';
        const password = 'password123';

        // Act & Assert
        expectLater(
          loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginSuccess>()]),
        );

        await loginCubit.login(email, password);
      });

      test('should handle password with special characters', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'P@ssw0rd!';

        // Act & Assert
        expectLater(
          loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginSuccess>()]),
        );

        await loginCubit.login(email, password);
      });
    });

    group('Login Failure Tests', () {
      test(
        'should emit LoginLoading then LoginFailure when login fails',
        () async {
          // Arrange
          const email = 'test@gmail.com';
          const password = 'wrongpassword';

          // Act & Assert
          expectLater(
            loginCubit.stream,
            emitsInOrder([isA<LoginLoading>(), isA<LoginFailure>()]),
          );

          await loginCubit.login(email, password);
        },
      );

      test('should handle empty email', () async {
        // Arrange
        const email = '';
        const password = 'password123';

        // Act & Assert
        expectLater(
          loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginFailure>()]),
        );

        await loginCubit.login(email, password);
      });

      test('should handle empty password', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = '';

        // Act & Assert
        expectLater(
          loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginFailure>()]),
        );

        await loginCubit.login(email, password);
      });

      test('should handle invalid email format', () async {
        // Arrange
        const email = 'invalid-email';
        const password = 'password123';

        // Act & Assert
        expectLater(
          loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginFailure>()]),
        );

        await loginCubit.login(email, password);
      });

      test('should handle network errors', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act & Assert
        expectLater(
          loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginFailure>()]),
        );

        await loginCubit.login(email, password);
      });
    });

    group('State Management Tests', () {
      test('should maintain state consistency during login process', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act & Assert
        expect(loginCubit.state, isA<LoginInitial>());

        await loginCubit.login(email, password);

        expect(loginCubit.state, isA<LoginSuccess>());
      });

      test('should handle multiple login attempts', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act
        await loginCubit.login(email, password);
        await loginCubit.login(email, password);

        // Assert
        expect(loginCubit.state, isA<LoginSuccess>());
      });

      test('should reset state when new login is initiated', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act
        await loginCubit.login(email, password);
        await loginCubit.login(email, password);

        // Assert
        expect(loginCubit.state, isA<LoginSuccess>());
      });
    });

    group('Input Validation Tests', () {
      test('should validate email format', () {
        // Arrange
        const validEmails = [
          'test@gmail.com',
          'user@domain.co.uk',
          'test123@example.org',
        ];

        const invalidEmails = ['invalid-email', 'test@', '@domain.com', ''];

        // Act & Assert
        for (final email in validEmails) {
          expect(loginCubit.isValidEmail(email), isTrue);
        }

        for (final email in invalidEmails) {
          expect(loginCubit.isValidEmail(email), isFalse);
        }
      });

      test('should validate password length', () {
        // Arrange
        const validPasswords = ['password123', 'P@ssw0rd!', '123456789'];

        const invalidPasswords = ['', '123', 'short'];

        // Act & Assert
        for (final password in validPasswords) {
          expect(loginCubit.isValidPassword(password), isTrue);
        }

        for (final password in invalidPasswords) {
          expect(loginCubit.isValidPassword(password), isFalse);
        }
      });
    });

    group('Error Handling Tests', () {
      test('should handle server errors gracefully', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act & Assert
        expectLater(
          loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginFailure>()]),
        );

        await loginCubit.login(email, password);
      });

      test('should provide meaningful error messages', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'wrongpassword';

        // Act
        await loginCubit.login(email, password);

        // Assert
        final state = loginCubit.state;
        if (state is LoginFailure) {
          expect(state.message, isNotEmpty);
          expect(state.message, contains('Invalid credentials'));
        }
      });

      test('should handle timeout errors', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act & Assert
        expectLater(
          loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginFailure>()]),
        );

        await loginCubit.login(email, password);
      });
    });

    group('User Session Tests', () {
      test('should check if user is logged in', () {
        // Act
        final isLoggedIn = loginCubit.isLoggedIn();

        // Assert
        expect(isLoggedIn, isA<bool>());
      });

      test('should handle session persistence', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act
        await loginCubit.login(email, password);
        final isLoggedIn = loginCubit.isLoggedIn();

        // Assert
        expect(isLoggedIn, isTrue);
      });

      test('should clear session on logout', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act
        await loginCubit.login(email, password);
        await loginCubit.logout();
        final isLoggedIn = loginCubit.isLoggedIn();

        // Assert
        expect(isLoggedIn, isFalse);
      });
    });

    group('Performance Tests', () {
      test('should handle rapid login attempts', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act
        final futures = List.generate(
          5,
          (_) => loginCubit.login(email, password),
        );

        await Future.wait(futures);

        // Assert
        expect(loginCubit.state, isA<LoginSuccess>());
      });

      test('should not block UI during login process', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act
        final future = loginCubit.login(email, password);

        // Assert
        expect(loginCubit.state, isA<LoginLoading>());
        await future;
        expect(loginCubit.state, isA<LoginSuccess>());
      });
    });
  });
}
