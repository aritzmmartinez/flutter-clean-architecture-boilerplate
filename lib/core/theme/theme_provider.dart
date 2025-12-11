import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'theme_provider.g.dart';

enum ThemeModeEnum { light, dark, system }

@riverpod
class AppThemeMode extends _$AppThemeMode {
  final _storage = const FlutterSecureStorage();
  static const String _themeKey = 'theme_mode';

  @override
  Future<ThemeModeEnum> build() async {
    final savedTheme = await _storage.read(key: _themeKey);

    if (savedTheme == 'dark') {
      return ThemeModeEnum.dark;
    } else if (savedTheme == 'light') {
      return ThemeModeEnum.light;
    } else if (savedTheme == 'system') {
      return ThemeModeEnum.system;
    }

    return ThemeModeEnum.system;
  }

  Future<void> toggleTheme() async {
    final currentTheme = state.value ?? ThemeModeEnum.system;
    final ThemeModeEnum newTheme;

    if (currentTheme == ThemeModeEnum.system) {
      newTheme = ThemeModeEnum.light;
    } else if (currentTheme == ThemeModeEnum.light) {
      newTheme = ThemeModeEnum.dark;
    } else {
      newTheme = ThemeModeEnum.system;
    }

    await _storage.write(
      key: _themeKey,
      value: newTheme == ThemeModeEnum.dark
          ? 'dark'
          : newTheme == ThemeModeEnum.light
          ? 'light'
          : 'system',
    );

    state = AsyncValue.data(newTheme);
  }

  Future<void> setTheme(ThemeModeEnum theme) async {
    await _storage.write(
      key: _themeKey,
      value: theme == ThemeModeEnum.dark
          ? 'dark'
          : theme == ThemeModeEnum.light
          ? 'light'
          : 'system',
    );

    state = AsyncValue.data(theme);
  }
}
