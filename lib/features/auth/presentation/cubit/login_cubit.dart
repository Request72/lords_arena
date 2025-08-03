import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:lords_arena/features/auth/domain/repositories/auth_repository.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  LoginCubit({required this.authRepository, required this.userRepository})
    : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final user = await authRepository.login(email, password);
      if (user != null) {
        userRepository.saveUser(
          user.email,
          userId: user.userId,
          token: user.token,
        );
        emit(LoginSuccess(user));
      } else {
        emit(LoginFailure("Login failed. Please check your credentials."));
      }
    } catch (e) {
      emit(LoginFailure("Login error: $e"));
    }
  }

  bool isLoggedIn() => userRepository.isLoggedIn();
}
