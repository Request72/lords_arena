import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/ingame/presentation/cubit/game_cubit.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String? selectedGameMode;

  @override
  void initState() {
    super.initState();
    // Load leaderboard on screen initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameCubit>().getLeaderboard(gameMode: selectedGameMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Leaderboard',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Game Mode Filter
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Game Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterButton(
                            'All Modes',
                            selectedGameMode == null,
                            () => _filterByGameMode(null),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFilterButton(
                            'Multiplayer',
                            selectedGameMode == 'multiplayer',
                            () => _filterByGameMode('multiplayer'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFilterButton(
                            'Single Player',
                            selectedGameMode == 'single_player',
                            () => _filterByGameMode('single_player'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Leaderboard List
              Expanded(
                child: BlocBuilder<GameCubit, GameState>(
                  builder: (context, state) {
                    if (state is GameLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (state is LeaderboardLoaded) {
                      return _buildLeaderboardList(state.leaderboard);
                    } else if (state is GameError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading leaderboard',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed:
                                  () =>
                                      context.read<GameCubit>().getLeaderboard(
                                        gameMode: selectedGameMode,
                                      ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No leaderboard data available',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? Colors.orange
                    : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color:
                isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardList(List<Map<String, dynamic>> leaderboard) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          final player = leaderboard[index];
          final rank = index + 1;
          final username = player['username'] ?? 'Unknown Player';
          final kills = player['totalKills'] ?? 0;
          final wins = player['totalWins'] ?? 0;
          final gamesPlayed = player['gamesPlayed'] ?? 0;
          final winRate =
              gamesPlayed > 0
                  ? (wins / gamesPlayed * 100).toStringAsFixed(1)
                  : '0.0';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getRankColor(rank).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getRankColor(rank),
                width: rank <= 3 ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Rank Badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getRankColor(rank),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      rank.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Player Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatChip('Kills', kills.toString()),
                          const SizedBox(width: 8),
                          _buildStatChip('Wins', wins.toString()),
                          const SizedBox(width: 8),
                          _buildStatChip('Win Rate', '$winRate%'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trophy Icon for top 3
                if (rank <= 3)
                  Icon(
                    _getTrophyIcon(rank),
                    color: _getRankColor(rank),
                    size: 24,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey; // Silver
      case 3:
        return Colors.orange; // Bronze
      default:
        return Colors.white.withValues(alpha: 0.5);
    }
  }

  IconData _getTrophyIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events; // Trophy
      case 2:
        return Icons.workspace_premium; // Premium
      case 3:
        return Icons.star; // Star
      default:
        return Icons.person;
    }
  }

  void _filterByGameMode(String? gameMode) {
    setState(() {
      selectedGameMode = gameMode;
    });
    context.read<GameCubit>().getLeaderboard(gameMode: gameMode);
  }
}
