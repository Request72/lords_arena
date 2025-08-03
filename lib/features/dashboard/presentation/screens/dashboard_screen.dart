import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';
import 'package:lords_arena/features/user/presentation/cubit/user_cubit.dart';
import 'package:lords_arena/core/service_locator/service_locator.dart';
import 'package:lords_arena/core/services/orientation_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _setLandscapeMode();
  }

  Future<void> _setLandscapeMode() async {
    await OrientationService.setLandscapeMode();
  }

  void _logout(BuildContext context) async {
    await OrientationService.setPortraitMode();
    sl<UserRepository>().clearUserData();
    context.read<UserCubit>().logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      appBar: AppBar(
        title: const Text('Lords Arena', style: TextStyle(color: Colors.amber)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.amber),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/warzone.jpg', fit: BoxFit.cover),
          ),
          Container(color: const Color.fromRGBO(0, 0, 0, 0.75)),
          Center(
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, user) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome, Soldier",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildButton(
                        context,
                        "Play Game",
                        Icons.sports_esports,
                        '/character-selection',
                      ),
                      const SizedBox(height: 20),
                      _buildButton(context, "Stats", Icons.bar_chart, '/stats'),
                      const SizedBox(height: 20),
                      _buildButton(
                        context,
                        "Settings",
                        Icons.settings,
                        '/settings',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    IconData icon,
    String route,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon, color: Colors.black),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.1,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
