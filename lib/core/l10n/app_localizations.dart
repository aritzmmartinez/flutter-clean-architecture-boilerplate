import 'package:flutter/material.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Abstract class for app localizations
abstract class AppLocalizations {
  // Common
  String get appName;
  String get ok;
  String get cancel;
  String get save;
  String get delete;
  String get edit;
  String get loading;
  String get error;
  String get success;
  String get confirm;
  String get yes;
  String get no;

  // Auth - Common
  String get email;
  String get password;
  String get username;
  String get fullName;
  String get login;
  String get register;
  String get logout;
  String get forgotPassword;

  // Auth - Validation
  String get emailRequired;
  String get emailInvalid;
  String get passwordRequired;
  String get passwordTooShort;
  String get usernameRequired;
  String get usernameTooShort;

  // Auth - Messages
  String get loginSuccess;
  String get registerSuccess;
  String get logoutSuccess;
  String get invalidCredentials;
  String get emailNotVerified;
  String get accountDisabled;

  // Auth - 2FA
  String get twoFactorAuth;
  String get twoFactorCode;
  String get enable2FA;
  String get disable2FA;
  String get setup2FA;
  String get invalid2FACode;

  // Settings
  String get settings;
  String get preferences;
  String get theme;
  String get language;
  String get darkMode;
  String get lightMode;
  String get systemMode;

  // Errors
  String get networkError;
  String get unknownError;
  String get timeoutError;

  /// Get localized instance based on locale
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizationsEn();
  }

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
  ];

  /// Localization delegates
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizationsDelegate(),
  ];
}

/// Delegate for AppLocalizations
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'es':
        return AppLocalizationsEs();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
