import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class PlatformComponent extends SpriteComponent with CollisionCallbacks {
  PlatformComponent({required Vector2 position})
    : super(position: position, size: Vector2(120, 20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // For now, we'll use a simple colored rectangle
    // In a real implementation, you'd load a platform sprite
    paint =
        Paint()..color = const Color(0xFF8B4513); // Brown color for platform

    // Add collision detection
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Handle collision with players
    super.onCollision(intersectionPoints, other);
  }
}
