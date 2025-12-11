import '../entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

/// Login with 2FA Use Case
class Login2FAUseCase {
  final AuthRepository repository;

  const Login2FAUseCase(this.repository);

  Future<AuthResponseEntity> call({
    required String email,
    required String password,
    required String code,
  }) async {
    // Input validation
    if (email.isEmpty) throw Exception('Email is required');
    if (password.isEmpty) throw Exception('Password is required');
    if (code.isEmpty) throw Exception('2FA code is required');

    // 2FA code format validation (usually 6 digits)
    if (code.length != 6 || int.tryParse(code) == null) {
      throw Exception('Invalid 2FA code format');
    }

    return await repository.login2FA(
      email: email,
      password: password,
      code: code,
    );
  }
}
