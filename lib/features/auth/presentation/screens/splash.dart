import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:lords_arena/features/user/data/datasources/user_local_data_source.dart';
import 'package:lords_arena/core/services/orientation_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userLocalDataSource = GetIt.I<UserLocalDataSource>();

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _setPortraitMode();
    _checkLoginStatus();
  }

  Future<void> _setPortraitMode() async {
    await OrientationService.setPortraitMode();
  }

  Future<void> _initializeAudio() async {
    try {
      await FlameAudio.bgm.initialize();
      await FlameAudio.bgm.play('bg.mp3');
    } catch (e) {
      // Ignore audio errors
    }
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = userLocalDataSource.isLoggedIn();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, isLoggedIn ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a1a), Color(0xFF000000)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/icon.png',
                  height: 150,
                  width: 150,
                ),
              ),
              const SizedBox(height: 40),
              // Game title
              const Text(
                "LORDS ARENA",
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  shadows: [Shadow(color: Colors.amber, blurRadius: 10)],
                ),
              ),
              const SizedBox(height: 20),
              // Loading animation
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "LOADING...",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
