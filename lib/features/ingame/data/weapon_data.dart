class WeaponData {
  final String name;
  final double damage;
  final double fireRate; // Time between shots in seconds
  final double bulletSpeed;
  final String spritePath;
  final String bulletSpritePath;
  final int bulletCount; // For shotguns
  final double spread; // For shotguns
  final int ammoCapacity;
  final double reloadTime;

  const WeaponData({
    required this.name,
    required this.damage,
    required this.fireRate,
    required this.bulletSpeed,
    required this.spritePath,
    required this.bulletSpritePath,
    this.bulletCount = 1,
    this.spread = 0.0,
    this.ammoCapacity = 30,
    this.reloadTime = 2.0,
  });

  WeaponData copyWith({
    String? name,
    double? damage,
    double? fireRate,
    double? bulletSpeed,
    String? spritePath,
    String? bulletSpritePath,
    int? bulletCount,
    double? spread,
    int? ammoCapacity,
    double? reloadTime,
  }) {
    return WeaponData(
      name: name ?? this.name,
      damage: damage ?? this.damage,
      fireRate: fireRate ?? this.fireRate,
      bulletSpeed: bulletSpeed ?? this.bulletSpeed,
      spritePath: spritePath ?? this.spritePath,
      bulletSpritePath: bulletSpritePath ?? this.bulletSpritePath,
      bulletCount: bulletCount ?? this.bulletCount,
      spread: spread ?? this.spread,
      ammoCapacity: ammoCapacity ?? this.ammoCapacity,
      reloadTime: reloadTime ?? this.reloadTime,
    );
  }
}
