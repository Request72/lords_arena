import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> signup(
    String username,
    String email,
    String password,
  ); // ✅ FIXED
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> logout();
}
