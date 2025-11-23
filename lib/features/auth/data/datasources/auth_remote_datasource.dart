import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSource(this.supabaseClient);

  Future<String?> signUp(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      return response.user?.id;
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user?.id;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<String?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      return user?.id;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final session = supabaseClient.auth.currentSession;
      return session != null;
    } catch (e) {
      return false;
    }
  }
}
