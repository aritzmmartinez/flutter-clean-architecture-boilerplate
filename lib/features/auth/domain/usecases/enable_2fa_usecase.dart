import '../repositories/auth_repository.dart';

/// Enable 2FA Use Case - Enable two-factor authentication
class Enable2FAUseCase {
  final AuthRepository repository;

  const Enable2FAUseCase(this.repository);

  Future<void> call(String code) async {
    if (code.isEmpty) throw Exception('Verification code is required');
    if (code.length != 6 || int.tryParse(code) == null) {
      throw Exception('Invalid verification code format');
    }

    return await repository.enable2FA(code);
  }
}
