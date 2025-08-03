import 'package:shared_preferences/shared_preferences.dart';

class StatsService {
  static const String _gamesPlayedKey = 'games_played';
  static const String _gamesWonKey = 'games_won';
  static const String _totalKillsKey = 'total_kills';
  static const String _totalDeathsKey = 'total_deaths';
  static const String _bestScoreKey = 'best_score';
  static const String _playTimeKey = 'play_time';
  static const String _achievementsKey = 'achievements';

  static Future<void> incrementGamesPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_gamesPlayedKey) ?? 0;
    await prefs.setInt(_gamesPlayedKey, current + 1);
  }

  static Future<void> incrementGamesWon() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_gamesWonKey) ?? 0;
    await prefs.setInt(_gamesWonKey, current + 1);
  }

  static Future<void> addKills(int kills) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_totalKillsKey) ?? 0;
    await prefs.setInt(_totalKillsKey, current + kills);
  }

  static Future<void> addDeaths(int deaths) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_totalDeathsKey) ?? 0;
    await prefs.setInt(_totalDeathsKey, current + deaths);
  }

  static Future<void> updateBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_bestScoreKey) ?? 0;
    if (score > current) {
      await prefs.setInt(_bestScoreKey, score);
    }
  }

  static Future<void> addPlayTime(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_playTimeKey) ?? 0;
    await prefs.setInt(_playTimeKey, current + seconds);
  }

  static Future<void> unlockAchievement(String achievementId) async {
    final prefs = await SharedPreferences.getInstance();
    final achievements = prefs.getStringList(_achievementsKey) ?? [];
    if (!achievements.contains(achievementId)) {
      achievements.add(achievementId);
      await prefs.setStringList(_achievementsKey, achievements);
    }
  }

  static Future<Map<String, dynamic>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final gamesPlayed = prefs.getInt(_gamesPlayedKey) ?? 0;
    final gamesWon = prefs.getInt(_gamesWonKey) ?? 0;
    final totalKills = prefs.getInt(_totalKillsKey) ?? 0;
    final totalDeaths = prefs.getInt(_totalDeathsKey) ?? 0;
    final bestScore = prefs.getInt(_bestScoreKey) ?? 0;
    final playTime = prefs.getInt(_playTimeKey) ?? 0;
    final achievements = prefs.getStringList(_achievementsKey) ?? [];

    final winRate =
        gamesPlayed > 0 ? (gamesWon / gamesPlayed * 100).round() : 0;
    final kdr =
        totalDeaths > 0
            ? (totalKills / totalDeaths).toStringAsFixed(2)
            : totalKills.toString();

    return {
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'winRate': winRate,
      'totalKills': totalKills,
      'totalDeaths': totalDeaths,
      'kdr': kdr,
      'bestScore': bestScore,
      'playTime': playTime,
      'achievements': achievements,
    };
  }

  static Future<void> resetStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gamesPlayedKey);
    await prefs.remove(_gamesWonKey);
    await prefs.remove(_totalKillsKey);
    await prefs.remove(_totalDeathsKey);
    await prefs.remove(_bestScoreKey);
    await prefs.remove(_playTimeKey);
    await prefs.remove(_achievementsKey);
  }
}
