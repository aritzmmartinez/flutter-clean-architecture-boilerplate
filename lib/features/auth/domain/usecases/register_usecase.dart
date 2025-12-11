import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Register Use Case - Handles user registration logic
class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    // Input validation
    if (email.isEmpty) throw Exception('Email is required');
    if (username.isEmpty) throw Exception('Username is required');
    if (password.isEmpty) throw Exception('Password is required');

    // Email format validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }

    // Username validation (3-20 chars, alphanumeric + underscore)
    if (username.length < 3 || username.length > 20) {
      throw Exception('Username must be between 3 and 20 characters');
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(username)) {
      throw Exception('Username can only contain letters, numbers, and underscores');
    }

    // Password strength validation
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }

    return await repository.register(
      email: email,
      username: username,
      password: password,
      fullName: fullName,
    );
  }
}
