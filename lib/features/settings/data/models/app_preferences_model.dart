class AppPreferencesModel {
  final bool isDarkMode;
  final String numberFormat; // 'comma' (1.000,00) o 'dot' (1,000.00)
  final String defaultCurrency;
  final bool confirmBeforeDelete;
  final bool enableHaptics;
  final String language; // 'es', 'en', etc.

  const AppPreferencesModel({
    this.isDarkMode = false,
    this.numberFormat = 'comma', // Por defecto europeo
    this.defaultCurrency = 'EUR',
    this.confirmBeforeDelete = true,
    this.enableHaptics = true,
    this.language = 'es',
  });

  AppPreferencesModel copyWith({
    bool? isDarkMode,
    String? numberFormat,
    String? defaultCurrency,
    bool? confirmBeforeDelete,
    bool? enableHaptics,
    String? language,
  }) {
    return AppPreferencesModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      numberFormat: numberFormat ?? this.numberFormat,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      confirmBeforeDelete: confirmBeforeDelete ?? this.confirmBeforeDelete,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'numberFormat': numberFormat,
      'defaultCurrency': defaultCurrency,
      'confirmBeforeDelete': confirmBeforeDelete,
      'enableHaptics': enableHaptics,
      'language': language,
    };
  }

  factory AppPreferencesModel.fromJson(Map<String, dynamic> json) {
    return AppPreferencesModel(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      numberFormat: json['numberFormat'] as String? ?? 'comma',
      defaultCurrency: json['defaultCurrency'] as String? ?? 'EUR',
      confirmBeforeDelete: json['confirmBeforeDelete'] as bool? ?? true,
      enableHaptics: json['enableHaptics'] as bool? ?? true,
      language: json['language'] as String? ?? 'es',
    );
  }
}
