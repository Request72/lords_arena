import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/ingame/data/repositories/game_repository.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final GameRepository _gameRepository;
  StreamSubscription<Map<String, dynamic>>? _gameEventsSubscription;

  GameCubit({required GameRepository gameRepository})
    : _gameRepository = gameRepository,
      super(GameInitial());

  // Game Session Management
  Future<void> createGameSession({
    required String gameMode,
    required String selectedWeapon,
    required String selectedCharacter,
  }) async {
    emit(GameLoading());
    try {
      final sessionData = await _gameRepository.createGameSession(
        gameMode: gameMode,
        selectedWeapon: selectedWeapon,
        selectedCharacter: selectedCharacter,
      );

      if (sessionData != null) {
        emit(GameSessionCreated(sessionData));
        _subscribeToGameEvents();
      } else {
        emit(GameError('Failed to create game session'));
      }
    } catch (e) {
      emit(GameError('Error creating game session: $e'));
    }
  }

  Future<void> updateGameState(Map<String, dynamic> gameState) async {
    try {
      await _gameRepository.updateGameState(gameState);
      emit(GameStateUpdated(gameState));
    } catch (e) {
      emit(GameError('Error updating game state: $e'));
    }
  }

  Future<void> endGameSession(Map<String, dynamic> gameResult) async {
    try {
      await _gameRepository.endGameSession(gameResult);
      _unsubscribeFromGameEvents();
      emit(GameSessionEnded(gameResult));
    } catch (e) {
      emit(GameError('Error ending game session: $e'));
    }
  }

  // Multiplayer Features
  Future<void> getOtherPlayers() async {
    try {
      final players = await _gameRepository.getOtherPlayers();
      if (players != null) {
        emit(OtherPlayersUpdated(players));
      }
    } catch (e) {
      emit(GameError('Error getting other players: $e'));
    }
  }

  Future<void> sendPlayerAction(
    String action,
    Map<String, dynamic> actionData,
  ) async {
    try {
      await _gameRepository.sendPlayerAction(action, actionData);
      emit(PlayerActionSent(action, actionData));
    } catch (e) {
      emit(GameError('Error sending player action: $e'));
    }
  }

  Future<void> sendPlayerMovement(double x, double y) async {
    try {
      await _gameRepository.sendPlayerMovement(x, y);
    } catch (e) {
      emit(GameError('Error sending player movement: $e'));
    }
  }

  // Statistics and Leaderboards
  Future<void> getLeaderboard({String? gameMode}) async {
    emit(GameLoading());
    try {
      final leaderboard = await _gameRepository.getLeaderboard(
        gameMode: gameMode,
      );
      if (leaderboard != null) {
        emit(LeaderboardLoaded(leaderboard));
      } else {
        emit(GameError('Failed to load leaderboard'));
      }
    } catch (e) {
      emit(GameError('Error loading leaderboard: $e'));
    }
  }

  Future<void> getUserStats() async {
    emit(GameLoading());
    try {
      final stats = await _gameRepository.getUserStats();
      if (stats != null) {
        emit(UserStatsLoaded(stats));
      } else {
        emit(GameError('Failed to load user stats'));
      }
    } catch (e) {
      emit(GameError('Error loading user stats: $e'));
    }
  }

  // Unlocks and Progression
  Future<void> getUnlockedWeapons() async {
    try {
      final weapons = await _gameRepository.getUnlockedWeapons();
      if (weapons != null) {
        emit(UnlockedWeaponsLoaded(weapons));
      }
    } catch (e) {
      emit(GameError('Error loading unlocked weapons: $e'));
    }
  }

  Future<void> getUnlockedCharacters() async {
    try {
      final characters = await _gameRepository.getUnlockedCharacters();
      if (characters != null) {
        emit(UnlockedCharactersLoaded(characters));
      }
    } catch (e) {
      emit(GameError('Error loading unlocked characters: $e'));
    }
  }

  Future<void> unlockWeapon(String weaponId) async {
    try {
      final success = await _gameRepository.unlockWeapon(weaponId);
      if (success) {
        emit(WeaponUnlocked(weaponId));
        // Refresh unlocked weapons
        await getUnlockedWeapons();
      } else {
        emit(GameError('Failed to unlock weapon'));
      }
    } catch (e) {
      emit(GameError('Error unlocking weapon: $e'));
    }
  }

  Future<void> unlockCharacter(String characterId) async {
    try {
      final success = await _gameRepository.unlockCharacter(characterId);
      if (success) {
        emit(CharacterUnlocked(characterId));
        // Refresh unlocked characters
        await getUnlockedCharacters();
      } else {
        emit(GameError('Failed to unlock character'));
      }
    } catch (e) {
      emit(GameError('Error unlocking character: $e'));
    }
  }

  // Real-time Game Events
  void _subscribeToGameEvents() {
    _gameEventsSubscription = _gameRepository.subscribeToGameEvents().listen(
      (event) {
        emit(GameEventReceived(event));
      },
      onError: (error) {
        emit(GameError('Error in game events: $error'));
      },
    );
  }

  void _unsubscribeFromGameEvents() {
    _gameEventsSubscription?.cancel();
    _gameEventsSubscription = null;
  }

  @override
  Future<void> close() {
    _unsubscribeFromGameEvents();
    return super.close();
  }
}
