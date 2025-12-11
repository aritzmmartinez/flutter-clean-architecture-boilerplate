import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Get Current User Use Case
class GetCurrentUserUseCase {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  Future<UserEntity> call() async {
    return await repository.getCurrentUser();
  }
}
