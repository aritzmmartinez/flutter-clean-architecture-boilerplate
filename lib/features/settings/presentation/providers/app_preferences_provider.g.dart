// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appPreferencesService)
const appPreferencesServiceProvider = AppPreferencesServiceProvider._();

final class AppPreferencesServiceProvider
    extends
        $FunctionalProvider<
          AppPreferencesService,
          AppPreferencesService,
          AppPreferencesService
        >
    with $Provider<AppPreferencesService> {
  const AppPreferencesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPreferencesServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesServiceHash();

  @$internal
  @override
  $ProviderElement<AppPreferencesService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppPreferencesService create(Ref ref) {
    return appPreferencesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferencesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferencesService>(value),
    );
  }
}

String _$appPreferencesServiceHash() =>
    r'4bef2e9dcab928fc18ffc321fc5d36f8b9e60d71';

@ProviderFor(AppPreferences)
const appPreferencesProvider = AppPreferencesProvider._();

final class AppPreferencesProvider
    extends $AsyncNotifierProvider<AppPreferences, AppPreferencesModel> {
  const AppPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesHash();

  @$internal
  @override
  AppPreferences create() => AppPreferences();
}

String _$appPreferencesHash() => r'4502f932da917732a93667aa74776315d127df25';

abstract class _$AppPreferences extends $AsyncNotifier<AppPreferencesModel> {
  FutureOr<AppPreferencesModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<AppPreferencesModel>, AppPreferencesModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppPreferencesModel>, AppPreferencesModel>,
              AsyncValue<AppPreferencesModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
