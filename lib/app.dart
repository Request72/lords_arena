import 'package:flutter/material.dart';
import 'package:lords_arena/features/auth/presentation/screens/splash.dart';
import 'package:lords_arena/features/auth/presentation/screens/login_screen.dart';
import 'package:lords_arena/features/auth/presentation/screens/signup_screen.dart';
import 'package:lords_arena/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:lords_arena/features/dashboard/presentation/screens/ingame_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lords Arena',
      theme: ThemeData(
        fontFamily: 'Tinos Bold',
        scaffoldBackgroundColor: const Color(0xFF0D1B1E),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => DashboardScreen(),
        '/game': (context) => const InGameScreen(),
      },
    );
  }
}
