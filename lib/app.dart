import 'package:flutter/material.dart';
import 'package:lords_arena/views/splash.dart';
import 'package:lords_arena/views/login.dart';
import 'package:lords_arena/views/signup.dart';
import 'package:lords_arena/views/dashboard.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lords Arena',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const DashboardScreen(),
      },
    );
  }
}
