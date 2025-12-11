class AppConstants {
  // API Configuration
  // TODO: Update with your backend URL
  static const String baseUrl = 'https://your-api-url.com';
  static const String apiVersion = '/api';

  // Auth Endpoints - Basic Authentication
  static const String authRegister = '$apiVersion/auth/register';
  static const String authLogin = '$apiVersion/auth/login';
  static const String authLogin2FA = '$apiVersion/auth/login/2fa';
  static const String authRefresh = '$apiVersion/auth/refresh';
  static const String authLogout = '$apiVersion/auth/logout';
  static const String authLogoutAll = '$apiVersion/auth/logout-all';
  static const String authMe = '$apiVersion/auth/me';

  // Auth Endpoints - Password Management
  static const String authForgotPassword = '$apiVersion/auth/forgot-password';
  static const String authResetPassword = '$apiVersion/auth/reset-password';
  static const String authResendPasswordReset =
      '$apiVersion/auth/resend-password-reset';
  static const String authChangePassword = '$apiVersion/auth/change-password';

  // Auth Endpoints - Email Verification
  static const String authSendVerification =
      '$apiVersion/auth/send-verification';
  static const String authVerifyEmail = '$apiVersion/auth/verify-email';

  // Auth Endpoints - Session Management
  static const String authSessions = '$apiVersion/auth/sessions';
  static String authRevokeSession(String sessionId) =>
      '$apiVersion/auth/sessions/$sessionId';

  // Auth Endpoints - 2FA
  static const String auth2FAEnable = '$apiVersion/auth/2fa/enable';
  static const String auth2FAVerify = '$apiVersion/auth/2fa/verify';
  static const String auth2FADisable = '$apiVersion/auth/2fa/disable';

  // Auth Endpoints - Profile Management
  static const String authProfile = '$apiVersion/auth/profile';
  static const String authDeleteAccount = '$apiVersion/auth/account';

  // Auth Endpoints - Activity Log
  static const String authActivity = '$apiVersion/auth/activity';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';

  // Deep Link Scheme
  // TODO: Update with your app's deep link scheme
  static const String deepLinkScheme = 'yourapp://';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Token Expiration
  static const Duration accessTokenDuration = Duration(minutes: 15);
  static const Duration refreshTokenDuration = Duration(days: 7);

  // Security
  static const int maxActiveSessions = 5;
  static const int maxLoginAttempts = 5;
  static const Duration accountLockoutDuration = Duration(minutes: 15);
  static const Duration verificationCodeDuration = Duration(minutes: 15);
}
