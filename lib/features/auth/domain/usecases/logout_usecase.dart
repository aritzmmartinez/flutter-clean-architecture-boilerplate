import '../repositories/auth_repository.dart';

/// Logout Use Case - Handles user logout
class LogoutUseCase {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
