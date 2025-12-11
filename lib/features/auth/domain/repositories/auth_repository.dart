import '../entities/auth_response_entity.dart';
import '../entities/session_entity.dart';
import '../entities/two_factor_entity.dart';
import '../entities/user_entity.dart';

/// Abstract Auth Repository - Defines the contract for authentication operations
/// This interface is implemented by the data layer
abstract class AuthRepository {
  // ===== BASIC AUTHENTICATION =====

  /// Register a new user
  Future<UserEntity> register({
    required String email,
    required String username,
    required String password,
    String? fullName,
  });

  /// Login without 2FA
  Future<AuthResponseEntity> login({
    required String email,
    required String password,
  });

  /// Login with 2FA code
  Future<AuthResponseEntity> login2FA({
    required String email,
    required String password,
    required String code,
  });

  /// Logout from current session
  Future<void> logout();

  /// Refresh access token
  Future<String> refreshToken();

  // ===== EMAIL VERIFICATION =====

  /// Resend verification email
  Future<void> resendVerificationEmail(String email);

  /// Verify email with code
  Future<void> verifyEmail({
    required String email,
    required String code,
  });

  // ===== PASSWORD MANAGEMENT =====

  /// Request password reset
  Future<void> forgotPassword(String email);

  /// Reset password with code
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  /// Change password (authenticated)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // ===== TWO-FACTOR AUTHENTICATION =====

  /// Setup 2FA (get QR code and secret)
  Future<TwoFactorEntity> setup2FA();

  /// Enable 2FA with verification code
  Future<void> enable2FA(String code);

  /// Disable 2FA with verification code
  Future<void> disable2FA(String code);

  // ===== SESSION MANAGEMENT =====

  /// Get all active sessions
  Future<List<SessionEntity>> getSessions();

  /// Revoke a specific session
  Future<void> revokeSession(String sessionId);

  /// Revoke all sessions except current
  Future<void> revokeAllOtherSessions();

  // ===== USER MANAGEMENT =====

  /// Get current user info
  Future<UserEntity> getCurrentUser();

  /// Update user profile
  Future<UserEntity> updateProfile({
    String? fullName,
    String? username,
  });

  /// Delete account
  Future<void> deleteAccount(String password);

  // ===== LOCAL STATE =====

  /// Check if user is logged in locally
  Future<bool> isLoggedIn();

  /// Get locally stored user ID
  Future<String?> getStoredUserId();

  /// Clear local auth data
  Future<void> clearLocalAuthData();
}
