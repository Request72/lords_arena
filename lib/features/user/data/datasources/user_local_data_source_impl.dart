import 'package:lords_arena/core/storage/hive_storage.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'user_local_data_source.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final HiveStorage hiveStorage;

  UserLocalDataSourceImpl({required this.hiveStorage});

  @override
  void saveUser(String email, {required String userId, required String token}) {
    final userModel = UserModel(
      userId: userId,
      email: email,
      username: email.split('@').first, // Use email prefix as username
      token: token,
    );
    hiveStorage.saveUser(userModel);
  }

  @override
  String? getUserEmail() => hiveStorage.getUserEmail();

  @override
  String? getUserId() => hiveStorage.getUserId();

  @override
  String? getToken() => hiveStorage.getToken();

  @override
  bool isLoggedIn() => hiveStorage.isLoggedIn();

  @override
  void clearUser() => hiveStorage.clearUser();
}
