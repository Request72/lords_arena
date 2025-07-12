import 'package:hive/hive.dart';

class HiveStorage {
  final Box _box;

  HiveStorage({required Box userBox}) : _box = userBox;

  void saveUser(String email, {required String userId, required String token}) {
    _box.put('user_email', email);
    _box.put('user_id', userId);
    _box.put('user_token', token);
  }

  String? getUserEmail() => _box.get('user_email');
  String? getUserId() => _box.get('user_id');
  String? getToken() => _box.get('user_token');

  bool isLoggedIn() =>
      _box.containsKey('user_email') &&
      _box.containsKey('user_id') &&
      _box.containsKey('user_token');

  void clearUser() {
    _box.delete('user_email');
    _box.delete('user_id');
    _box.delete('user_token');
  }

  double getPlayerX() {
    return _box.get('player_x', defaultValue: 100.0);
  }

  double getPlayerY() {
    return _box.get('player_y', defaultValue: 300.0);
  }

  void savePosition(double playerX, double playerY) {
    _box.put('player_x', playerX);
    _box.put('player_y', playerY);
  }
}
