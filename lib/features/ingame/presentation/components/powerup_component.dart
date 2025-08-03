import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../game/lords_arena_game.dart';
import 'player_component.dart';

class PowerUpComponent extends SpriteComponent
    with HasGameReference<LordsArenaGame>, CollisionCallbacks {
  PowerUpComponent() : super(size: Vector2(32, 32), anchor: Anchor.center);

  LordsArenaGame get gameRef => findGame() as LordsArenaGame;

  @override
  Future<void> onLoad() async {
    // For now, use a simple colored circle
    paint = Paint()..color = const Color(0xFF4CAF50);
    position = Vector2(200, 200);
    add(CircleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlayerComponent) {
      removeFromParent();
      other.heal(30);
    }
    super.onCollision(intersectionPoints, other);
  }
}
