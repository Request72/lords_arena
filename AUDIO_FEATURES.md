# Audio and Vibration Features

## Overview
The Lords Arena game now includes comprehensive audio and vibration optimization for Android devices. These features enhance the gaming experience with immersive sound effects, background music, and haptic feedback.

## Features

### Audio Management
- **Sound Effects**: Gunshots, hits, explosions with volume control
- **Background Music**: Looping background music with volume control
- **Audio Optimization**: Enhanced audio performance for gaming
- **Low Latency Mode**: Reduced audio latency for better responsiveness

### Vibration Features
- **Customizable Intensity**: Light, medium, and heavy vibration patterns
- **Game-Specific Patterns**: Different vibration patterns for different game events
- **Haptic Feedback**: Fallback to system haptic feedback when vibration is unavailable

### Settings
All audio and vibration settings can be configured in the **Audio** tab of the Statistics screen:

#### Sound Effects
- Enable/disable sound effects
- Adjust sound volume (0-100%)

#### Background Music
- Enable/disable background music
- Adjust music volume (0-100%)

#### Vibration
- Enable/disable vibration
- Select vibration intensity (light/medium/heavy)
- Test vibration functionality

#### Audio Optimization
- Enable audio optimization for better performance
- Enable low latency mode for reduced audio delay

## Usage

### In Game Code
```dart
import 'package:lords_arena/features/ingame/data/game_audio_manager.dart';

// Initialize audio manager
await GameAudioManager.instance.initialize();

// Play sound effects with vibration
await GameAudioManager.instance.playShootSound();
await GameAudioManager.instance.playHitSound();
await GameAudioManager.instance.playExplosionSound();

// Background music
await GameAudioManager.instance.playBackgroundMusic();
await GameAudioManager.instance.stopBackgroundMusic();

// Special vibration patterns
await GameAudioManager.instance.vibrateSuccess();
await GameAudioManager.instance.vibrateError();
await GameAudioManager.instance.vibrateGameOver();
```

### Direct Audio Service Usage
```dart
import 'package:lords_arena/core/services/audio_service.dart';

// Initialize audio service
await AudioService.initialize();

// Play sound effects
await AudioService.playSoundEffect('assets/audio/shoot.wav');

// Vibration patterns
await AudioService.vibrate();
await AudioService.vibrateHeavy();
await AudioService.vibratePattern([0, 100, 50, 100]);

// Background music
await AudioService.playBackgroundMusic();
await AudioService.stopBackgroundMusic();
```

## Android Permissions
The following permissions are required for full functionality:

- `VIBRATE`: For vibration feedback
- `WAKE_LOCK`: For audio playback during screen lock
- `MODIFY_AUDIO_SETTINGS`: For audio optimization
- `RECORD_AUDIO`: For audio session management
- `WRITE_EXTERNAL_STORAGE`: For audio file access
- `READ_EXTERNAL_STORAGE`: For audio file access

## Dependencies
- `vibration: ^1.8.4`: For vibration control
- `just_audio: ^0.9.36`: For audio playback
- `audio_session: ^0.1.18`: For audio session management
- `permission_handler: ^11.3.1`: For permission handling

## Performance Optimization
- Audio sessions are configured for gaming with reduced latency
- Vibration patterns are optimized for different game events
- Background music automatically stops when disabled
- Audio optimization settings improve performance on lower-end devices

## Testing
Use the test buttons in the Audio settings tab to:
- Test sound effects
- Test background music
- Test vibration patterns
- Verify volume controls

## Troubleshooting
1. If vibration doesn't work, check device vibration settings
2. If audio doesn't play, check device volume and audio permissions
3. For performance issues, try disabling audio optimization
4. For latency issues, enable low latency mode 