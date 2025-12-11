// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationSettings)
const notificationSettingsProvider = NotificationSettingsProvider._();

final class NotificationSettingsProvider
    extends
        $AsyncNotifierProvider<
          NotificationSettings,
          NotificationSettingsModel
        > {
  const NotificationSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsHash();

  @$internal
  @override
  NotificationSettings create() => NotificationSettings();
}

String _$notificationSettingsHash() =>
    r'4af09116e482dd5fc1feccdefa7afd4b3683d70d';

abstract class _$NotificationSettings
    extends $AsyncNotifier<NotificationSettingsModel> {
  FutureOr<NotificationSettingsModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NotificationSettingsModel>,
              NotificationSettingsModel
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationSettingsModel>,
                NotificationSettingsModel
              >,
              AsyncValue<NotificationSettingsModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
