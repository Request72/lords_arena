enum BulletType { normal, fire, poison }

class CharacterStats {
  final double maxHP;
  final double speed;
  final BulletType bulletType;

  CharacterStats({
    required this.maxHP,
    required this.speed,
    required this.bulletType,
  });
}

final characterStatsMap = {
  'assets/images/kp.png': CharacterStats(
    maxHP: 100,
    speed: 100,
    bulletType: BulletType.normal,
  ),
  'assets/images/sher.png': CharacterStats(
    maxHP: 80,
    speed: 140,
    bulletType: BulletType.fire,
  ),
  'assets/images/prachanda.png': CharacterStats(
    maxHP: 150,
    speed: 80,
    bulletType: BulletType.poison,
  ),
};
