import 'app_localizations.dart';

/// English translations
class AppLocalizationsEn implements AppLocalizations {
  // Common
  @override
  String get appName => 'Investment Tracker';
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'Cancel';
  @override
  String get save => 'Save';
  @override
  String get delete => 'Delete';
  @override
  String get edit => 'Edit';
  @override
  String get loading => 'Loading...';
  @override
  String get error => 'Error';
  @override
  String get success => 'Success';
  @override
  String get confirm => 'Confirm';
  @override
  String get yes => 'Yes';
  @override
  String get no => 'No';

  // Auth - Common
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get username => 'Username';
  @override
  String get fullName => 'Full Name';
  @override
  String get login => 'Login';
  @override
  String get register => 'Register';
  @override
  String get logout => 'Logout';
  @override
  String get forgotPassword => 'Forgot Password?';

  // Auth - Validation
  @override
  String get emailRequired => 'Email is required';
  @override
  String get emailInvalid => 'Invalid email format';
  @override
  String get passwordRequired => 'Password is required';
  @override
  String get passwordTooShort => 'Password must be at least 8 characters';
  @override
  String get usernameRequired => 'Username is required';
  @override
  String get usernameTooShort => 'Username must be at least 3 characters';

  // Auth - Messages
  @override
  String get loginSuccess => 'Login successful';
  @override
  String get registerSuccess => 'Registration successful';
  @override
  String get logoutSuccess => 'Logout successful';
  @override
  String get invalidCredentials => 'Invalid email or password';
  @override
  String get emailNotVerified => 'Please verify your email';
  @override
  String get accountDisabled => 'Account has been disabled';

  // Auth - 2FA
  @override
  String get twoFactorAuth => 'Two-Factor Authentication';
  @override
  String get twoFactorCode => '2FA Code';
  @override
  String get enable2FA => 'Enable 2FA';
  @override
  String get disable2FA => 'Disable 2FA';
  @override
  String get setup2FA => 'Setup 2FA';
  @override
  String get invalid2FACode => 'Invalid 2FA code';

  // Settings
  @override
  String get settings => 'Settings';
  @override
  String get preferences => 'Preferences';
  @override
  String get theme => 'Theme';
  @override
  String get language => 'Language';
  @override
  String get darkMode => 'Dark Mode';
  @override
  String get lightMode => 'Light Mode';
  @override
  String get systemMode => 'System';

  // Errors
  @override
  String get networkError => 'No internet connection';
  @override
  String get unknownError => 'An unexpected error occurred';
  @override
  String get timeoutError => 'Connection timeout';
}
