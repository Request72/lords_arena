import 'package:hive/hive.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  static const _boxName = 'userBox';
  static const _userKey = 'user';

  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(_boxName);
    await box.put(_userKey, user);
  }

  Future<UserModel?> getUser() async {
    final box = await Hive.openBox<UserModel>(_boxName);
    return box.get(_userKey);
  }

  Future<bool> isLoggedIn() async {
    final box = await Hive.openBox<UserModel>(_boxName);
    return box.containsKey(_userKey);
  }

  Future<void> clearUser() async {
    final box = await Hive.openBox<UserModel>(_boxName);
    await box.delete(_userKey);
  }
}
