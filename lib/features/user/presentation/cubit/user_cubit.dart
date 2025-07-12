import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserInitial());

  void loadUser() {
    if (userRepository.isLoggedIn()) {
      final email = userRepository.getUserEmail();
      final userId = userRepository.getUserId();
      emit(UserLoaded(email: email ?? '', userId: userId ?? ''));
    } else {
      emit(UserLoggedOut());
    }
  }

  void logout() {
    userRepository.clearUserData();
    emit(UserLoggedOut());
  }
}
