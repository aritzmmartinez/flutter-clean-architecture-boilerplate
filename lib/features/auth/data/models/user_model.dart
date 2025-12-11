import '../../domain/entities/user_entity.dart';

/// User Model - Data layer representation of User
/// Extends UserEntity and adds JSON serialization
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.fullName,
    required super.isActive,
    required super.isVerified,
    super.twoFactorEnabled = false,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      fullName: json['full_name'] as String?,
      isActive: json['is_active'] as bool,
      isVerified: json['is_verified'] as bool,
      twoFactorEnabled: json['two_factor_enabled'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'is_active': isActive,
      'is_verified': isVerified,
      'two_factor_enabled': twoFactorEnabled,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
