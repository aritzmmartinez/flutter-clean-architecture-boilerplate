import '../repositories/auth_repository.dart';

/// Verify Email Use Case
class VerifyEmailUseCase {
  final AuthRepository repository;

  const VerifyEmailUseCase(this.repository);

  Future<void> call({
    required String email,
    required String code,
  }) async {
    if (email.isEmpty) throw Exception('Email is required');
    if (code.isEmpty) throw Exception('Verification code is required');

    // Code format validation (usually 6 digits)
    if (code.length != 6 || int.tryParse(code) == null) {
      throw Exception('Invalid verification code format');
    }

    return await repository.verifyEmail(email: email, code: code);
  }
}
