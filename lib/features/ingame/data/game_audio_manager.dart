import 'package:lords_arena/core/services/audio_service.dart';

class GameAudioManager {
  static GameAudioManager? _instance;
  static GameAudioManager get instance => _instance ??= GameAudioManager._();

  GameAudioManager._();

  Future<void> initialize() async {
    await AudioService.initialize();
  }

  Future<void> playShootSound() async {
    await AudioService.playSoundEffect('assets/audio/shoot.wav');
    await AudioService.vibrate();
  }

  Future<void> playHitSound() async {
    await AudioService.playSoundEffect('assets/audio/hit.wav');
    await AudioService.vibrateHeavy();
  }

  Future<void> playExplosionSound() async {
    await AudioService.playSoundEffect('assets/audio/explosion.wav');
    await AudioService.vibratePattern([0, 300, 100, 300]);
  }

  Future<void> playBackgroundMusic() async {
    await AudioService.playBackgroundMusic();
  }

  Future<void> stopBackgroundMusic() async {
    await AudioService.stopBackgroundMusic();
  }

  Future<void> vibrateSuccess() async {
    await AudioService.vibrateSuccess();
  }

  Future<void> vibrateError() async {
    await AudioService.vibrateError();
  }

  Future<void> vibrateGameOver() async {
    await AudioService.vibrateGameOver();
  }

  Future<void> dispose() async {
    await AudioService.dispose();
  }
}
