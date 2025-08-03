import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:lords_arena/core/services/audio_service.dart';
import '../../game/lords_arena_game.dart';
import '../../data/weapon_data.dart';
import 'bullet_component.dart';
import 'weapon_component.dart';

class PlayerComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame>, KeyboardHandler, CollisionCallbacks {
  final String spritePath;
  final JoystickComponent joystick;
  final int playerId;
  final Color color;

  // Health and armor system
  double health = 100;
  double maxHealth = 100;
  double armor = 0;
  double maxArmor = 100;

  // Movement and physics
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isJumping = false;
  double jumpForce = 300;
  double gravity = 800;
  double moveSpeed = 200;

  // Weapon system
  WeaponData? currentWeapon;
  double lastShotTime = 0;
  int currentAmmo = 0;
  bool isReloading = false;
  double reloadTimer = 0;
  double gameTime = 0;

  // UI components
  late TextComponent healthText;
  late TextComponent armorText;
  late TextComponent ammoText;

  PlayerComponent({
    required this.spritePath,
    required this.joystick,
    required this.playerId,
    required this.color,
  }) : super(size: Vector2.all(48), anchor: Anchor.center);

  LordsArenaGame get gameRef => findGame() as LordsArenaGame;

  @override
  Future<void> onLoad() async {
    try {
      sprite = await gameRef.loadSprite(spritePath);
    } catch (e) {
      // Fallback to colored circle if sprite fails to load
      paint = Paint()..color = color;
    }
    add(CircleHitbox());

    // Initialize UI components
    setupUI();
  }

  void setupUI() {
    final yOffset = playerId == 1 ? 60.0 : 90.0;
    final xOffset = playerId == 1 ? 10.0 : gameRef.size.x - 150.0;

    healthText = TextComponent(
      text: 'HP: ${health.toInt()}',
      position: Vector2(xOffset, yOffset),
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    gameRef.add(healthText);

    armorText = TextComponent(
      text: 'Armor: ${armor.toInt()}',
      position: Vector2(xOffset, yOffset + 20),
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    gameRef.add(armorText);

    ammoText = TextComponent(
      text: 'Ammo: $currentAmmo',
      position: Vector2(xOffset, yOffset + 40),
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    gameRef.add(ammoText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Track game time
    gameTime += dt;

    // Handle movement
    handleMovement(dt);

    // Handle gravity and jumping
    handlePhysics(dt);

    // Handle weapon reloading
    handleReloading(dt);

    // Update UI
    updateUI();
  }

  void handleMovement(double dt) {
    if (!joystick.delta.isZero()) {
      // Horizontal movement
      velocity.x = joystick.delta.x * moveSpeed;

      // Jumping (when joystick is pushed up)
      if (joystick.delta.y < -0.5 && isOnGround && !isJumping) {
        velocity.y = -jumpForce;
        isJumping = true;
        isOnGround = false;
        FlameAudio.play('hit.wav'); // Use hit sound for jump
      }
    } else {
      // Apply friction when not moving
      velocity.x *= 0.8;
    }
  }

  void handlePhysics(double dt) {
    // Apply gravity
    if (!isOnGround) {
      velocity.y += gravity * dt;
    }

    // Update position
    position += velocity * dt;

    // Check platform collisions
    checkPlatformCollisions();

    // Keep player in bounds
    keepInBounds();
  }

  void checkPlatformCollisions() {
    isOnGround = false;

    for (final platform in gameRef.platforms) {
      if (position.y + size.y / 2 >=
              platform.position.y - platform.size.y / 2 &&
          position.y - size.y / 2 <=
              platform.position.y + platform.size.y / 2 &&
          position.x + size.x / 2 >=
              platform.position.x - platform.size.x / 2 &&
          position.x - size.x / 2 <=
              platform.position.x + platform.size.x / 2) {
        // Landing on platform
        if (velocity.y > 0) {
          position.y = platform.position.y - platform.size.y / 2 - size.y / 2;
          velocity.y = 0;
          isOnGround = true;
          isJumping = false;
        }
      }
    }
  }

  void keepInBounds() {
    // Keep player within screen bounds
    if (position.x < size.x / 2) {
      position.x = size.x / 2;
      velocity.x = 0;
    }
    if (position.x > gameRef.size.x - size.x / 2) {
      position.x = gameRef.size.x - size.x / 2;
      velocity.x = 0;
    }
    if (position.y > gameRef.size.y - size.y / 2) {
      position.y = gameRef.size.y - size.y / 2;
      velocity.y = 0;
      isOnGround = true;
      isJumping = false;
    }
  }

  void handleReloading(double dt) {
    if (isReloading) {
      reloadTimer += dt;
      if (reloadTimer >= (currentWeapon?.reloadTime ?? 2.0)) {
        isReloading = false;
        reloadTimer = 0;
        currentAmmo = currentWeapon?.ammoCapacity ?? 30;
      }
    }
  }

  void updateUI() {
    healthText.text = 'HP: ${health.toInt()}';
    armorText.text = 'Armor: ${armor.toInt()}';
    ammoText.text = 'Ammo: $currentAmmo';
  }

  void shoot() {
    if (currentWeapon == null || isReloading || currentAmmo <= 0) {
      return;
    }

    if (gameTime - lastShotTime < (currentWeapon!.fireRate)) {
      return;
    }

    lastShotTime = gameTime;
    currentAmmo--;

    FlameAudio.play('shoot.wav');

    // Create bullets based on weapon type
    if (currentWeapon!.bulletCount == 1) {
      // Single bullet
      final bullet = EnhancedBulletComponent(
        direction: Vector2(0, -1), // Shoot upward for now
        speed: currentWeapon!.bulletSpeed,
        damage: currentWeapon!.damage,
        playerId: playerId,
        bulletSpritePath: currentWeapon!.bulletSpritePath,
      );
      bullet.position = position.clone();
      gameRef.add(bullet);
    } else {
      // Multiple bullets (shotgun)
      for (int i = 0; i < currentWeapon!.bulletCount; i++) {
        final spread =
            (i - currentWeapon!.bulletCount / 2) * currentWeapon!.spread;
        final direction = Vector2(spread, -1).normalized();

        final bullet = EnhancedBulletComponent(
          direction: direction,
          speed: currentWeapon!.bulletSpeed,
          damage: currentWeapon!.damage,
          playerId: playerId,
          bulletSpritePath: currentWeapon!.bulletSpritePath,
        );
        bullet.position = position.clone();
        gameRef.add(bullet);
      }
    }

    // Auto-reload when out of ammo
    if (currentAmmo <= 0) {
      isReloading = true;
      reloadTimer = 0;
    }
  }

  void pickupWeapon(WeaponData weapon) {
    currentWeapon = weapon;
    currentAmmo = weapon.ammoCapacity;
    isReloading = false;
    reloadTimer = 0;
  }

  void heal(double amount) {
    health = (health + amount).clamp(0, maxHealth);
  }

  void addArmor(double amount) {
    armor = (armor + amount).clamp(0, maxArmor);
  }

  void takeDamage(double damage, [int? attackerId]) async {
    // Play hit sound and vibrate
    if (await AudioService.isSoundEffectsEnabled()) {
      try {
        await FlameAudio.play('hit.wav');
      } catch (e) {
        // Ignore audio errors
      }
    }
    await AudioService.vibrateHeavy();

    // Apply damage to armor first, then health
    if (armor > 0) {
      final armorDamage = damage * 0.5; // Armor reduces damage by 50%
      final remainingDamage = damage - armorDamage;

      if (armor >= armorDamage) {
        armor -= armorDamage;
        damage = remainingDamage;
      } else {
        damage = damage - armor;
        armor = 0;
      }
    }

    health -= damage;

    if (health <= 0) {
      health = 0;
      die(attackerId);
    }
  }

  void die([int? killerId]) {
    // Create explosion effect
    final explosion = ExplosionComponent(position);
    gameRef.add(explosion);

    // Increment kill count for the killer
    if (killerId != null) {
      gameRef.incrementKill(killerId);
    }

    // Check if game should end
    if (gameRef.isMultiplayer) {
      final winnerId = killerId == 1 ? 2 : 1;
      gameRef.triggerGameOver(winnerId);
    } else {
      gameRef.triggerGameOver(1);
    }
  }

  void resetForNewRound() {
    health = maxHealth;
    armor = 0;
    currentAmmo = currentWeapon?.ammoCapacity ?? 0;
    isReloading = false;
    reloadTimer = 0;
    velocity = Vector2.zero();
    isOnGround = false;
    isJumping = false;

    // Reset position based on player ID
    if (playerId == 1) {
      position = Vector2(gameRef.size.x * 0.2, gameRef.size.y * 0.8);
    } else {
      position = Vector2(gameRef.size.x * 0.8, gameRef.size.y * 0.8);
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        shoot();
      } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
        // Manual reload
        if (currentWeapon != null &&
            !isReloading &&
            currentAmmo < currentWeapon!.ammoCapacity) {
          isReloading = true;
          reloadTimer = 0;
        }
      }
    }
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is EnemyBulletComponent) {
      takeDamage(20);
      other.removeFromParent();
      FlameAudio.play('hit.wav');
    }
    super.onCollision(intersectionPoints, other);
  }
}
