import 'package:flutter/material.dart';
import '../../../../core/storage/hive_storage.dart';

class InGameScreen extends StatefulWidget {
  const InGameScreen({super.key});

  @override
  State<InGameScreen> createState() => _InGameScreenState();
}

class _InGameScreenState extends State<InGameScreen> {
  final HiveStorage hiveStorage = HiveStorage();

  double playerX = 100;
  double playerY = 300;

  String? userEmail;
  String? userId;

  @override
  void initState() {
    super.initState();
    userEmail = hiveStorage.getUserEmail();
    userId = hiveStorage.getUserId();
  }

  void movePlayer(double dx, double dy) {
    setState(() {
      playerX += dx;
      playerY += dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/warzone.jpg', fit: BoxFit.cover),
          ),

          // Show Player
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

          // HUD (Player Info)
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

          // Controls
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
        backgroundColor: Colors.amber.withOpacity(0.9),
        foregroundColor: Colors.black,
      ),
      child: Icon(icon, size: 30),
    );
  }
}
