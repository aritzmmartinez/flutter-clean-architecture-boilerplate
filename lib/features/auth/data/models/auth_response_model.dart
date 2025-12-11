import '../../domain/entities/auth_response_entity.dart';
import 'user_model.dart';

/// Auth Response Model - Extends AuthResponseEntity
class AuthResponseModel extends AuthResponseEntity {
  final String tokenType;

  const AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
    required this.tokenType,
    super.requiresTwoFactor,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
