// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettingsModel _$NotificationSettingsModelFromJson(
  Map<String, dynamic> json,
) => NotificationSettingsModel(
  enabled: json['enabled'] as bool? ?? true,
  portfolioChanges: json['portfolioChanges'] as bool? ?? true,
  portfolioChangeThreshold:
      (json['portfolioChangeThreshold'] as num?)?.toDouble() ?? 5.0,
  priceTargets: json['priceTargets'] as bool? ?? true,
  upcomingDividends: json['upcomingDividends'] as bool? ?? true,
  dividendDaysAdvance: (json['dividendDaysAdvance'] as num?)?.toInt() ?? 7,
  dailySummary: json['dailySummary'] as bool? ?? false,
  dailySummaryHour: (json['dailySummaryHour'] as num?)?.toInt() ?? 9,
  dailySummaryMinute: (json['dailySummaryMinute'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$NotificationSettingsModelToJson(
  NotificationSettingsModel instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'portfolioChanges': instance.portfolioChanges,
  'portfolioChangeThreshold': instance.portfolioChangeThreshold,
  'priceTargets': instance.priceTargets,
  'upcomingDividends': instance.upcomingDividends,
  'dividendDaysAdvance': instance.dividendDaysAdvance,
  'dailySummary': instance.dailySummary,
  'dailySummaryHour': instance.dailySummaryHour,
  'dailySummaryMinute': instance.dailySummaryMinute,
};
