import 'package:flutter/material.dart';
import '../../../../core/storage/hive_storage.dart';

class DashboardScreen extends StatelessWidget {
  final hiveStorage = HiveStorage();

  DashboardScreen({super.key});

  void logout(BuildContext context) {
    hiveStorage.clearUser();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final email = hiveStorage.getUserEmail() ?? 'Unknown Warrior';

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/warzone.jpg', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withAlpha((0.7 * 255).toInt())),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/LordsArena.png', height: 120),
                const SizedBox(height: 20),
                const Text(
                  "WELCOME TO THE ARENA",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text("Leave the Arena"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
