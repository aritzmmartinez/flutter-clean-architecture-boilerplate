class AuthErrorCodes {
  // Validation errors
  static const String emailAlreadyExists = 'VAL_EMAIL_ALREADY_EXISTS';
  static const String usernameTaken = 'VAL_USERNAME_TAKEN';
  static const String usernameAlreadyExists = 'VAL_USERNAME_TAKEN'; // Alias

  // Authentication errors
  static const String invalidCredentials = 'AUTH_INVALID_CREDENTIALS';
  static const String accountDisabled = 'AUTH_ACCOUNT_DISABLED';
  static const String accountLocked = 'AUTH_ACCOUNT_LOCKED';
  static const String twoFactorRequired = 'AUTH_2FA_REQUIRED';
  static const String twoFactorAlreadyEnabled = 'AUTH_2FA_ALREADY_ENABLED';
  static const String invalidTwoFactorCode = 'AUTH_INVALID_2FA_CODE';
  static const String invalid2FACode = 'AUTH_INVALID_2FA_CODE'; // Alias
  static const String invalidToken = 'AUTH_INVALID_TOKEN';
  static const String sessionNotFound = 'AUTH_SESSION_NOT_FOUND';
  static const String sessionRevoked = 'AUTH_SESSION_REVOKED';
  static const String emailNotVerified = 'AUTH_EMAIL_NOT_VERIFIED';

  // Verification errors
  static const String alreadyVerified = 'AUTH_ALREADY_VERIFIED';
  static const String invalidVerificationCode = 'AUTH_INVALID_VERIFICATION_CODE';
  static const String verificationCodeExpired = 'AUTH_VERIFICATION_CODE_EXPIRED';
  static const String invalidResetCode = 'AUTH_INVALID_RESET_CODE';

  // Helper method to get user-friendly messages
  static String getUserFriendlyMessage(String code) {
    switch (code) {
      case emailAlreadyExists:
        return 'This email is already registered';
      case usernameTaken:
        return 'This username is already in use';
      case invalidCredentials:
        return 'Incorrect email or password';
      case accountDisabled:
        return 'Your account has been disabled';
      case accountLocked:
        return 'Account temporarily locked due to multiple failed attempts';
      case twoFactorRequired:
        return 'Two-factor authentication required';
      case twoFactorAlreadyEnabled:
        return '2FA_ALREADY_ENABLED'; // Special marker for UI handling
      case invalidTwoFactorCode:
        return 'Invalid authentication code';
      case invalidToken:
        return 'Session expired, please sign in again';
      case sessionNotFound:
        return 'Session not found';
      case emailNotVerified:
        return 'Please verify your email first';
      case alreadyVerified:
        return 'Email is already verified';
      case invalidVerificationCode:
        return 'Invalid verification code';
      case verificationCodeExpired:
        return 'Verification code has expired';
      default:
        return 'An error occurred';
    }
  }
}
