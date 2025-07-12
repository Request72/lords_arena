import 'package:lords_arena/features/user/data/datasources/user_local_data_source.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource userLocalDataSource;

  UserRepositoryImpl({required this.userLocalDataSource});

  @override
  void saveUser(String email, {required String userId, required String token}) {
    userLocalDataSource.saveUser(email, userId: userId, token: token);
  }

  @override
  String? getUserEmail() => userLocalDataSource.getUserEmail();

  @override
  String? getUserId() => userLocalDataSource.getUserId();

  @override
  String? getToken() => userLocalDataSource.getToken();

  @override
  bool isLoggedIn() => userLocalDataSource.isLoggedIn();

  @override
  void clearUserData() => userLocalDataSource.clearUser();
}
