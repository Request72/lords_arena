import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:lords_arena/core/service_locator/service_locator.dart';
import 'package:lords_arena/features/auth/presentation/cubit/login_cubit.dart';
import 'package:lords_arena/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:lords_arena/features/auth/presentation/screens/login_screen.dart';
import 'package:lords_arena/features/auth/presentation/screens/signup_screen.dart';
import 'package:lords_arena/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:lords_arena/features/user/presentation/cubit/user_cubit.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    Hive.box('userBox');
    final token = Hive.box('userBox').get('user_token');

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LoginCubit>()),
        BlocProvider(create: (_) => sl<SignupCubit>()),
        BlocProvider(create: (_) => sl<UserCubit>()..loadUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lords Arena',
        theme: ThemeData.dark(),
        initialRoute: token != null ? '/home' : '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/signup': (_) => const SignupScreen(),
          '/home': (_) => DashboardScreen(),
        },
      ),
    );
  }
}
