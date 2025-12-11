import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/app_preferences_model.dart';

class AppPreferencesService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _prefsKey = 'app_preferences';

  Future<AppPreferencesModel> loadPreferences() async {
    try {
      final prefsJson = await _storage.read(key: _prefsKey);
      if (prefsJson != null) {
        final Map<String, dynamic> prefsMap = json.decode(prefsJson);
        return AppPreferencesModel.fromJson(prefsMap);
      }
    } catch (e) {
      return const AppPreferencesModel();
    }
    return const AppPreferencesModel();
  }

  Future<void> savePreferences(AppPreferencesModel preferences) async {
    final prefsJson = json.encode(preferences.toJson());
    await _storage.write(key: _prefsKey, value: prefsJson);
  }

  Future<void> updatePreference<T>(
    String key,
    T value,
    AppPreferencesModel currentPrefs,
  ) async {
    AppPreferencesModel updatedPrefs;

    switch (key) {
      case 'isDarkMode':
        updatedPrefs = currentPrefs.copyWith(isDarkMode: value as bool);
        break;
      case 'numberFormat':
        updatedPrefs = currentPrefs.copyWith(numberFormat: value as String);
        break;
      case 'defaultCurrency':
        updatedPrefs = currentPrefs.copyWith(defaultCurrency: value as String);
        break;
      case 'confirmBeforeDelete':
        updatedPrefs = currentPrefs.copyWith(
          confirmBeforeDelete: value as bool,
        );
        break;
      case 'enableHaptics':
        updatedPrefs = currentPrefs.copyWith(enableHaptics: value as bool);
        break;
      case 'language':
        updatedPrefs = currentPrefs.copyWith(language: value as String);
        break;
      default:
        return;
    }

    await savePreferences(updatedPrefs);
  }

  Future<void> clearPreferences() async {
    await _storage.delete(key: _prefsKey);
  }
}
