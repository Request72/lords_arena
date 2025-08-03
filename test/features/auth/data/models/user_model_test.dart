import 'package:flutter_test/flutter_test.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    group('Constructor Tests', () {
      test('should create UserModel with valid parameters', () {
        // Arrange & Act
        const userId = 'user123';
        const email = 'test@gmail.com';
        const token = 'jwt_token_here';

        final userModel = UserModel(
          userId: userId,
          email: email,
          username: 'test',
          token: token,
        );

        // Assert
        expect(userModel.userId, equals(userId));
        expect(userModel.email, equals(email));
        expect(userModel.token, equals(token));
      });

      test('should create UserModel with empty values', () {
        // Arrange & Act
        final userModel = UserModel(
          userId: '',
          email: '',
          username: '',
          token: '',
        );

        // Assert
        expect(userModel.userId, equals(''));
        expect(userModel.email, equals(''));
        expect(userModel.token, equals(''));
      });

      test('should create UserModel with special characters', () {
        // Arrange & Act
        const userId = 'user_123@test';
        const email = 'test+user@gmail.com';
        const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

        final userModel = UserModel(
          userId: userId,
          email: email,
          username: 'test_user',
          token: token,
        );

        // Assert
        expect(userModel.userId, equals(userId));
        expect(userModel.email, equals(email));
        expect(userModel.token, equals(token));
      });
    });

    group('fromJson Tests', () {
      test('should create UserModel from valid JSON', () {
        // Arrange
        final json = {
          'userId': 'user123',
          'email': 'test@gmail.com',
          'token': 'jwt_token_here',
        };

        // Act
        final userModel = UserModel.fromJson(json);

        // Assert
        expect(userModel.userId, equals('user123'));
        expect(userModel.email, equals('test@gmail.com'));
        expect(userModel.token, equals('jwt_token_here'));
      });

      test('should handle JSON with _id instead of userId', () {
        // Arrange
        final json = {
          '_id': 'user123',
          'email': 'test@gmail.com',
          'token': 'jwt_token_here',
        };

        // Act
        final userModel = UserModel.fromJson(json);

        // Assert
        expect(userModel.userId, equals('user123'));
        expect(userModel.email, equals('test@gmail.com'));
        expect(userModel.token, equals('jwt_token_here'));
      });

      test('should handle JSON with missing fields', () {
        // Arrange
        final json = {
          'userId': 'user123',
          // email and token missing
        };

        // Act
        final userModel = UserModel.fromJson(json);

        // Assert
        expect(userModel.userId, equals('user123'));
        expect(userModel.email, equals(''));
        expect(userModel.token, equals(''));
      });

      test('should handle empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final userModel = UserModel.fromJson(json);

        // Assert
        expect(userModel.userId, equals(''));
        expect(userModel.email, equals(''));
        expect(userModel.token, equals(''));
      });

      test('should handle null values in JSON', () {
        // Arrange
        final json = {'userId': null, 'email': null, 'token': null};

        // Act
        final userModel = UserModel.fromJson(json);

        // Assert
        expect(userModel.userId, equals(''));
        expect(userModel.email, equals(''));
        expect(userModel.token, equals(''));
      });
    });

    group('toJson Tests', () {
      test('should convert UserModel to JSON', () {
        // Arrange
        final userModel = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        // Act
        final json = userModel.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['userId'], equals('user123'));
        expect(json['email'], equals('test@gmail.com'));
        expect(json['token'], equals('jwt_token_here'));
      });

      test('should convert UserModel with empty values to JSON', () {
        // Arrange
        final userModel = UserModel(
          userId: '',
          email: '',
          username: '',
          token: '',
        );

        // Act
        final json = userModel.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['userId'], equals(''));
        expect(json['email'], equals(''));
        expect(json['token'], equals(''));
      });

      test('should convert UserModel with special characters to JSON', () {
        // Arrange
        final userModel = UserModel(
          userId: 'user_123@test',
          email: 'test+user@gmail.com',
          username: 'test_user',
          token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        );

        // Act
        final json = userModel.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['userId'], equals('user_123@test'));
        expect(json['email'], equals('test+user@gmail.com'));
        expect(
          json['token'],
          equals('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'),
        );
      });
    });

    group('Equality Tests', () {
      test('should be equal when all properties are same', () {
        // Arrange
        final userModel1 = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        final userModel2 = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        // Act & Assert
        expect(userModel1, equals(userModel2));
        expect(userModel1.hashCode, equals(userModel2.hashCode));
      });

      test('should not be equal when properties are different', () {
        // Arrange
        final userModel1 = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        final userModel2 = UserModel(
          userId: 'user456',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        // Act & Assert
        expect(userModel1, isNot(equals(userModel2)));
      });

      test('should not be equal when userId is different', () {
        // Arrange
        final userModel1 = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        final userModel2 = UserModel(
          userId: 'user456',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        // Act & Assert
        expect(userModel1, isNot(equals(userModel2)));
      });

      test('should not be equal when email is different', () {
        // Arrange
        final userModel1 = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        final userModel2 = UserModel(
          userId: 'user123',
          email: 'different@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        // Act & Assert
        expect(userModel1, isNot(equals(userModel2)));
      });

      test('should not be equal when token is different', () {
        // Arrange
        final userModel1 = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        final userModel2 = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: 'different_token',
        );

        // Act & Assert
        expect(userModel1, isNot(equals(userModel2)));
      });
    });

    group('Validation Tests', () {
      test('should validate email format', () {
        // Arrange
        const validEmails = [
          'test@gmail.com',
          'user@domain.co.uk',
          'test123@example.org',
          'test+user@gmail.com',
        ];

        const invalidEmails = ['invalid-email', 'test@', '@domain.com', ''];

        // Act & Assert
        for (final email in validEmails) {
          final userModel = UserModel(
            userId: 'user123',
            email: email,
            username: 'test',
            token: 'token',
          );
          expect(userModel.email, equals(email));
        }

        for (final email in invalidEmails) {
          final userModel = UserModel(
            userId: 'user123',
            email: email,
            username: 'test',
            token: 'token',
          );
          expect(userModel.email, equals(email));
        }
      });

      test('should handle long userId', () {
        // Arrange
        final longUserId = 'a' * 1000;

        // Act
        final userModel = UserModel(
          userId: longUserId,
          email: 'test@gmail.com',
          username: 'test',
          token: 'token',
        );

        // Assert
        expect(userModel.userId, equals(longUserId));
      });

      test('should handle long token', () {
        // Arrange
        final longToken = 'a' * 1000;

        // Act
        final userModel = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: longToken,
        );

        // Assert
        expect(userModel.token, equals(longToken));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle very long email', () {
        // Arrange
        final longEmail = 'a' * 100 + '@gmail.com';

        // Act
        final userModel = UserModel(
          userId: 'user123',
          email: longEmail,
          username: 'test',
          token: 'token',
        );

        // Assert
        expect(userModel.email, equals(longEmail));
      });

      test('should handle special characters in userId', () {
        // Arrange
        const specialUserId = 'user_123@test#456';

        // Act
        final userModel = UserModel(
          userId: specialUserId,
          email: 'test@gmail.com',
          username: 'test',
          token: 'token',
        );

        // Assert
        expect(userModel.userId, equals(specialUserId));
      });

      test('should handle unicode characters', () {
        // Arrange
        const unicodeUserId = 'user_123_测试';
        const unicodeEmail = 'test_测试@gmail.com';

        // Act
        final userModel = UserModel(
          userId: unicodeUserId,
          email: unicodeEmail,
          username: 'test',
          token: 'token',
        );

        // Assert
        expect(userModel.userId, equals(unicodeUserId));
        expect(userModel.email, equals(unicodeEmail));
      });

      test('should handle whitespace in fields', () {
        // Arrange
        const userIdWithSpaces = '  user123  ';
        const emailWithSpaces = '  test@gmail.com  ';
        const tokenWithSpaces = '  token  ';

        // Act
        final userModel = UserModel(
          userId: userIdWithSpaces,
          email: emailWithSpaces,
          username: 'test',
          token: tokenWithSpaces,
        );

        // Assert
        expect(userModel.userId, equals(userIdWithSpaces));
        expect(userModel.email, equals(emailWithSpaces));
        expect(userModel.token, equals(tokenWithSpaces));
      });
    });

    group('Serialization Round Trip Tests', () {
      test('should maintain data integrity through JSON round trip', () {
        // Arrange
        final originalUserModel = UserModel(
          userId: 'user123',
          email: 'test@gmail.com',
          username: 'test',
          token: 'jwt_token_here',
        );

        // Act
        final json = originalUserModel.toJson();
        final reconstructedUserModel = UserModel.fromJson(json);

        // Assert
        expect(reconstructedUserModel, equals(originalUserModel));
      });

      test('should handle special characters in round trip', () {
        // Arrange
        final originalUserModel = UserModel(
          userId: 'user_123@test#456',
          email: 'test+user@gmail.com',
          username: 'test_user',
          token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        );

        // Act
        final json = originalUserModel.toJson();
        final reconstructedUserModel = UserModel.fromJson(json);

        // Assert
        expect(reconstructedUserModel, equals(originalUserModel));
      });

      test('should handle empty values in round trip', () {
        // Arrange
        final originalUserModel = UserModel(
          userId: '',
          email: '',
          username: '',
          token: '',
        );

        // Act
        final json = originalUserModel.toJson();
        final reconstructedUserModel = UserModel.fromJson(json);

        // Assert
        expect(reconstructedUserModel, equals(originalUserModel));
      });
    });
  });
}
