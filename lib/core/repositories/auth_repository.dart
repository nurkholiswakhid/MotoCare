import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> signUpWithEmail(String email, String password, String name);
  Future<User> loginWithEmail(String email, String password);
  Future<User?> loginWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}
