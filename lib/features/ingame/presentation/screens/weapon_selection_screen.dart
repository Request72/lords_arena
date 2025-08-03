import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/ingame/presentation/cubit/game_cubit.dart';
import '../../data/weapon_data.dart';
import 'ingame_screen.dart';

class WeaponSelectionScreen extends StatefulWidget {
  final String selectedCharacter;

  const WeaponSelectionScreen({super.key, required this.selectedCharacter});

  @override
  State<WeaponSelectionScreen> createState() => _WeaponSelectionScreenState();
}

class _WeaponSelectionScreenState extends State<WeaponSelectionScreen> {
  WeaponData? selectedWeapon;
  bool isMultiplayer = true;

  final List<WeaponData> availableWeapons = [
    const WeaponData(
      name: 'Rifle',
      damage: 25,
      fireRate: 0.3,
      bulletSpeed: 400,
      spritePath: 'weapon_rifle.png',
      bulletSpritePath: 'bullet.png',
      ammoCapacity: 30,
    ),
    const WeaponData(
      name: 'Shotgun',
      damage: 15,
      fireRate: 0.8,
      bulletSpeed: 300,
      spritePath: 'weapon_shotgun.png',
      bulletSpritePath: 'fire_bullet.png',
      bulletCount: 3,
      spread: 0.3,
      ammoCapacity: 8,
    ),
    const WeaponData(
      name: 'Sniper',
      damage: 100,
      fireRate: 1.5,
      bulletSpeed: 600,
      spritePath: 'weapon_sniper.png',
      bulletSpritePath: 'poison_bullet.png',
      ammoCapacity: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedWeapon = availableWeapons.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Weapon Selection',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Game Mode Selection
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Game Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModeButton(
                            'Single Player',
                            !isMultiplayer,
                            () => setState(() => isMultiplayer = false),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModeButton(
                            'Multiplayer',
                            isMultiplayer,
                            () => setState(() => isMultiplayer = true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Weapon Selection
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Choose Your Weapon',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: availableWeapons.length,
                          itemBuilder: (context, index) {
                            final weapon = availableWeapons[index];
                            final isSelected =
                                selectedWeapon?.name == weapon.name;

                            return _buildWeaponCard(weapon, isSelected);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Start Game Button
              Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedWeapon != null ? () => _startGame() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? Colors.orange
                    : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color:
                isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildWeaponCard(WeaponData weapon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedWeapon = weapon),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Colors.orange.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Weapon Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getWeaponIcon(weapon.name),
                color: Colors.white,
                size: 32,
              ),
            ),

            const SizedBox(width: 16),

            // Weapon Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weapon.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildStatChip('DMG', weapon.damage.toInt().toString()),
                      const SizedBox(width: 8),
                      _buildStatChip(
                        'ROF',
                        (1 / weapon.fireRate).toStringAsFixed(1),
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip('AMMO', weapon.ammoCapacity.toString()),
                    ],
                  ),
                ],
              ),
            ),

            // Selection Indicator
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.orange, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  IconData _getWeaponIcon(String weaponName) {
    switch (weaponName.toLowerCase()) {
      case 'rifle':
        return Icons.gps_fixed;
      case 'shotgun':
        return Icons.blur_on;
      case 'sniper':
        return Icons.center_focus_strong;
      default:
        return Icons.sports_esports;
    }
  }

  void _startGame() {
    // Create game session with backend
    final gameCubit = context.read<GameCubit>();
    gameCubit.createGameSession(
      gameMode: isMultiplayer ? 'multiplayer' : 'single_player',
      selectedWeapon: selectedWeapon!.name,
      selectedCharacter: widget.selectedCharacter,
    );

    // Navigate to game screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                InGameScreen(selectedCharacter: widget.selectedCharacter),
      ),
    );
  }
}
