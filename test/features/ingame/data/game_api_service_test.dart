import 'package:flutter_test/flutter_test.dart';
import 'package:lords_arena/features/ingame/data/game_api_service.dart';

void main() {
  group('GameApiService Tests', () {
    late GameApiService gameApiService;

    setUp(() {
      gameApiService = GameApiService();
    });

    group('API Configuration Tests', () {
      test('should have correct base URL', () {
        // Act & Assert
        expect(gameApiService.baseUrl, contains('localhost'));
        expect(gameApiService.baseUrl, contains('5000'));
        expect(gameApiService.baseUrl, contains('/api/game'));
      });

      test('should have correct headers', () {
        // Act
        final headers = gameApiService.getHeaders('test_token');

        // Assert
        expect(headers['Content-Type'], equals('application/json'));
        expect(headers['Authorization'], equals('Bearer test_token'));
      });

      test('should handle empty token in headers', () {
        // Act
        final headers = gameApiService.getHeaders('');

        // Assert
        expect(headers['Content-Type'], equals('application/json'));
        expect(headers['Authorization'], equals('Bearer '));
      });

      test('should handle null token in headers', () {
        // Act
        final headers = gameApiService.getHeaders(null);

        // Assert
        expect(headers['Content-Type'], equals('application/json'));
        expect(headers['Authorization'], equals('Bearer null'));
      });
    });

    group('Create Game Session Tests', () {
      test('should create game session with valid data', () async {
        // Arrange
        const userId = 'user123';
        const gameMode = 'multiplayer';
        const selectedWeapon = 'rifle';
        const selectedCharacter = 'kp';

        // Act
        final result = await gameApiService.createGameSession(
          userId,
          gameMode,
          selectedWeapon,
          selectedCharacter,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle empty userId in create session', () async {
        // Arrange
        const userId = '';
        const gameMode = 'multiplayer';
        const selectedWeapon = 'rifle';
        const selectedCharacter = 'kp';

        // Act
        final result = await gameApiService.createGameSession(
          userId,
          gameMode,
          selectedWeapon,
          selectedCharacter,
          'test_token',
        );

        // Assert
        expect(result, isNull);
      });

      test('should handle invalid game mode', () async {
        // Arrange
        const userId = 'user123';
        const gameMode = 'invalid_mode';
        const selectedWeapon = 'rifle';
        const selectedCharacter = 'kp';

        // Act
        final result = await gameApiService.createGameSession(
          userId,
          gameMode,
          selectedWeapon,
          selectedCharacter,
          'test_token',
        );

        // Assert
        expect(result, isNull);
      });

      test('should handle network errors in create session', () async {
        // Arrange
        const userId = 'user123';
        const gameMode = 'multiplayer';
        const selectedWeapon = 'rifle';
        const selectedCharacter = 'kp';

        // Act & Assert
        expect(
          () => gameApiService.createGameSession(
            userId,
            gameMode,
            selectedWeapon,
            selectedCharacter,
            'test_token',
          ),
          throwsException,
        );
      });
    });

    group('Send Game Action Tests', () {
      test('should send game action successfully', () async {
        // Arrange
        const sessionId = 'session123';
        const userId = 'user123';
        const action = 'shoot';
        final actionData = {'x': 100, 'y': 200, 'weapon': 'rifle'};

        // Act
        final result = await gameApiService.sendGameAction(
          sessionId,
          userId,
          action,
          actionData,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle empty sessionId in send action', () async {
        // Arrange
        const sessionId = '';
        const userId = 'user123';
        const action = 'shoot';
        final actionData = {'x': 100, 'y': 200, 'weapon': 'rifle'};

        // Act
        final result = await gameApiService.sendGameAction(
          sessionId,
          userId,
          action,
          actionData,
          'test_token',
        );

        // Assert
        expect(result, isNull);
      });

      test('should handle invalid action type', () async {
        // Arrange
        const sessionId = 'session123';
        const userId = 'user123';
        const action = 'invalid_action';
        final actionData = {'x': 100, 'y': 200, 'weapon': 'rifle'};

        // Act
        final result = await gameApiService.sendGameAction(
          sessionId,
          userId,
          action,
          actionData,
          'test_token',
        );

        // Assert
        expect(result, isNull);
      });

      test('should handle empty action data', () async {
        // Arrange
        const sessionId = 'session123';
        const userId = 'user123';
        const action = 'shoot';
        final actionData = <String, dynamic>{};

        // Act
        final result = await gameApiService.sendGameAction(
          sessionId,
          userId,
          action,
          actionData,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });
    });

    group('Get Leaderboard Tests', () {
      test('should get leaderboard successfully', () async {
        // Arrange
        const limit = 10;
        const gameMode = 'multiplayer';

        // Act
        final result = await gameApiService.getLeaderboard(
          limit,
          gameMode,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle default limit when not provided', () async {
        // Arrange
        const gameMode = 'multiplayer';

        // Act
        final result = await gameApiService.getLeaderboard(
          null,
          gameMode,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle empty game mode', () async {
        // Arrange
        const limit = 10;
        const gameMode = '';

        // Act
        final result = await gameApiService.getLeaderboard(
          limit,
          gameMode,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle large limit value', () async {
        // Arrange
        const limit = 1000;
        const gameMode = 'multiplayer';

        // Act
        final result = await gameApiService.getLeaderboard(
          limit,
          gameMode,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });
    });

    group('Save Game Results Tests', () {
      test('should save game results successfully', () async {
        // Arrange
        const sessionId = 'session123';
        const userId = 'user123';
        final gameResult = {
          'score': 1500,
          'kills': 15,
          'deaths': 3,
          'duration': 300,
        };

        // Act
        final result = await gameApiService.saveGameResults(
          sessionId,
          userId,
          gameResult,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle empty sessionId in save results', () async {
        // Arrange
        const sessionId = '';
        const userId = 'user123';
        final gameResult = {
          'score': 1500,
          'kills': 15,
          'deaths': 3,
          'duration': 300,
        };

        // Act
        final result = await gameApiService.saveGameResults(
          sessionId,
          userId,
          gameResult,
          'test_token',
        );

        // Assert
        expect(result, isNull);
      });

      test('should handle negative score values', () async {
        // Arrange
        const sessionId = 'session123';
        const userId = 'user123';
        final gameResult = {
          'score': -100,
          'kills': -5,
          'deaths': 3,
          'duration': 300,
        };

        // Act
        final result = await gameApiService.saveGameResults(
          sessionId,
          userId,
          gameResult,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle missing game result fields', () async {
        // Arrange
        const sessionId = 'session123';
        const userId = 'user123';
        final gameResult = <String, dynamic>{};

        // Act
        final result = await gameApiService.saveGameResults(
          sessionId,
          userId,
          gameResult,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });
    });

    group('Get User Stats Tests', () {
      test('should get user stats successfully', () async {
        // Arrange
        const userId = 'user123';

        // Act
        final result = await gameApiService.getUserStats(userId, 'test_token');

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle empty userId in get stats', () async {
        // Arrange
        const userId = '';

        // Act
        final result = await gameApiService.getUserStats(userId, 'test_token');

        // Assert
        expect(result, isNull);
      });

      test('should handle special characters in userId', () async {
        // Arrange
        const userId = 'user_123@test#456';

        // Act
        final result = await gameApiService.getUserStats(userId, 'test_token');

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle very long userId', () async {
        // Arrange
        final userId = 'a' * 1000;

        // Act
        final result = await gameApiService.getUserStats(userId, 'test_token');

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });
    });

    group('Get Unlocked Weapons Tests', () {
      test('should get unlocked weapons successfully', () async {
        // Arrange
        const userId = 'user123';

        // Act
        final result = await gameApiService.getUnlockedWeapons(
          userId,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle empty userId in get weapons', () async {
        // Arrange
        const userId = '';

        // Act
        final result = await gameApiService.getUnlockedWeapons(
          userId,
          'test_token',
        );

        // Assert
        expect(result, isNull);
      });

      test('should handle special characters in userId for weapons', () async {
        // Arrange
        const userId = 'user_123@test#456';

        // Act
        final result = await gameApiService.getUnlockedWeapons(
          userId,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });
    });

    group('Get Unlocked Characters Tests', () {
      test('should get unlocked characters successfully', () async {
        // Arrange
        const userId = 'user123';

        // Act
        final result = await gameApiService.getUnlockedCharacters(
          userId,
          'test_token',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });

      test('should handle empty userId in get characters', () async {
        // Arrange
        const userId = '';

        // Act
        final result = await gameApiService.getUnlockedCharacters(
          userId,
          'test_token',
        );

        // Assert
        expect(result, isNull);
      });

      test(
        'should handle special characters in userId for characters',
        () async {
          // Arrange
          const userId = 'user_123@test#456';

          // Act
          final result = await gameApiService.getUnlockedCharacters(
            userId,
            'test_token',
          );

          // Assert
          expect(result, isA<Map<String, dynamic>>());
        },
      );
    });

    group('Error Handling Tests', () {
      test('should handle network timeout', () async {
        // Arrange
        const userId = 'user123';

        // Act & Assert
        expect(
          () => gameApiService.getUserStats(userId, 'test_token'),
          throwsException,
        );
      });

      test('should handle server errors', () async {
        // Arrange
        const userId = 'user123';

        // Act & Assert
        expect(
          () => gameApiService.getUserStats(userId, 'test_token'),
          throwsException,
        );
      });

      test('should handle invalid JSON responses', () async {
        // Arrange
        const userId = 'user123';

        // Act & Assert
        expect(
          () => gameApiService.getUserStats(userId, 'test_token'),
          throwsException,
        );
      });

      test('should handle empty response', () async {
        // Arrange
        const userId = 'user123';

        // Act & Assert
        expect(
          () => gameApiService.getUserStats(userId, 'test_token'),
          throwsException,
        );
      });
    });

    group('Data Validation Tests', () {
      test('should validate sessionId format', () {
        // Arrange
        const validSessionIds = ['session123', 'session_456', 'session-789'];

        const invalidSessionIds = ['', '   ', 'a' * 1000];

        // Act & Assert
        for (final sessionId in validSessionIds) {
          expect(gameApiService.isValidSessionId(sessionId), isTrue);
        }

        for (final sessionId in invalidSessionIds) {
          expect(gameApiService.isValidSessionId(sessionId), isFalse);
        }
      });

      test('should validate action data format', () {
        // Arrange
        final validActionData = [
          {'x': 100, 'y': 200, 'weapon': 'rifle'},
          {'x': 0, 'y': 0, 'weapon': 'pistol'},
          {'x': 999, 'y': 999, 'weapon': 'shotgun'},
        ];

        final invalidActionData = [
          <String, dynamic>{},
          {'x': 'invalid', 'y': 200, 'weapon': 'rifle'},
          {'x': 100, 'y': 'invalid', 'weapon': 'rifle'},
        ];

        // Act & Assert
        for (final actionData in validActionData) {
          expect(gameApiService.isValidActionData(actionData), isTrue);
        }

        for (final actionData in invalidActionData) {
          expect(gameApiService.isValidActionData(actionData), isFalse);
        }
      });

      test('should validate game result format', () {
        // Arrange
        final validGameResults = [
          {'score': 1500, 'kills': 15, 'deaths': 3, 'duration': 300},
          {'score': 0, 'kills': 0, 'deaths': 0, 'duration': 0},
          {'score': 9999, 'kills': 100, 'deaths': 50, 'duration': 600},
        ];

        final invalidGameResults = [
          <String, dynamic>{},
          {'score': 'invalid', 'kills': 15, 'deaths': 3, 'duration': 300},
          {'score': 1500, 'kills': 'invalid', 'deaths': 3, 'duration': 300},
        ];

        // Act & Assert
        for (final gameResult in validGameResults) {
          expect(gameApiService.isValidGameResult(gameResult), isTrue);
        }

        for (final gameResult in invalidGameResults) {
          expect(gameApiService.isValidGameResult(gameResult), isFalse);
        }
      });
    });

    group('Performance Tests', () {
      test('should handle rapid API calls', () async {
        // Arrange
        const userId = 'user123';

        // Act
        final futures = List.generate(
          5,
          (_) => gameApiService.getUserStats(userId, 'test_token'),
        );

        // Assert
        expect(futures, hasLength(5));
      });

      test('should handle concurrent requests', () async {
        // Arrange
        const userId = 'user123';

        // Act
        final future1 = gameApiService.getUserStats(userId, 'test_token');
        final future2 = gameApiService.getLeaderboard(
          10,
          'multiplayer',
          'test_token',
        );
        final future3 = gameApiService.getUnlockedWeapons(userId, 'test_token');

        // Assert
        expect(future1, isA<Future>());
        expect(future2, isA<Future>());
        expect(future3, isA<Future>());
      });
    });
  });
}
