import '../../domain/models/app_user.dart';

class AuthResult {
  const AuthResult._({required this.success, required this.message, this.user});

  const AuthResult.success({required String message, AppUser? user})
    : this._(success: true, message: message, user: user);

  const AuthResult.failure({required String message})
    : this._(success: false, message: message);

  final bool success;
  final String message;
  final AppUser? user;
}

abstract class AuthRepository {
  Future<AppUser?> restoreSession();

  Future<AuthResult> login({
    required String usernameOrEmail,
    required String password,
  });

  Future<AuthResult> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
  });

  Future<AuthResult> requestPasswordReset({required String email});

  Future<void> logout();
}
