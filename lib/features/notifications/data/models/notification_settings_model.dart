import 'package:json_annotation/json_annotation.dart';

part 'notification_settings_model.g.dart';

@JsonSerializable()
class NotificationSettingsModel {
  final bool enabled;
  final bool portfolioChanges;
  final double portfolioChangeThreshold;
  final bool priceTargets;
  final bool upcomingDividends;
  final int dividendDaysAdvance;
  final bool dailySummary;
  final int dailySummaryHour;
  final int dailySummaryMinute;

  const NotificationSettingsModel({
    this.enabled = true,
    this.portfolioChanges = true,
    this.portfolioChangeThreshold = 5.0,
    this.priceTargets = true,
    this.upcomingDividends = true,
    this.dividendDaysAdvance = 7,
    this.dailySummary = false,
    this.dailySummaryHour = 9,
    this.dailySummaryMinute = 0,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsModelToJson(this);

  NotificationSettingsModel copyWith({
    bool? enabled,
    bool? portfolioChanges,
    double? portfolioChangeThreshold,
    bool? priceTargets,
    bool? upcomingDividends,
    int? dividendDaysAdvance,
    bool? dailySummary,
    int? dailySummaryHour,
    int? dailySummaryMinute,
  }) {
    return NotificationSettingsModel(
      enabled: enabled ?? this.enabled,
      portfolioChanges: portfolioChanges ?? this.portfolioChanges,
      portfolioChangeThreshold:
          portfolioChangeThreshold ?? this.portfolioChangeThreshold,
      priceTargets: priceTargets ?? this.priceTargets,
      upcomingDividends: upcomingDividends ?? this.upcomingDividends,
      dividendDaysAdvance: dividendDaysAdvance ?? this.dividendDaysAdvance,
      dailySummary: dailySummary ?? this.dailySummary,
      dailySummaryHour: dailySummaryHour ?? this.dailySummaryHour,
      dailySummaryMinute: dailySummaryMinute ?? this.dailySummaryMinute,
    );
  }
}
