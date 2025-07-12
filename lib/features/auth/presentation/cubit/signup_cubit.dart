import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:lords_arena/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserRepository userRepository;

  SignupCubit({
    required this.authRemoteDataSource,
    required this.userRepository,
  }) : super(SignupInitial());

  Future<void> signup(String username, String email, String password) async {
    emit(SignupLoading());
    try {
      final user = await authRemoteDataSource.signup(username, email, password);
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
