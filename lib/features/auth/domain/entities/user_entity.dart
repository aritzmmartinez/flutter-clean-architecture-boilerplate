/// User entity - Pure business logic object (no JSON logic)
class UserEntity {
  final String id;
  final String email;
  final String username;
  final String? fullName;
  final bool isActive;
  final bool isVerified;
  final bool twoFactorEnabled;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    required this.isActive,
    required this.isVerified,
    this.twoFactorEnabled = false,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convenience getters
  String get displayName => fullName ?? username;
  bool get needsVerification => !isVerified;

  /// Copy with method for immutability
  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    bool? isActive,
    bool? isVerified,
    bool? twoFactorEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
