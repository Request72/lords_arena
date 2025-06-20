import 'package:hive/hive.dart';
import '../../domain/datasources/user_local_data_source.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box _box = Hive.box('userBox');

  @override
  Future<void> saveUser({
    required String email,
    required String userId,
    required String token,
  }) async {
    await _box.put('user_email', email);
    await _box.put('user_id', userId);
    await _box.put('user_token', token);
  }

  @override
  Future<String?> getUserEmail() async => _box.get('user_email');

  @override
  Future<String?> getUserId() async => _box.get('user_id');

  @override
  Future<bool> isLoggedIn() async =>
      _box.containsKey('user_email') && _box.containsKey('user_id');

  @override
  Future<void> clearUser() async {
    await _box.delete('user_email');
    await _box.delete('user_id');
    await _box.delete('user_token');
  }
}
