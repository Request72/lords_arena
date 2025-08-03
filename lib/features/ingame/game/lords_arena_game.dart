import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../presentation/components/player_component.dart';
import '../presentation/components/enemy_component.dart';

import '../presentation/components/platform_component.dart';
import '../presentation/components/weapon_component.dart';
import '../data/weapon_data.dart';
import '../../../core/services/stats_service.dart';
import '../../../core/services/audio_service.dart';

class LordsArenaGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  final String selectedCharacter;
  late PlayerComponent player1;
  late PlayerComponent player2;
  late JoystickComponent joystick1;
  late JoystickComponent joystick2;
  late TextComponent gameInfoText;
  late TextComponent weaponInfoText;

  int player1Kills = 0;
  int player2Kills = 0;
  int roundNumber = 1;
  int maxRounds = 5;
  bool isMultiplayer = false;

  // Game state
  GameState gameState = GameState.playing;
  List<WeaponData> availableWeapons = [];
  List<PlatformComponent> platforms = [];
  double enemySpawnTimer = 0;
  double enemySpawnInterval = 10.0; // Spawn new enemy every 10 seconds

  LordsArenaGame({required this.selectedCharacter, this.isMultiplayer = false});

  @override
  Future<void> onLoad() async {
    try {
      await images.loadAll([
        'warzone.jpg',
        'kp.png',
        'sher.png',
        'prachanda.png',
        'bullet.png',
        'fire_bullet.png',
        'poison_bullet.png',
        'enemy_bullet.png',
        'explosion_sheet.png',
      ]);
    } catch (e) {
      print('Error loading images: $e');
    }

    try {
      await FlameAudio.bgm.initialize();
      if (await AudioService.isBackgroundMusicEnabled()) {
        await FlameAudio.bgm.play('bg.mp3');
      }
    } catch (e) {
      // Ignore audio errors
    }

    // Background
    try {
      add(
        SpriteComponent()
          ..sprite = await loadSprite('warzone.jpg')
          ..size = size
          ..priority = -1,
      );
    } catch (e) {
      print('Error loading background sprite: $e');
      // Fallback background
      add(
        RectangleComponent(
          size: size,
          paint: Paint()..color = const Color(0xFF2C3E50),
        )..priority = -1,
      );
    }

    // Create platforms for Mini Militia-style gameplay
    await createPlatforms();

    // Initialize weapons
    initializeWeapons();

    if (isMultiplayer) {
      // Multiplayer setup
      setupMultiplayer();
    } else {
      // Single player setup
      setupSinglePlayer();
    }

    // Game info UI
    setupGameUI();

    // Spawn power-ups and weapons periodically
    startPowerUpSpawner();
  }

  Future<void> createPlatforms() async {
    // Create multiple platforms for vertical gameplay
    final platformPositions = [
      Vector2(size.x * 0.2, size.y * 0.7),
      Vector2(size.x * 0.8, size.y * 0.7),
      Vector2(size.x * 0.5, size.y * 0.5),
      Vector2(size.x * 0.1, size.y * 0.3),
      Vector2(size.x * 0.9, size.y * 0.3),
    ];

    for (final position in platformPositions) {
      final platform = PlatformComponent(position: position);
      platforms.add(platform);
      add(platform);
    }
  }

  void initializeWeapons() {
    availableWeapons = [
      WeaponData(
        name: 'Rifle',
        damage: 25,
        fireRate: 0.3,
        bulletSpeed: 400,
        spritePath: 'bullet.png',
        bulletSpritePath: 'bullet.png',
      ),
      WeaponData(
        name: 'Shotgun',
        damage: 15,
        fireRate: 0.8,
        bulletSpeed: 300,
        spritePath: 'fire_bullet.png',
        bulletSpritePath: 'fire_bullet.png',
        bulletCount: 3,
        spread: 0.3,
      ),
      WeaponData(
        name: 'Sniper',
        damage: 100,
        fireRate: 1.5,
        bulletSpeed: 600,
        spritePath: 'poison_bullet.png',
        bulletSpritePath: 'poison_bullet.png',
      ),
    ];
  }

  void setupMultiplayer() {
    // Player 1 Joystick (left side)
    joystick1 = JoystickComponent(
      knob: CircleComponent(
        radius: 20,
        paint: Paint()..color = const Color(0xFF2196F3),
      ),
      background: CircleComponent(
        radius: 50,
        paint: Paint()..color = const Color(0xFF2196F3).withValues(alpha: 0.4),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick1);

    // Player 2 Joystick (right side)
    joystick2 = JoystickComponent(
      knob: CircleComponent(
        radius: 20,
        paint: Paint()..color = const Color(0xFFFF5722),
      ),
      background: CircleComponent(
        radius: 50,
        paint: Paint()..color = const Color(0xFFFF5722).withValues(alpha: 0.4),
      ),
      margin: const EdgeInsets.only(right: 32, bottom: 32),
    );
    add(joystick2);

    // Player 1 (Blue)
    player1 = PlayerComponent(
      spritePath: _getSpriteName(selectedCharacter),
      joystick: joystick1,
      playerId: 1,
      color: const Color(0xFF2196F3),
    );
    player1.position = Vector2(size.x * 0.2, size.y * 0.8);
    add(player1);

    // Player 2 (Red)
    player2 = PlayerComponent(
      spritePath: 'sher.png', // Different character for player 2
      joystick: joystick2,
      playerId: 2,
      color: const Color(0xFFFF5722),
    );
    player2.position = Vector2(size.x * 0.8, size.y * 0.8);
    add(player2);
  }

  void setupSinglePlayer() {
    // Single player joystick
    joystick1 = JoystickComponent(
      knob: CircleComponent(
        radius: 20,
        paint: Paint()..color = const Color(0xFFFFC107),
      ),
      background: CircleComponent(
        radius: 50,
        paint: Paint()..color = const Color(0xFFFFC107).withValues(alpha: 0.4),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick1);

    // Single player
    player1 = PlayerComponent(
      spritePath: _getSpriteName(selectedCharacter),
      joystick: joystick1,
      playerId: 1,
      color: const Color(0xFFFFC107),
    );
    player1.position = Vector2(size.x * 0.5, size.y * 0.8);
    add(player1);

    // Add AI enemies
    spawnEnemies();
  }

  String _getSpriteName(String assetPath) {
    // Extract just the filename from the full asset path
    print('Processing sprite path: $assetPath');
    if (assetPath.startsWith('assets/images/')) {
      final result = assetPath.substring('assets/images/'.length);
      print('Extracted sprite name: $result');
      return result;
    }
    print('Using original sprite path: $assetPath');
    return assetPath;
  }

  void setupGameUI() {
    // Game info (round, kills, etc.)
    gameInfoText = TextComponent(
      text:
          isMultiplayer
              ? 'Round $roundNumber | P1: $player1Kills | P2: $player2Kills'
              : 'Round $roundNumber | Kills: $player1Kills',
      position: Vector2(10, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(gameInfoText);

    // Weapon info
    weaponInfoText = TextComponent(
      text: 'Weapon: ${player1.currentWeapon?.name ?? "None"}',
      position: Vector2(10, 35),
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 14),
      ),
    );
    add(weaponInfoText);
  }

  void spawnEnemies() {
    // Spawn multiple enemies for single player mode
    for (int i = 0; i < 5; i++) {
      final enemy = EnemyComponent();
      enemy.position = Vector2(
        (size.x * 0.1) + (i * size.x * 0.2),
        size.y * 0.1 + (i % 2) * size.y * 0.1,
      );
      add(enemy);
    }
  }

  void spawnAdditionalEnemy() {
    if (!isMultiplayer) {
      final enemy = EnemyComponent();
      final random = Random();
      enemy.position = Vector2(
        random.nextDouble() * size.x,
        random.nextDouble() * size.y * 0.3,
      );
      add(enemy);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isMultiplayer && gameState == GameState.playing) {
      enemySpawnTimer += dt;
      if (enemySpawnTimer >= enemySpawnInterval) {
        enemySpawnTimer = 0;
        spawnAdditionalEnemy();
      }
    }
  }

  void startPowerUpSpawner() {
    // Spawn weapons and power-ups periodically
    // For now, we'll spawn them manually in update
  }

  void spawnRandomPowerUp() {
    final random = Random();
    final weapon = availableWeapons[random.nextInt(availableWeapons.length)];

    Vector2 spawnPosition;
    do {
      spawnPosition = Vector2(
        random.nextDouble() * size.x,
        random.nextDouble() * size.y * 0.6,
      );
    } while (!isValidSpawnPosition(spawnPosition));

    add(WeaponPickupComponent(weapon: weapon, position: spawnPosition));
  }

  bool isValidSpawnPosition(Vector2 position) {
    // Check if position is not too close to players or platforms
    for (final platform in platforms) {
      if ((position - platform.position).length < 100) {
        return false;
      }
    }
    return true;
  }

  void incrementKill(int playerId) {
    if (playerId == 1) {
      player1Kills++;
    } else if (playerId == 2) {
      player2Kills++;
    }
    updateGameInfo();
  }

  void updateGameInfo() {
    gameInfoText.text =
        isMultiplayer
            ? 'Round $roundNumber | P1: $player1Kills | P2: $player2Kills'
            : 'Round $roundNumber | Kills: $player1Kills';

    if (isMultiplayer) {
      weaponInfoText.text =
          'P1: ${player1.currentWeapon?.name ?? "None"} | P2: ${player2.currentWeapon?.name ?? "None"}';
    } else {
      weaponInfoText.text = 'Weapon: ${player1.currentWeapon?.name ?? "None"}';
    }
  }

  void triggerGameOver(int winnerId) {
    gameState = GameState.gameOver;
    overlays.add('GameOver');
    pauseEngine();
    FlameAudio.bgm.stop();

    // Track game statistics
    _trackGameStats();
  }

  void nextRound() {
    roundNumber++;
    if (roundNumber > maxRounds) {
      // Game finished
      overlays.add('GameFinished');
    } else {
      // Reset for next round
      resetRound();
    }
  }

  void resetRound() {
    // Reset player positions and health
    player1.resetForNewRound();
    if (isMultiplayer) {
      player2.resetForNewRound();
    }

    // Clear all bullets and power-ups
    removeAll(children.whereType<EnhancedBulletComponent>());
    removeAll(children.whereType<WeaponPickupComponent>());
    removeAll(children.whereType<HealthPackComponent>());
    removeAll(children.whereType<ArmorPackComponent>());

    // Spawn new enemies if single player
    if (!isMultiplayer) {
      spawnEnemies();
    }

    resumeEngine();
  }

  void reset() {
    roundNumber = 1;
    player1Kills = 0;
    player2Kills = 0;
    gameState = GameState.playing;
    updateGameInfo();
    resetRound();
  }

  Future<void> _trackGameStats() async {
    try {
      // Increment games played
      await StatsService.incrementGamesPlayed();

      // Track kills and deaths
      final totalKills = player1Kills + player2Kills;
      if (totalKills > 0) {
        await StatsService.addKills(totalKills);
      }

      // Track player deaths (simplified - assume 1 death per game for now)
      await StatsService.addDeaths(1);

      // Track play time (simplified - assume 5 minutes per game)
      await StatsService.addPlayTime(300);

      // Check for achievements
      await _checkAchievements(totalKills);
    } catch (e) {
      // Ignore stats errors
    }
  }

  Future<void> _checkAchievements(int totalKills) async {
    try {
      final stats = await StatsService.getStats();
      final totalKillsOverall = stats['totalKills'] as int? ?? 0;

      // First Blood achievement
      if (totalKillsOverall == 1) {
        await StatsService.unlockAchievement('first_blood');
      }

      // Sharpshooter achievement (10 kills in one game)
      if (totalKills >= 10) {
        await StatsService.unlockAchievement('sharpshooter');
      }

      // Survivor achievement (5 games won)
      final gamesWon = stats['gamesWon'] as int? ?? 0;
      if (gamesWon >= 5) {
        await StatsService.unlockAchievement('survivor');
      }

      // Legend achievement (100 games)
      final gamesPlayed = stats['gamesPlayed'] as int? ?? 0;
      if (gamesPlayed >= 100) {
        await StatsService.unlockAchievement('legend');
      }
    } catch (e) {
      // Ignore achievement errors
    }
  }
}

enum GameState { playing, paused, gameOver, roundEnd }
