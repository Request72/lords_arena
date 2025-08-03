import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lords_arena/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lords_arena/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lords_arena/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, AuthLocalDataSource])
void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    authRepository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('AuthRepository Tests', () {
    group('Login Tests', () {
      test('should return UserModel when login is successful', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';
        final userModel = UserModel(
          userId: 'user123',
          email: email,
          username: 'testuser',
          token: 'jwt_token_here',
        );

        when(
          mockRemoteDataSource.login(email, password),
        ).thenAnswer((_) async => userModel);
        when(
          mockLocalDataSource.saveUser(userModel),
        ).thenAnswer((_) async => true);

        // Act
        final result = await authRepository.login(email, password);

        // Assert
        expect(result, isA<UserModel>());
        expect(result?.email, email);
        expect(result?.token, 'jwt_token_here');
        verify(mockRemoteDataSource.login(email, password)).called(1);
        verify(mockLocalDataSource.saveUser(userModel)).called(1);
      });

      test('should return null when login fails', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'wrongpassword';

        when(
          mockRemoteDataSource.login(email, password),
        ).thenAnswer((_) async => null);

        // Act
        final result = await authRepository.login(email, password);

        // Assert
        expect(result, isNull);
        verify(mockRemoteDataSource.login(email, password)).called(1);
        verifyNever(mockLocalDataSource.saveUser(any));
      });

      test('should handle network errors during login', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = 'password123';

        when(
          mockRemoteDataSource.login(email, password),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => authRepository.login(email, password), throwsException);
      });

      test('should handle empty email during login', () async {
        // Arrange
        const email = '';
        const password = 'password123';

        // Act
        final result = await authRepository.login(email, password);

        // Assert
        expect(result, isNull);
        verifyNever(mockRemoteDataSource.login(any, any));
      });

      test('should handle empty password during login', () async {
        // Arrange
        const email = 'test@gmail.com';
        const password = '';

        // Act
        final result = await authRepository.login(email, password);

        // Assert
        expect(result, isNull);
        verifyNever(mockRemoteDataSource.login(any, any));
      });
    });

    group('Signup Tests', () {
      test('should return UserModel when signup is successful', () async {
        // Arrange
        const username = 'testuser';
        const email = 'test@gmail.com';
        const password = 'password123';
        final userModel = UserModel(
          userId: 'user123',
          email: email,
          username: username,
          token: 'jwt_token_here',
        );

        when(
          mockRemoteDataSource.signup(username, email, password),
        ).thenAnswer((_) async => userModel);
        when(
          mockLocalDataSource.saveUser(userModel),
        ).thenAnswer((_) async => true);

        // Act
        final result = await authRepository.signup(username, email, password);

        // Assert
        expect(result, isA<UserModel>());
        expect(result?.email, email);
        expect(result?.token, 'jwt_token_here');
        verify(
          mockRemoteDataSource.signup(username, email, password),
        ).called(1);
        verify(mockLocalDataSource.saveUser(userModel)).called(1);
      });

      test('should return null when signup fails', () async {
        // Arrange
        const username = 'testuser';
        const email = 'test@gmail.com';
        const password = 'password123';

        when(
          mockRemoteDataSource.signup(username, email, password),
        ).thenAnswer((_) async => null);

        // Act
        final result = await authRepository.signup(username, email, password);

        // Assert
        expect(result, isNull);
        verify(
          mockRemoteDataSource.signup(username, email, password),
        ).called(1);
        verifyNever(mockLocalDataSource.saveUser(any));
      });

      test('should handle network errors during signup', () async {
        // Arrange
        const username = 'testuser';
        const email = 'test@gmail.com';
        const password = 'password123';

        when(
          mockRemoteDataSource.signup(username, email, password),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => authRepository.signup(username, email, password),
          throwsException,
        );
      });

      test('should handle empty username during signup', () async {
        // Arrange
        const username = '';
        const email = 'test@gmail.com';
        const password = 'password123';

        // Act
        final result = await authRepository.signup(username, email, password);

        // Assert
        expect(result, isNull);
        verifyNever(mockRemoteDataSource.signup(any, any, any));
      });

      test('should handle invalid email format during signup', () async {
        // Arrange
        const username = 'testuser';
        const email = 'invalid-email';
        const password = 'password123';

        // Act
        final result = await authRepository.signup(username, email, password);

        // Assert
        expect(result, isNull);
        verifyNever(mockRemoteDataSource.signup(any, any, any));
      });
    });

    group('User Management Tests', () {
      test('should return saved user when getUser is called', () async {
        // Arrange
        final userModel = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'testuser',
          token: 'jwt_token_here',
        );

        when(mockLocalDataSource.getUser()).thenAnswer((_) async => userModel);

        // Act
        final result = await authRepository.getUser();

        // Assert
        expect(result, equals(userModel));
        verify(mockLocalDataSource.getUser()).called(1);
      });

      test('should return null when no user is saved', () async {
        // Arrange
        when(mockLocalDataSource.getUser()).thenAnswer((_) async => null);

        // Act
        final result = await authRepository.getUser();

        // Assert
        expect(result, isNull);
        verify(mockLocalDataSource.getUser()).called(1);
      });

      test('should save user successfully', () async {
        // Arrange
        final userModel = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'testuser',
          token: 'jwt_token_here',
        );

        when(
          mockLocalDataSource.saveUser(userModel),
        ).thenAnswer((_) async => true);

        // Act
        final result = await authRepository.saveUser(userModel);

        // Assert
        expect(result, isTrue);
        verify(mockLocalDataSource.saveUser(userModel)).called(1);
      });

      test('should logout user successfully', () async {
        // Arrange
        when(mockLocalDataSource.clearUser()).thenAnswer((_) async => true);

        // Act
        final result = await authRepository.logout();

        // Assert
        expect(result, isTrue);
        verify(mockLocalDataSource.clearUser()).called(1);
      });

      test('should handle logout failure', () async {
        // Arrange
        when(mockLocalDataSource.clearUser()).thenAnswer((_) async => false);

        // Act
        final result = await authRepository.logout();

        // Assert
        expect(result, isFalse);
        verify(mockLocalDataSource.clearUser()).called(1);
      });
    });
  });
}
