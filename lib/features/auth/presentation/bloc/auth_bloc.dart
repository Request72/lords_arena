import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:lords_arena/features/auth/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await repository.login(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Login failed. Check credentials."));
      }
    });

    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await repository.signup(
        event.username,
        event.email,
        event.password,
      );
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Signup failed. Please try again."));
      }
    });
  }
}
