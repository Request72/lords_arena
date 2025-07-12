import 'package:lords_arena/core/storage/hive_storage.dart';
import 'user_local_data_source.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final HiveStorage hiveStorage;

  UserLocalDataSourceImpl({required this.hiveStorage});

  @override
  void saveUser(String email, {required String userId, required String token}) {
    hiveStorage.saveUser(email, userId: userId, token: token);
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
