import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lords_arena/features/user/data/datasources/user_local_data_source.dart';

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
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final isLoggedIn = userLocalDataSource.isLoggedIn();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, isLoggedIn ? '/home' : '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash.png', height: 120),
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
    );
  }
}
