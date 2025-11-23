abstract class AuthRepository {
  Future<String?> signUp(String email, String password);
  Future<String?> login(String email, String password);
  Future<void> logout();
  Future<String?> getCurrentUser();
  Future<bool> isUserLoggedIn();
}