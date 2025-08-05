import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  static const String _soundEffectsKey = 'sound_effects_enabled';
  static const String _backgroundMusicKey = 'background_music_enabled';
  static const String _vibrationKey = 'vibration_enabled';
  static const String _soundVolumeKey = 'sound_volume';
  static const String _musicVolumeKey = 'music_volume';
  static const String _vibrationIntensityKey = 'vibration_intensity';
  static const String _audioOptimizationKey = 'audio_optimization_enabled';
  static const String _lowLatencyKey = 'low_latency_enabled';

  static AudioPlayer? _backgroundPlayer;
  static AudioPlayer? _effectsPlayer;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    await _requestPermissions();
    await _configureAudioSession();

    _backgroundPlayer = AudioPlayer();
    _effectsPlayer = AudioPlayer();

    _isInitialized = true;
  }

  static Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  static Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.game,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ),
    );
  }

  static Future<bool> isSoundEffectsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEffectsKey) ?? true;
  }

  static Future<bool> isBackgroundMusicEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_backgroundMusicKey) ?? true;
  }

  static Future<bool> isVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vibrationKey) ?? true;
  }

  static Future<double> getSoundVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_soundVolumeKey) ?? 1.0;
  }

  static Future<double> getMusicVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_musicVolumeKey) ?? 1.0;
  }

  static Future<String> getVibrationIntensity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_vibrationIntensityKey) ?? 'medium';
  }

  static Future<bool> isAudioOptimizationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_audioOptimizationKey) ?? true;
  }

  static Future<bool> isLowLatencyEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_lowLatencyKey) ?? false;
  }

  static Future<void> setSoundEffectsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEffectsKey, enabled);
  }

  static Future<void> setBackgroundMusicEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backgroundMusicKey, enabled);
    if (!enabled && _backgroundPlayer != null) {
      await _backgroundPlayer!.stop();
    }
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationKey, enabled);
  }

  static Future<void> setSoundVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_soundVolumeKey, volume);
    if (_effectsPlayer != null) {
      await _effectsPlayer!.setVolume(volume);
    }
  }

  static Future<void> setMusicVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_musicVolumeKey, volume);
    if (_backgroundPlayer != null) {
      await _backgroundPlayer!.setVolume(volume);
    }
  }

  static Future<void> setVibrationIntensity(String intensity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vibrationIntensityKey, intensity);
  }

  static Future<void> setAudioOptimizationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_audioOptimizationKey, enabled);
  }

  static Future<void> setLowLatencyEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_lowLatencyKey, enabled);
  }

  static Future<void> playBackgroundMusic() async {
    if (!await isBackgroundMusicEnabled()) return;

    try {
      await initialize();
      final volume = await getMusicVolume();
      await _backgroundPlayer!.setAsset('assets/audio/bg.mp3');
      await _backgroundPlayer!.setVolume(volume);
      await _backgroundPlayer!.setLoopMode(LoopMode.one);
      await _backgroundPlayer!.play();
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  static Future<void> stopBackgroundMusic() async {
    if (_backgroundPlayer != null) {
      await _backgroundPlayer!.stop();
    }
  }

  static Future<void> playSoundEffect(String assetPath) async {
    if (!await isSoundEffectsEnabled()) return;

    try {
      await initialize();
      final volume = await getSoundVolume();
      await _effectsPlayer!.setAsset(assetPath);
      await _effectsPlayer!.setVolume(volume);
      await _effectsPlayer!.play();
    } catch (e) {
      print('Error playing sound effect: $e');
    }
  }

  static Future<void> playSoundEffectWithVolume(
    String assetPath,
    double volume,
  ) async {
    if (!await isSoundEffectsEnabled()) return;

    try {
      await initialize();
      await _effectsPlayer!.setAsset(assetPath);
      await _effectsPlayer!.setVolume(volume);
      await _effectsPlayer!.play();
    } catch (e) {
      print('Error playing sound effect: $e');
    }
  }

  static Future<void> vibrate() async {
    if (!await isVibrationEnabled()) return;

    final intensity = await getVibrationIntensity();
    final hasVibrator = await Vibration.hasVibrator() ?? false;

    if (!hasVibrator) {
      HapticFeedback.lightImpact();
      return;
    }

    switch (intensity) {
      case 'light':
        await Vibration.vibrate(duration: 50);
        break;
      case 'medium':
        await Vibration.vibrate(duration: 100);
        break;
      case 'heavy':
        await Vibration.vibrate(duration: 200);
        break;
      default:
        await Vibration.vibrate(duration: 100);
    }
  }

  static Future<void> vibrateHeavy() async {
    if (!await isVibrationEnabled()) return;

    final intensity = await getVibrationIntensity();
    final hasVibrator = await Vibration.hasVibrator() ?? false;

    if (!hasVibrator) {
      HapticFeedback.heavyImpact();
      return;
    }

    switch (intensity) {
      case 'light':
        await Vibration.vibrate(duration: 100);
        break;
      case 'medium':
        await Vibration.vibrate(duration: 200);
        break;
      case 'heavy':
        await Vibration.vibrate(duration: 400);
        break;
      default:
        await Vibration.vibrate(duration: 200);
    }
  }

  static Future<void> vibratePattern(List<int> pattern) async {
    if (!await isVibrationEnabled()) return;

    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      await Vibration.vibrate(pattern: pattern);
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  static Future<void> vibrateSuccess() async {
    await vibratePattern([0, 100, 50, 100]);
  }

  static Future<void> vibrateError() async {
    await vibratePattern([0, 200, 100, 200, 100, 200]);
  }

  static Future<void> vibrateGameOver() async {
    await vibratePattern([0, 500, 200, 500, 200, 500]);
  }

  static Future<void> dispose() async {
    await _backgroundPlayer?.dispose();
    await _effectsPlayer?.dispose();
    _isInitialized = false;
  }

  // Test method to verify settings are working
  static Future<Map<String, dynamic>> testSettings() async {
    try {
      await initialize();

      final results = <String, dynamic>{};

      // Test sound effects
      final soundEnabled = await isSoundEffectsEnabled();
      final soundVolume = await getSoundVolume();
      results['sound_effects_enabled'] = soundEnabled;
      results['sound_volume'] = soundVolume;

      // Test background music
      final musicEnabled = await isBackgroundMusicEnabled();
      final musicVolume = await getMusicVolume();
      results['background_music_enabled'] = musicEnabled;
      results['music_volume'] = musicVolume;

      // Test vibration
      final vibrationEnabled = await isVibrationEnabled();
      final vibrationIntensity = await getVibrationIntensity();
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      results['vibration_enabled'] = vibrationEnabled;
      results['vibration_intensity'] = vibrationIntensity;
      results['has_vibrator'] = hasVibrator;

      // Test audio optimization
      final audioOptimization = await isAudioOptimizationEnabled();
      final lowLatency = await isLowLatencyEnabled();
      results['audio_optimization_enabled'] = audioOptimization;
      results['low_latency_enabled'] = lowLatency;

      return results;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
