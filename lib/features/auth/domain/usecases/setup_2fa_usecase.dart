import '../entities/two_factor_entity.dart';
import '../repositories/auth_repository.dart';

/// Setup 2FA Use Case - Get QR code and secret for 2FA setup
class Setup2FAUseCase {
  final AuthRepository repository;

  const Setup2FAUseCase(this.repository);

  Future<TwoFactorEntity> call() async {
    return await repository.setup2FA();
  }
}
