import 'package:hive/hive.dart';

class HiveStorage {
  final Box _box = Hive.box('userBox');

  void saveUser(String email, {required String userId, required String token}) {
    _box.put('user_email', email);
    _box.put('user_id', userId);
  }

  String? getUserEmail() => _box.get('user_email');
  String? getUserId() => _box.get('user_id');

  bool isLoggedIn() =>
      _box.containsKey('user_email') && _box.containsKey('user_id');

  void clearUser() {
    _box.delete('user_email');
    _box.delete('user_id');
  }
}
