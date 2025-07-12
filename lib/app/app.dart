import 'package:flutter/material.dart';
import 'package:lords_arena/features/auth/presentation/screens/splash.dart';
import 'package:lords_arena/features/auth/presentation/screens/login_screen.dart';
import 'package:lords_arena/features/auth/presentation/screens/signup_screen.dart';
import 'package:lords_arena/features/dashboard/presentation/screens/dashboard_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lords Arena',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) =>  SplashScreen(),
        '/': (context) =>  LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) =>  DashboardScreen(),
      },
    );
  }
}
