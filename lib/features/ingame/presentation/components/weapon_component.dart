import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../../data/weapon_data.dart';
import '../../game/lords_arena_game.dart';

import 'player_component.dart';
import 'enemy_component.dart';
import 'platform_component.dart';

class WeaponPickupComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame>, CollisionCallbacks {
  final WeaponData weapon;

  WeaponPickupComponent({required this.weapon, required Vector2 position})
    : super(position: position, size: Vector2.all(32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // For now, use a simple colored circle
    // In a real implementation, you'd load the weapon sprite
    paint = Paint()..color = const Color(0xFF4CAF50); // Green for weapon pickup

    add(CircleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlayerComponent) {
      // Give weapon to player
      other.pickupWeapon(weapon);
      removeFromParent();
      FlameAudio.play('hit.wav'); // Use hit sound for pickup
    }
    super.onCollision(intersectionPoints, other);
  }
}

class HealthPackComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame>, CollisionCallbacks {
  HealthPackComponent({required Vector2 position})
    : super(position: position, size: Vector2.all(24), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    paint = Paint()..color = const Color(0xFFE91E63); // Pink for health

    add(CircleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlayerComponent) {
      other.heal(50); // Heal 50 HP
      removeFromParent();
      FlameAudio.play('hit.wav');
    }
    super.onCollision(intersectionPoints, other);
  }
}

class ArmorPackComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame>, CollisionCallbacks {
  ArmorPackComponent({required Vector2 position})
    : super(position: position, size: Vector2.all(24), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    paint = Paint()..color = const Color(0xFF2196F3); // Blue for armor

    add(CircleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlayerComponent) {
      other.addArmor(25); // Add 25 armor
      removeFromParent();
      FlameAudio.play('hit.wav');
    }
    super.onCollision(intersectionPoints, other);
  }
}

// Enhanced bullet component for different weapon types
class EnhancedBulletComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame>, CollisionCallbacks {
  final Vector2 direction;
  final double speed;
  final double damage;
  final int playerId; // To track which player fired the bullet
  final String bulletSpritePath;

  EnhancedBulletComponent({
    required this.direction,
    required this.speed,
    required this.damage,
    required this.playerId,
    required this.bulletSpritePath,
  }) : super(size: Vector2(8, 8), anchor: Anchor.center);

  LordsArenaGame get gameRef => findGame() as LordsArenaGame;

  @override
  Future<void> onLoad() async {
    // For now, use a simple colored circle
    // In a real implementation, you'd load the bullet sprite
    paint = Paint()..color = const Color(0xFFFFD700); // Gold color for bullets

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    position += direction.normalized() * speed * dt;

    // Remove bullet if it goes off screen
    if (!gameRef.size.toRect().contains(position.toOffset())) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlayerComponent && other.playerId != playerId) {
      // Hit enemy player
      other.takeDamage(damage, playerId);
      removeFromParent();
      FlameAudio.play('hit.wav');
    } else if (other is EnemyComponent) {
      // Hit enemy (in single player mode)
      other.takeDamage(damage);
      removeFromParent();
      FlameAudio.play('hit.wav');
    } else if (other is PlatformComponent) {
      // Hit platform - remove bullet
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
