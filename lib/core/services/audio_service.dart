import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class AudioService {
  static const String _soundEffectsKey = 'sound_effects_enabled';
  static const String _backgroundMusicKey = 'background_music_enabled';
  static const String _vibrationKey = 'vibration_enabled';
  static const String _soundVolumeKey = 'sound_volume';
  static const String _musicVolumeKey = 'music_volume';

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

  static Future<void> setSoundEffectsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEffectsKey, enabled);
  }

  static Future<void> setBackgroundMusicEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backgroundMusicKey, enabled);
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationKey, enabled);
  }

  static Future<void> setSoundVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_soundVolumeKey, volume);
  }

  static Future<void> setMusicVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_musicVolumeKey, volume);
  }

  static Future<void> vibrate() async {
    if (await isVibrationEnabled()) {
      HapticFeedback.lightImpact();
    }
  }

  static Future<void> vibrateHeavy() async {
    if (await isVibrationEnabled()) {
      HapticFeedback.heavyImpact();
    }
  }
}
