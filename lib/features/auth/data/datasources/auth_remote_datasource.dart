import 'package:dio/dio.dart';
import '../../../../core/config/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';
import '../models/activity_log_model.dart';
import '../models/two_factor_model.dart';
import '../models/auth_error_codes.dart';

/// Remote data source for authentication
/// Handles all network requests related to authentication
/// Does NOT handle local storage (that's the repository's job)
abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    String? fullName,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> login2FA({
    required String email,
    required String password,
    required String code,
  });

  Future<AuthResponseModel> refreshToken(String refreshToken);
  Future<UserModel> getCurrentUser();
  Future<void> logout(String? refreshToken);
  Future<void> logoutAll();

  Future<void> resendVerificationEmail(String email);
  Future<void> verifyEmail({required String email, required String code});

  Future<void> forgotPassword(String email);
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<TwoFactorModel> setup2FA();
  Future<void> enable2FA(String code);
  Future<void> disable2FA(String code);

  Future<List<SessionModel>> getSessions();
  Future<void> revokeSession(String sessionId);
  Future<void> revokeAllOtherSessions();

  Future<List<ActivityLogModel>> getActivityLog({int? limit});

  Future<UserModel> updateProfile({String? fullName, String? username});
  Future<void> deleteAccount(String password);
}

/// Implementation of AuthRemoteDataSource using Dio
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({Dio? dio}) : dio = dio ?? DioClient.instance;

  @override
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await dio.post(
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

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.authLogin,
        data: {'email': email, 'password': password},
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponseModel> login2FA({
    required String email,
    required String password,
    required String code,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.authLogin2FA,
        data: {
          'email': email,
          'password': password,
          'code': code,
        },
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        AppConstants.authRefresh,
        data: {'refresh_token': refreshToken},
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get(AppConstants.authMe);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout(String? refreshToken) async {
    try {
      if (refreshToken != null) {
        await dio.post(
          AppConstants.authLogout,
          data: {'refresh_token': refreshToken},
        );
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logoutAll() async {
    try {
      await dio.post(AppConstants.authLogoutAll);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    try {
      await dio.post(
        AppConstants.authSendVerification,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await dio.post(
        AppConstants.authVerifyEmail,
        data: {'email': email, 'code': code},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await dio.post(
        AppConstants.authForgotPassword,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await dio.post(
        AppConstants.authResetPassword,
        data: {
          'email': email,
          'code': code,
          'new_password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await dio.post(
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

  @override
  Future<TwoFactorModel> setup2FA() async {
    try {
      // Using 2FA verify endpoint to get setup information
      final response = await dio.get(AppConstants.auth2FAVerify);
      return TwoFactorModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> enable2FA(String code) async {
    try {
      await dio.post(
        AppConstants.auth2FAEnable,
        data: {'code': code},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> disable2FA(String code) async {
    try {
      await dio.post(
        AppConstants.auth2FADisable,
        data: {'code': code},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<SessionModel>> getSessions() async {
    try {
      final response = await dio.get(AppConstants.authSessions);
      return (response.data as List)
          .map((json) => SessionModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> revokeSession(String sessionId) async {
    try {
      await dio.delete('${AppConstants.authSessions}/$sessionId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> revokeAllOtherSessions() async {
    try {
      await dio.post('${AppConstants.authSessions}/revoke-all');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ActivityLogModel>> getActivityLog({int? limit}) async {
    try {
      final response = await dio.get(
        AppConstants.authActivity,
        queryParameters: limit != null ? {'limit': limit} : null,
      );
      return (response.data as List)
          .map((json) => ActivityLogModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? username,
  }) async {
    try {
      final response = await dio.patch(
        AppConstants.authProfile,
        data: {
          if (fullName != null) 'full_name': fullName,
          if (username != null) 'username': username,
        },
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      await dio.delete(
        AppConstants.authDeleteAccount,
        data: {'password': password},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to custom exceptions
  Exception _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      final errorCode = data['error_code'] as String?;
      final message = data['message'] as String? ?? 'Unknown error occurred';

      // Map error codes to user-friendly messages
      switch (errorCode) {
        case AuthErrorCodes.invalidCredentials:
          return Exception('Invalid email or password');
        case AuthErrorCodes.emailNotVerified:
          return Exception('Please verify your email before logging in');
        case AuthErrorCodes.accountDisabled:
          return Exception('Your account has been disabled');
        case AuthErrorCodes.twoFactorRequired:
          return Exception('Two-factor authentication required');
        case AuthErrorCodes.invalid2FACode:
          return Exception('Invalid 2FA code');
        case AuthErrorCodes.emailAlreadyExists:
          return Exception('This email is already registered');
        case AuthErrorCodes.usernameAlreadyExists:
          return Exception('This username is already taken');
        case AuthErrorCodes.invalidVerificationCode:
          return Exception('Invalid verification code');
        case AuthErrorCodes.verificationCodeExpired:
          return Exception('Verification code has expired');
        case AuthErrorCodes.invalidResetCode:
          return Exception('Invalid or expired reset code');
        case AuthErrorCodes.sessionNotFound:
          return Exception('Session not found');
        case AuthErrorCodes.sessionRevoked:
          return Exception('Session has been revoked');
        default:
          return Exception(message);
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout. Please check your internet connection');
    } else if (error.type == DioExceptionType.connectionError) {
      return Exception('No internet connection. Please check your network');
    } else {
      return Exception('An unexpected error occurred');
    }
  }
}
