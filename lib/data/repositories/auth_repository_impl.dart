import '../../core/entities/user.dart';
import '../../core/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<User?> getCurrentUser() async {
    return await authRemoteDataSource.getCurrentUser();
  }

  @override
  Future<User> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    final userModel = await authRemoteDataSource.signUpWithEmail(
      email,
      password,
      name,
    );
    return userModel;
  }

  @override
  Future<User> loginWithEmail(String email, String password) async {
    return await authRemoteDataSource.loginWithEmail(email, password);
  }

  @override
  Future<User?> loginWithGoogle() async {
    return await authRemoteDataSource.loginWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await authRemoteDataSource.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await authRemoteDataSource.resetPassword(email);
  }
}
