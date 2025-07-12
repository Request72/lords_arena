import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lords_arena/core/service_locator/service_locator.dart';
import 'package:lords_arena/core/storage/hive_storage.dart';

class InGameScreen extends StatefulWidget {
  const InGameScreen({super.key});

  @override
  State<InGameScreen> createState() => _InGameScreenState();
}

class _InGameScreenState extends State<InGameScreen> {
  final HiveStorage hiveStorage = sl<HiveStorage>();

  double playerX = 100;
  double playerY = 300;
  String? userEmail;
  String? userId;

  @override
  void initState() {
    super.initState();
    userEmail = hiveStorage.getUserEmail();
    userId = hiveStorage.getUserId();
    playerX = hiveStorage.getPlayerX();
    playerY = hiveStorage.getPlayerY();
  }

  void movePlayer(double dx, double dy) {
    setState(() {
      playerX += dx;
      playerY += dy;
      hiveStorage.savePosition(playerX, playerY);
    });
  }

  void shoot() {
    log('Shoot triggered!');
    // Add shooting logic here later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset('assets/images/warzone.jpg', fit: BoxFit.cover),
          ),

          // Player
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            left: playerX,
            top: playerY,
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset('assets/images/lordsarena.png'),
            ),
          ),

          // HUD: Email + ID
          Positioned(
            top: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Player: ${userEmail ?? "Unknown"}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  'ID: ${userId ?? "N/A"}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),

          // Health bar
          Positioned(
            top: 100,
            left: 20,
            child: Row(
              children: [
                const Text("Health:", style: TextStyle(color: Colors.white)),
                const SizedBox(width: 10),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.red,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.7, // Simulated 70% health
                    alignment: Alignment.centerLeft,
                    child: Container(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),

          // Movement Controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _controlBtn(Icons.arrow_left, () => movePlayer(-10, 0)),
                  const SizedBox(width: 20),
                  _controlBtn(Icons.arrow_upward, () => movePlayer(0, -10)),
                  const SizedBox(width: 20),
                  _controlBtn(Icons.arrow_downward, () => movePlayer(0, 10)),
                  const SizedBox(width: 20),
                  _controlBtn(Icons.arrow_right, () => movePlayer(10, 0)),
                ],
              ),
            ),
          ),

          // Fire button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                onPressed: shoot,
                backgroundColor: Colors.red,
                child: const Icon(Icons.whatshot),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlBtn(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        backgroundColor: const Color.fromRGBO(
          255,
          191,
          0,
          0.9,
        ), // Replaces withOpacity
        foregroundColor: Colors.black,
      ),
      child: Icon(icon, size: 30),
    );
  }
}
