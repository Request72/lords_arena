part of 'game_cubit.dart';

abstract class GameState {
  const GameState();
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameSessionCreated extends GameState {
  final Map<String, dynamic> sessionData;
  const GameSessionCreated(this.sessionData);
}

class GameStateUpdated extends GameState {
  final Map<String, dynamic> gameState;
  const GameStateUpdated(this.gameState);
}

class GameSessionEnded extends GameState {
  final Map<String, dynamic> gameResult;
  const GameSessionEnded(this.gameResult);
}

class OtherPlayersUpdated extends GameState {
  final List<Map<String, dynamic>> players;
  const OtherPlayersUpdated(this.players);
}

class PlayerActionSent extends GameState {
  final String action;
  final Map<String, dynamic> actionData;
  const PlayerActionSent(this.action, this.actionData);
}

class LeaderboardLoaded extends GameState {
  final List<Map<String, dynamic>> leaderboard;
  const LeaderboardLoaded(this.leaderboard);
}

class UserStatsLoaded extends GameState {
  final Map<String, dynamic> stats;
  const UserStatsLoaded(this.stats);
}

class UnlockedWeaponsLoaded extends GameState {
  final List<Map<String, dynamic>> weapons;
  const UnlockedWeaponsLoaded(this.weapons);
}

class UnlockedCharactersLoaded extends GameState {
  final List<Map<String, dynamic>> characters;
  const UnlockedCharactersLoaded(this.characters);
}

class WeaponUnlocked extends GameState {
  final String weaponId;
  const WeaponUnlocked(this.weaponId);
}

class CharacterUnlocked extends GameState {
  final String characterId;
  const CharacterUnlocked(this.characterId);
}

class GameEventReceived extends GameState {
  final Map<String, dynamic> event;
  const GameEventReceived(this.event);
}

class GameError extends GameState {
  final String message;
  const GameError(this.message);
}
