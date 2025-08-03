import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:lords_arena/core/services/audio_service.dart';

import '../../game/lords_arena_game.dart';
import 'bullet_component.dart';
import 'weapon_component.dart';

class EnemyComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame>, CollisionCallbacks {
  double health = 50;
  double maxHealth = 50;
  double shootTimer = 0;
  double moveSpeed = 40;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  double gravity = 800;

  EnemyComponent() : super(size: Vector2.all(48), anchor: Anchor.center);

  LordsArenaGame get gameRef => findGame() as LordsArenaGame;

  @override
  Future<void> onLoad() async {
    // Use an existing character sprite for enemies
    try {
      sprite = await gameRef.loadSprite('sher.png');
    } catch (e) {
      // Fallback to colored circle if sprite fails to load
      paint = Paint()..color = const Color(0xFFFF4444);
    }
    position = Vector2(100, 100);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // AI behavior
    handleAI(dt);

    // Physics
    handlePhysics(dt);

    // Shooting
    handleShooting(dt);
  }

  void handleAI(double dt) {
    final player = gameRef.player1; // Target player 1 in single player mode
    final distance = (player.position - position).length;

    // Enhanced AI behavior
    if (distance > 200) {
      // Move towards player when far
      final direction = (player.position - position).normalized();
      velocity.x = direction.x * moveSpeed;
    } else if (distance < 100) {
      // Back away when too close
      final direction = (position - player.position).normalized();
      velocity.x = direction.x * moveSpeed * 0.5;
    } else {
      // Strafe around player when at optimal distance
      final direction = (player.position - position).normalized();
      velocity.x = direction.x * moveSpeed * 0.3;
    }

    // Jump if player is above and enemy is on ground
    if (player.position.y < position.y - 50 && isOnGround) {
      velocity.y = -350; // Enhanced jump force
      isOnGround = false;
    }

    // Random movement to make AI less predictable
    if (distance < 150 && isOnGround) {
      final random = Random();
      if (random.nextDouble() < 0.02) {
        // 2% chance per frame
        velocity.x = (random.nextDouble() - 0.5) * moveSpeed;
      }
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

    // Keep enemy in bounds
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
        }
      }
    }
  }

  void keepInBounds() {
    // Keep enemy within screen bounds
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
    }
  }

  void handleShooting(double dt) {
    shootTimer += dt;
    final player = gameRef.player1;
    final distance = (player.position - position).length;

    // Shoot more frequently when closer to player
    final shootInterval = distance < 150 ? 1.0 : 2.0;

    if (shootTimer > shootInterval) {
      shootTimer = 0;

      final direction = (player.position - position).normalized();

      // Add some prediction for moving targets
      final predictedPosition = player.position + player.velocity * 0.5;
      final predictedDirection = (predictedPosition - position).normalized();

      final bullet = EnemyBulletComponent(direction: predictedDirection)
        ..position = position.clone();
      gameRef.add(bullet);

      // Sometimes shoot multiple bullets
      if (distance < 100 && Random().nextDouble() < 0.3) {
        final bullet2 = EnemyBulletComponent(direction: direction)
          ..position = position.clone();
        gameRef.add(bullet2);
      }
    }
  }

  void takeDamage(double damage) async {
    health -= damage;

    // Play hit sound and vibrate
    if (await AudioService.isSoundEffectsEnabled()) {
      try {
        await FlameAudio.play('hit.wav');
      } catch (e) {
        // Ignore audio errors
      }
    }
    await AudioService.vibrate();

    if (health <= 0) {
      health = 0;
      die();
    }
  }

  void die() async {
    // Play explosion sound and vibrate
    if (await AudioService.isSoundEffectsEnabled()) {
      try {
        await FlameAudio.play('explosion.wav');
      } catch (e) {
        // Ignore audio errors
      }
    }
    await AudioService.vibrateHeavy();

    // Create explosion effect
    final explosion = ExplosionComponent(position);
    gameRef.add(explosion);

    // Increment kill count
    gameRef.incrementKill(1); // Player 1 gets the kill

    // Remove enemy
    removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BulletComponent || other is EnhancedBulletComponent) {
      takeDamage(25);
      other.removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
