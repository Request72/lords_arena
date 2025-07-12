import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/auth/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final user = await repository.login(email, password);
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthFailure("Invalid email or password"));
    }
  }

  Future<void> signup(String username, String email, String password) async {
    emit(AuthLoading());
    final user = await repository.signup(username, email, password);
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthFailure("Signup failed. Try again."));
    }
  }
}
