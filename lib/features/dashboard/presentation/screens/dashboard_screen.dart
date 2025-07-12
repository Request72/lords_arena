import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';
import 'package:lords_arena/features/user/presentation/cubit/user_cubit.dart';
import 'package:lords_arena/core/service_locator/service_locator.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _logout(BuildContext context) {
    // ✅ Clear Hive data using service locator
    sl<UserRepository>().clearUserData();

    // ✅ Clear Cubit state
    context.read<UserCubit>().logout();

    // ✅ Navigate to login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lords Arena'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, user) {
            return Text("Welcome Soldier");
          },
        ),
      ),
    );
  }
}
