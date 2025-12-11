import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/notification_settings_model.dart';
import '../../../../core/services/notification_service.dart';

part 'notification_settings_provider.g.dart';

const String _notificationBoxName = 'notification_settings';
const String _settingsKey = 'settings';

@riverpod
class NotificationSettings extends _$NotificationSettings {
  Box<String>? _box;
  final NotificationService _notificationService = NotificationService();

  @override
  Future<NotificationSettingsModel> build() async {
    await _initBox();
    return _loadSettings();
  }

  Future<void> _initBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<String>(_notificationBoxName);
    }
  }

  Future<NotificationSettingsModel> _loadSettings() async {
    await _initBox();

    final jsonString = _box?.get(_settingsKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> json = Map<String, dynamic>.from(
          Uri.splitQueryString(
            jsonString,
          ).map((key, value) => MapEntry(key, _parseValue(value))),
        );
        return NotificationSettingsModel.fromJson(json);
      } catch (e) {
        return const NotificationSettingsModel();
      }
    }
    return const NotificationSettingsModel();
  }

  dynamic _parseValue(String value) {
    if (value == 'true') return true;
    if (value == 'false') return false;
    if (double.tryParse(value) != null) return double.parse(value);
    if (int.tryParse(value) != null) return int.parse(value);
    return value;
  }

  Future<void> _saveSettings(NotificationSettingsModel settings) async {
    await _initBox();

    final json = settings.toJson();
    final queryString = json.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
        )
        .join('&');

    await _box?.put(_settingsKey, queryString);
  }

  Future<void> updateSettings(NotificationSettingsModel settings) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _saveSettings(settings);

      if (settings.dailySummary) {
        await _notificationService.scheduleDailySummary(
          hour: settings.dailySummaryHour,
          minute: settings.dailySummaryMinute,
        );
      } else {
        await _notificationService.cancelNotification(100);
      }

      return settings;
    });
  }

  Future<void> toggleEnabled() async {
    final current = await future;
    final updated = current.copyWith(enabled: !current.enabled);
    await updateSettings(updated);

    if (!updated.enabled) {
      await _notificationService.cancelAllNotifications();
    }
  }

  Future<void> togglePortfolioChanges() async {
    final current = await future;
    await updateSettings(
      current.copyWith(portfolioChanges: !current.portfolioChanges),
    );
  }

  Future<void> setPortfolioChangeThreshold(double threshold) async {
    final current = await future;
    await updateSettings(current.copyWith(portfolioChangeThreshold: threshold));
  }

  Future<void> togglePriceTargets() async {
    final current = await future;
    await updateSettings(current.copyWith(priceTargets: !current.priceTargets));
  }

  Future<void> toggleUpcomingDividends() async {
    final current = await future;
    await updateSettings(
      current.copyWith(upcomingDividends: !current.upcomingDividends),
    );
  }

  Future<void> setDividendDaysAdvance(int days) async {
    final current = await future;
    await updateSettings(current.copyWith(dividendDaysAdvance: days));
  }

  Future<void> toggleDailySummary() async {
    final current = await future;
    await updateSettings(current.copyWith(dailySummary: !current.dailySummary));
  }

  Future<void> setDailySummaryTime(int hour, int minute) async {
    final current = await future;
    await updateSettings(
      current.copyWith(dailySummaryHour: hour, dailySummaryMinute: minute),
    );
  }

  Future<void> requestPermissions() async {
    await _notificationService.requestPermissions();
  }

  Future<bool> areNotificationsEnabled() async {
    return await _notificationService.areNotificationsEnabled();
  }
}
