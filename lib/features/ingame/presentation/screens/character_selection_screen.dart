import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:lords_arena/core/services/audio_service.dart';
import 'ingame_screen.dart';

class CharacterSelectionScreen extends StatelessWidget {
  const CharacterSelectionScreen({super.key});

  void _selectCharacter(BuildContext context, String imagePath) async {
    // Play selection sound and vibrate
    if (await AudioService.isSoundEffectsEnabled()) {
      try {
        await FlameAudio.play('hit.wav');
      } catch (e) {
        // Ignore audio errors
      }
    }
    await AudioService.vibrate();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Select Game Mode',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text(
                    'Single Player vs AI',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Fight against AI enemies',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () async {
                    // Play selection sound
                    try {
                      await FlameAudio.play('hit.wav');
                    } catch (e) {
                      // Ignore audio errors
                    }

                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => InGameScreen(selectedCharacter: imagePath),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people, color: Colors.red),
                  title: const Text(
                    'Multiplayer',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Fight against another player',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () async {
                    // Play selection sound and vibrate
                    if (await AudioService.isSoundEffectsEnabled()) {
                      try {
                        await FlameAudio.play('hit.wav');
                      } catch (e) {
                        // Ignore audio errors
                      }
                    }
                    await AudioService.vibrate();

                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => InGameScreen(
                              selectedCharacter: imagePath,
                              isMultiplayer: true,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characters = {
      'KP': 'assets/images/kp.png',
      'Sher': 'assets/images/sher.png',
      'Prachanda': 'assets/images/prachanda.png',
    };

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Choose Your Hero'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/warzone.jpg', fit: BoxFit.cover),
          ),
          Container(color: const Color.fromRGBO(0, 0, 0, 0.75)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Select Your Fighter',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      characters.entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _selectCharacter(context, entry.value),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.amber,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    entry.value,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.key,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
