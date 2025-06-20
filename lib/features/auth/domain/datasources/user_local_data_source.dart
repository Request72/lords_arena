abstract class UserLocalDataSource {
  Future<void> saveUser({
    required String email,
    required String userId,
    required String token,
  });

  Future<String?> getUserEmail();
  Future<String?> getUserId();
  Future<bool> isLoggedIn();
  Future<void> clearUser();
}
