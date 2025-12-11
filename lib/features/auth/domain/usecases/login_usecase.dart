import '../entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

/// Login Use Case - Handles user login logic
class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  /// Execute login
  /// Returns AuthResponseEntity if successful
  /// Throws exception if login fails
  Future<AuthResponseEntity> call({
    required String email,
    required String password,
  }) async {
    // Input validation
    if (email.isEmpty) {
      throw Exception('Email is required');
    }
    if (password.isEmpty) {
      throw Exception('Password is required');
    }

    // Email format validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }

    // Password length validation
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Execute login
    return await repository.login(email: email, password: password);
  }
}
