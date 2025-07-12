abstract class UserRepository {
  void saveUser(String email, {required String userId, required String token});
  String? getUserEmail();
  String? getUserId();
  String? getToken();
  bool isLoggedIn();
  void clearUserData();
}
