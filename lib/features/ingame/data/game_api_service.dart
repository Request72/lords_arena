import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class GameApiService {
  late final String baseUrl;

  GameApiService() {
    if (kIsWeb) {
      baseUrl = 'http://localhost:5000/api/game';
    } else if (Platform.isAndroid) {
      baseUrl = 'http://localhost:5000/api/game';
    } else {
      baseUrl = 'http://localhost:5000/api/game';
    }
  }

  // Game Session Management
  Future<Map<String, dynamic>?> createGameSession({
    required String userId,
    required String gameMode,
    required String selectedWeapon,
    required String selectedCharacter,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/session/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'gameMode': gameMode,
          'selectedWeapon': selectedWeapon,
          'selectedCharacter': selectedCharacter,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        logger.i('✅ Game session created: ${data['sessionId']}');
        return data;
      } else {
        logger.w('⚠️ Failed to create game session: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('❌ Error creating game session: $e');
      return null;
    }
  }

  Future<void> updateGameState({
    required String sessionId,
    required String userId,
    required Map<String, dynamic> gameState,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/session/$sessionId/state'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'gameState': gameState,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        logger.i('✅ Game state updated successfully');
      } else {
        logger.w('⚠️ Failed to update game state: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('❌ Error updating game state: $e');
    }
  }

  // Multiplayer Synchronization
  Future<List<Map<String, dynamic>>?> getOtherPlayers({
    required String sessionId,
    required String currentUserId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/session/$sessionId/players?exclude=$currentUserId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['players']);
      } else {
        logger.w('⚠️ Failed to get other players: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('❌ Error getting other players: $e');
      return null;
    }
  }

  Future<void> sendPlayerAction({
    required String sessionId,
    required String userId,
    required String action,
    required Map<String, dynamic> actionData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/session/$sessionId/action'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'action': action,
          'actionData': actionData,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        logger.i('✅ Player action sent: $action');
      } else {
        logger.w('⚠️ Failed to send player action: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('❌ Error sending player action: $e');
    }
  }

  // Game Results and Statistics
  Future<void> saveGameResult({
    required String sessionId,
    required String userId,
    required Map<String, dynamic> gameResult,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/results'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sessionId': sessionId,
          'userId': userId,
          'gameResult': gameResult,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        logger.i('✅ Game result saved successfully');
      } else {
        logger.w('⚠️ Failed to save game result: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('❌ Error saving game result: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getLeaderboard({
    String? gameMode,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{'limit': limit.toString()};
      if (gameMode != null) {
        queryParams['gameMode'] = gameMode;
      }

      final uri = Uri.parse(
        '$baseUrl/leaderboard',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['leaderboard']);
      } else {
        logger.w('⚠️ Failed to get leaderboard: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('❌ Error getting leaderboard: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserStats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i('✅ User stats retrieved successfully');
        return data;
      } else {
        logger.w('⚠️ Failed to get user stats: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('❌ Error getting user stats: $e');
      return null;
    }
  }

  // Weapon and Character Unlocks
  Future<List<Map<String, dynamic>>?> getUnlockedWeapons(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/unlocks/$userId/weapons'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['weapons']);
      } else {
        logger.w('⚠️ Failed to get unlocked weapons: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('❌ Error getting unlocked weapons: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getUnlockedCharacters(
    String userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/unlocks/$userId/characters'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['characters']);
      } else {
        logger.w(
          '⚠️ Failed to get unlocked characters: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      logger.e('❌ Error getting unlocked characters: $e');
      return null;
    }
  }

  Future<bool> unlockWeapon(String userId, String weaponId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/unlocks/$userId/weapons'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'weaponId': weaponId}),
      );

      if (response.statusCode == 200) {
        logger.i('✅ Weapon unlocked successfully: $weaponId');
        return true;
      } else {
        logger.w('⚠️ Failed to unlock weapon: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.e('❌ Error unlocking weapon: $e');
      return false;
    }
  }

  Future<bool> unlockCharacter(String userId, String characterId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/unlocks/$userId/characters'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'characterId': characterId}),
      );

      if (response.statusCode == 200) {
        logger.i('✅ Character unlocked successfully: $characterId');
        return true;
      } else {
        logger.w('⚠️ Failed to unlock character: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.e('❌ Error unlocking character: $e');
      return false;
    }
  }

  // Real-time Game Events
  Stream<Map<String, dynamic>> subscribeToGameEvents(String sessionId) {
    // This would typically use WebSocket or Server-Sent Events
    // For now, we'll simulate with polling
    return Stream.periodic(const Duration(milliseconds: 100), (_) async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/session/$sessionId/events'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data as Map<String, dynamic>;
        } else {
          return <String, dynamic>{};
        }
      } catch (e) {
        logger.e('❌ Error getting game events: $e');
        return <String, dynamic>{};
      }
    }).asyncMap((event) => event);
  }
}
