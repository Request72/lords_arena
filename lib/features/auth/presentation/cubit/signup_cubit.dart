import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:lords_arena/features/auth/domain/repositories/auth_repository.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  SignupCubit({required this.authRepository, required this.userRepository})
    : super(SignupInitial());

  Future<void> signup(String username, String email, String password) async {
    emit(SignupLoading());
    try {
      final user = await authRepository.signup(username, email, password);
      if (user != null) {
        userRepository.saveUser(
          user.email,
          userId: user.userId,
          token: user.token,
        );
        emit(SignupSuccess(user));
      } else {
        emit(SignupFailure("Signup failed. Try again."));
      }
    } catch (e) {
      emit(SignupFailure("Signup error: $e"));
    }
  }
}
