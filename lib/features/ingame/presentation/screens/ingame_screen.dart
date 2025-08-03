import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/core/service_locator/service_locator.dart';
import 'package:lords_arena/features/ingame/game/lords_arena_game.dart';
import 'package:lords_arena/features/ingame/presentation/cubit/game_cubit.dart';

class InGameScreen extends StatelessWidget {
  final String selectedCharacter;
  final bool isMultiplayer;

  const InGameScreen({
    super.key,
    required this.selectedCharacter,
    this.isMultiplayer = false,
  });

  @override
  Widget build(BuildContext context) {
    final game = LordsArenaGame(
      selectedCharacter: selectedCharacter,
      isMultiplayer: isMultiplayer,
    );

    return BlocProvider(
      create: (context) => sl<GameCubit>(),
      child: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            'GameOver': (_, _) => _buildGameOverOverlay(context, game),
            'GameFinished': (_, _) => _buildGameFinishedOverlay(context, game),
            'Paused': (_, _) => _buildPauseOverlay(context, game),
          },
          loadingBuilder:
              (context) => const Center(child: CircularProgressIndicator()),
          errorBuilder:
              (context, error) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay(BuildContext context, LordsArenaGame game) {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sports_esports, color: Colors.orange, size: 64),
              const SizedBox(height: 16),
              Text(
                game.isMultiplayer ? 'Round Over!' : 'Game Over!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (game.isMultiplayer) ...[
                Text(
                  'Player 1: ${game.player1Kills} kills',
                  style: const TextStyle(color: Colors.blue, fontSize: 18),
                ),
                Text(
                  'Player 2: ${game.player2Kills} kills',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('GameOver');
                    game.nextRound();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Next Round'),
                ),
              ] else ...[
                Text(
                  'Kills: ${game.player1Kills}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('GameOver');
                    game.reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Exit to Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameFinishedOverlay(BuildContext context, LordsArenaGame game) {
    final winner =
        game.player1Kills > game.player2Kills ? 'Player 1' : 'Player 2';

    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0.9),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Game Finished!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Winner: $winner',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Final Score:\nPlayer 1: ${game.player1Kills} | Player 2: ${game.player2Kills}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('GameFinished');
                  game.reset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Play Again'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Exit to Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay(BuildContext context, LordsArenaGame game) {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.pause_circle_outline,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Game Paused',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('Paused');
                  game.resumeEngine();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Resume'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
