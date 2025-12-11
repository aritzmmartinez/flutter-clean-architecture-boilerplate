import 'user_entity.dart';

/// Auth response entity - Result of successful authentication
class AuthResponseEntity {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;
  final bool requiresTwoFactor;

  const AuthResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.requiresTwoFactor = false,
  });
}
