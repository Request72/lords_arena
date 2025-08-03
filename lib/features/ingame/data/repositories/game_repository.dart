import 'package:lords_arena/features/ingame/data/game_api_service.dart';
import 'package:lords_arena/features/ingame/data/player_api_service.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';

abstract class GameRepository {
  // Game Session Management
  Future<Map<String, dynamic>?> createGameSession({
    required String gameMode,
    required String selectedWeapon,
    required String selectedCharacter,
  });

  Future<void> updateGameState(Map<String, dynamic> gameState);
  Future<void> endGameSession(Map<String, dynamic> gameResult);

  // Multiplayer Features
  Future<List<Map<String, dynamic>>?> getOtherPlayers();
  Future<void> sendPlayerAction(String action, Map<String, dynamic> actionData);
  Stream<Map<String, dynamic>> subscribeToGameEvents();

  // Statistics and Leaderboards
  Future<List<Map<String, dynamic>>?> getLeaderboard({String? gameMode});
  Future<Map<String, dynamic>?> getUserStats();

  // Unlocks and Progression
  Future<List<Map<String, dynamic>>?> getUnlockedWeapons();
  Future<List<Map<String, dynamic>>?> getUnlockedCharacters();
  Future<bool> unlockWeapon(String weaponId);
  Future<bool> unlockCharacter(String characterId);

  // Player Movement
  Future<void> sendPlayerMovement(double x, double y);
}

class GameRepositoryImpl implements GameRepository {
  final GameApiService _gameApiService;
  final PlayerApiService _playerApiService;
  final UserRepository _userRepository;

  String? _currentSessionId;
  String? _currentUserId;

  GameRepositoryImpl({
    required GameApiService gameApiService,
    required PlayerApiService playerApiService,
    required UserRepository userRepository,
  }) : _gameApiService = gameApiService,
       _playerApiService = playerApiService,
       _userRepository = userRepository;

  String? get currentSessionId => _currentSessionId;
  String? get currentUserId => _currentUserId;

  @override
  Future<Map<String, dynamic>?> createGameSession({
    required String gameMode,
    required String selectedWeapon,
    required String selectedCharacter,
  }) async {
    final userId = _userRepository.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    _currentUserId = userId;

    final sessionData = await _gameApiService.createGameSession(
      userId: userId,
      gameMode: gameMode,
      selectedWeapon: selectedWeapon,
      selectedCharacter: selectedCharacter,
    );

    if (sessionData != null) {
      _currentSessionId = sessionData['sessionId'];
    }

    return sessionData;
  }

  @override
  Future<void> updateGameState(Map<String, dynamic> gameState) async {
    if (_currentSessionId == null || _currentUserId == null) {
      throw Exception('No active game session');
    }

    await _gameApiService.updateGameState(
      sessionId: _currentSessionId!,
      userId: _currentUserId!,
      gameState: gameState,
    );
  }

  @override
  Future<void> endGameSession(Map<String, dynamic> gameResult) async {
    if (_currentSessionId == null || _currentUserId == null) {
      throw Exception('No active game session');
    }

    await _gameApiService.saveGameResult(
      sessionId: _currentSessionId!,
      userId: _currentUserId!,
      gameResult: gameResult,
    );

    // Clear session data
    _currentSessionId = null;
  }

  @override
  Future<List<Map<String, dynamic>>?> getOtherPlayers() async {
    if (_currentSessionId == null || _currentUserId == null) {
      return null;
    }

    return await _gameApiService.getOtherPlayers(
      sessionId: _currentSessionId!,
      currentUserId: _currentUserId!,
    );
  }

  @override
  Future<void> sendPlayerAction(
    String action,
    Map<String, dynamic> actionData,
  ) async {
    if (_currentSessionId == null || _currentUserId == null) {
      throw Exception('No active game session');
    }

    await _gameApiService.sendPlayerAction(
      sessionId: _currentSessionId!,
      userId: _currentUserId!,
      action: action,
      actionData: actionData,
    );
  }

  @override
  Stream<Map<String, dynamic>> subscribeToGameEvents() {
    if (_currentSessionId == null) {
      return Stream.empty();
    }

    return _gameApiService.subscribeToGameEvents(_currentSessionId!);
  }

  @override
  Future<List<Map<String, dynamic>>?> getLeaderboard({String? gameMode}) async {
    return await _gameApiService.getLeaderboard(gameMode: gameMode);
  }

  @override
  Future<Map<String, dynamic>?> getUserStats() async {
    final userId = _userRepository.getUserId();
    if (userId == null) {
      return null;
    }

    return await _gameApiService.getUserStats(userId);
  }

  @override
  Future<List<Map<String, dynamic>>?> getUnlockedWeapons() async {
    final userId = _userRepository.getUserId();
    if (userId == null) {
      return null;
    }

    return await _gameApiService.getUnlockedWeapons(userId);
  }

  @override
  Future<List<Map<String, dynamic>>?> getUnlockedCharacters() async {
    final userId = _userRepository.getUserId();
    if (userId == null) {
      return null;
    }

    return await _gameApiService.getUnlockedCharacters(userId);
  }

  @override
  Future<bool> unlockWeapon(String weaponId) async {
    final userId = _userRepository.getUserId();
    if (userId == null) {
      return false;
    }

    return await _gameApiService.unlockWeapon(userId, weaponId);
  }

  @override
  Future<bool> unlockCharacter(String characterId) async {
    final userId = _userRepository.getUserId();
    if (userId == null) {
      return false;
    }

    return await _gameApiService.unlockCharacter(userId, characterId);
  }

  // Helper method to send player movement
  @override
  Future<void> sendPlayerMovement(double x, double y) async {
    final userId = _userRepository.getUserId();
    if (userId == null) {
      return;
    }

    await _playerApiService.sendPlayerMovement(userId, x, y);
  }
}
