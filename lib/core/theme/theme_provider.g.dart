// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppThemeMode)
const appThemeModeProvider = AppThemeModeProvider._();

final class AppThemeModeProvider
    extends $AsyncNotifierProvider<AppThemeMode, ThemeModeEnum> {
  const AppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeHash();

  @$internal
  @override
  AppThemeMode create() => AppThemeMode();
}

String _$appThemeModeHash() => r'e048e23a47f6abb8bb5e18bfb2039df7cecd60aa';

abstract class _$AppThemeMode extends $AsyncNotifier<ThemeModeEnum> {
  FutureOr<ThemeModeEnum> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ThemeModeEnum>, ThemeModeEnum>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeModeEnum>, ThemeModeEnum>,
              AsyncValue<ThemeModeEnum>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
