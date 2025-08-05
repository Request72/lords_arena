import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../game/lords_arena_game.dart';

class BulletComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame>, CollisionCallbacks {
  final Vector2 direction;
  final double speed = 300;

  BulletComponent({required this.direction})
    : super(size: Vector2(16, 16), anchor: Anchor.center);

  LordsArenaGame get gameRef => findGame() as LordsArenaGame;

  @override
  Future<void> onLoad() async {
    try {
      sprite = await gameRef.loadSprite('fire_bullet.png');
      if (sprite == null) {
        throw Exception('Failed to load bullet sprite');
      }
    } catch (e) {
      print('Error loading bullet sprite: $e');
      // Fallback to colored circle if sprite fails to load
      paint = Paint()..color = const Color(0xFFFFD700);
    }
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    position += direction.normalized() * speed * dt;
    if (!gameRef.size.toRect().contains(position.toOffset())) {
      removeFromParent();
    }
  }
}

class EnemyBulletComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame>, CollisionCallbacks {
  final Vector2 direction;
  final double speed = 250;

  EnemyBulletComponent({required this.direction})
    : super(size: Vector2(16, 16), anchor: Anchor.center);

  LordsArenaGame get gameRef => findGame() as LordsArenaGame;

  @override
  Future<void> onLoad() async {
    try {
      sprite = await gameRef.loadSprite('enemy_bullet.png');
      if (sprite == null) {
        throw Exception('Failed to load enemy bullet sprite');
      }
    } catch (e) {
      print('Error loading enemy bullet sprite: $e');
      // Fallback to colored circle if sprite fails to load
      paint = Paint()..color = const Color(0xFFFF4444);
    }
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    position += direction.normalized() * speed * dt;
    if (!gameRef.size.toRect().contains(position.toOffset())) {
      removeFromParent();
    }
  }
}

class ExplosionComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame> {
  ExplosionComponent(Vector2 position)
    : super(position: position, size: Vector2.all(32), anchor: Anchor.center);

  LordsArenaGame get gameRef => findGame() as LordsArenaGame;
  double lifetime = 0.6; // 0.6 seconds

  @override
  Future<void> onLoad() async {
    // For now, use a simple colored circle for explosion
    paint = Paint()..color = const Color(0xFFFF5722);
    add(CircleHitbox());
    try {
      FlameAudio.play('explosion.wav');
    } catch (e) {
      // Ignore audio errors
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    lifetime -= dt;
    if (lifetime <= 0) {
      removeFromParent();
    }
  }
}
