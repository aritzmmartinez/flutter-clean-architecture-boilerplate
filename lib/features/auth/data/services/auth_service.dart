import 'package:dio/dio.dart';
import '../../../../core/config/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';
import '../models/activity_log_model.dart';
import '../models/two_factor_model.dart';
import '../models/auth_error_codes.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  // ===== BASIC AUTHENTICATION =====

  /// Register new user (sends verification email automatically)
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.authRegister,
        data: {
          'email': email,
          'username': username,
          'password': password,
          if (fullName != null) 'full_name': fullName,
        },
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Login without 2FA
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.authLogin,
        data: {'email': email, 'password': password},
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      await StorageService.saveAccessToken(authResponse.accessToken);
      await StorageService.saveRefreshToken(authResponse.refreshToken);
      await StorageService.saveUserId(authResponse.user.id);

      DioClient.setAuthToken(authResponse.accessToken);

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Login with 2FA code
  Future<AuthResponseModel> login2FA({
    required String email,
    required String password,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.authLogin2FA,
        data: {'email': email, 'password': password, 'code': code},
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      await StorageService.saveAccessToken(authResponse.accessToken);
      await StorageService.saveRefreshToken(authResponse.refreshToken);
      await StorageService.saveUserId(authResponse.user.id);

      DioClient.setAuthToken(authResponse.accessToken);

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Refresh access token
  Future<AuthResponseModel> refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();

      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }

      final response = await _dio.post(
        AppConstants.authRefresh,
        data: {'refresh_token': refreshToken},
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      await StorageService.saveAccessToken(authResponse.accessToken);
      DioClient.setAuthToken(authResponse.accessToken);

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get current user profile
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get(AppConstants.authMe);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout from current device
  Future<void> logout() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();

      if (refreshToken != null) {
        await _dio.post(
          AppConstants.authLogout,
          data: {'refresh_token': refreshToken},
        );
      }

      await StorageService.clearAll();
      DioClient.clearAuthToken();
    } on DioException catch (e) {
      await StorageService.clearAll();
      DioClient.clearAuthToken();
      throw _handleError(e);
    }
  }

  Future<void> logoutAll() async {
    try {
      await _dio.post(AppConstants.authLogoutAll);

      await StorageService.clearAll();
      DioClient.clearAuthToken();
    } on DioException catch (e) {
      await StorageService.clearAll();
      DioClient.clearAuthToken();
      throw _handleError(e);
    }
  }

  // ===== PASSWORD MANAGEMENT =====

  /// Request password reset (sends email with 6-digit code)
  Future<void> forgotPassword({required String email}) async {
    try {
      await _dio.post(AppConstants.authForgotPassword, data: {'email': email});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Reset password using 6-digit code from email
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        AppConstants.authResetPassword,
        data: {'email': email, 'code': code, 'new_password': newPassword},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Resend password reset code
  Future<void> resendPasswordReset({required String email}) async {
    try {
      await _dio.post(
        AppConstants.authResendPasswordReset,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Change password from settings (requires current password)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        AppConstants.authChangePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===== EMAIL VERIFICATION =====

  /// Send email verification code
  Future<void> sendVerificationEmail() async {
    try {
      await _dio.post(AppConstants.authSendVerification);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Verify email with 6-digit code
  Future<void> verifyEmail({required String code}) async {
    try {
      await _dio.post(AppConstants.authVerifyEmail, data: {'code': code});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===== SESSION MANAGEMENT =====

  /// Get all active sessions
  Future<SessionsListModel> getSessions({String? refreshToken}) async {
    try {
      // Get refresh token if not provided
      final token = refreshToken ?? await StorageService.getRefreshToken();

      if (token == null) {
        throw Exception('No refresh token available');
      }

      final response = await _dio.get(
        AppConstants.authSessions,
        data: {'refresh_token': token},
      );
      return SessionsListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Revoke a specific session
  Future<void> revokeSession({required String sessionId}) async {
    try {
      await _dio.delete(AppConstants.authRevokeSession(sessionId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===== TWO-FACTOR AUTHENTICATION =====

  /// Enable 2FA (returns QR code and backup codes)
  Future<Enable2FAModel> enable2FA() async {
    try {
      final response = await _dio.post(AppConstants.auth2FAEnable);
      return Enable2FAModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Verify 2FA code to complete activation
  Future<void> verify2FA({required String code}) async {
    try {
      await _dio.post(AppConstants.auth2FAVerify, data: {'code': code});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Disable 2FA
  Future<void> disable2FA({
    required String code,
    required String password,
  }) async {
    try {
      await _dio.post(
        AppConstants.auth2FADisable,
        data: {'code': code, 'password': password},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===== PROFILE MANAGEMENT =====

  /// Update user profile (username, full_name)
  Future<UserModel> updateProfile({String? username, String? fullName}) async {
    try {
      final response = await _dio.put(
        AppConstants.authProfile,
        data: {
          if (username != null) 'username': username,
          if (fullName != null) 'full_name': fullName,
        },
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete account permanently (GDPR compliance)
  Future<void> deleteAccount({
    required String password,
    required String confirmation,
  }) async {
    try {
      await _dio.delete(
        AppConstants.authDeleteAccount,
        data: {'password': password, 'confirmation': confirmation},
      );

      // Limpiar tokens locales
      await StorageService.clearAll();
      DioClient.clearAuthToken();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===== ACTIVITY LOG =====

  /// Get activity log (audit trail)
  Future<ActivityLogListModel> getActivityLog({
    int limit = 50,
    int skip = 0,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.authActivity,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      return ActivityLogListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===== UTILITIES =====

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await StorageService.hasTokens();
  }

  /// Handle errors and return user-friendly messages
  String _handleError(DioException error) {
    if (error.response?.data != null) {
      // Error estructurado del backend
      final data = error.response!.data;

      if (data is Map<String, dynamic>) {
        // Si tiene código de error, usar mensaje user-friendly
        if (data.containsKey('code')) {
          final code = data['code'] as String;
          return AuthErrorCodes.getUserFriendlyMessage(code);
        }
        // Si tiene el formato de error custom
        if (data.containsKey('message')) {
          return data['message'] as String;
        }
        // Si tiene detail
        if (data.containsKey('detail')) {
          final detail = data['detail'];
          if (detail is Map && detail.containsKey('message')) {
            return detail['message'] as String;
          }
          return detail.toString();
        }
      }
    }

    // Connection errors
    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Connection error. Please check your internet connection.';
    }

    return error.message ?? 'An unknown error occurred';
  }

  /// Get error code from DioException (if available)
  String? getErrorCode(DioException error) {
    if (error.response?.data != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('code')) {
        return data['code'] as String;
      }
    }
    return null;
  }
}
