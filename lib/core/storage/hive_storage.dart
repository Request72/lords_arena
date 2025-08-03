import 'package:hive/hive.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';

class HiveStorage {
  final Box<UserModel> _userBox;
  final Box _gameBox;

  HiveStorage({required Box<UserModel> userBox, required Box gameBox})
    : _userBox = userBox,
      _gameBox = gameBox;

  void saveUser(UserModel user) {
    _userBox.put('user', user);
  }

  UserModel? getUser() => _userBox.get('user');

  String? getUserEmail() => getUser()?.email;
  String? getUserId() => getUser()?.userId;
  String? getToken() => getUser()?.token;

  bool isLoggedIn() => getUser() != null;

  void clearUser() {
    _userBox.delete('user');
  }

  double getPlayerX() {
    return _gameBox.get('player_x') ?? 100.0;
  }

  double getPlayerY() {
    return _gameBox.get('player_y') ?? 300.0;
  }

  void savePosition(double playerX, double playerY) {
    _gameBox.put('player_x', playerX);
    _gameBox.put('player_y', playerY);
  }
}
