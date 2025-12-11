import '../../domain/entities/session_entity.dart';

/// Session Model - Extends SessionEntity
class SessionModel extends SessionEntity {
  final String? userAgent;
  final String? deviceName;

  const SessionModel({
    required super.id,
    required super.userId,
    required String deviceInfo,
    required super.ipAddress,
    required super.isCurrentSession,
    required super.createdAt,
    super.lastActivityAt,
    this.userAgent,
    this.deviceName,
  }) : super(deviceInfo: deviceInfo);

  // Legacy alias for backwards compatibility
  bool get isCurrent => isCurrentSession;

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final userAgent = json['user_agent'] as String?;
    final deviceName = json['device_name'] as String?;
    final deviceInfo = deviceName ?? userAgent ?? 'Unknown Device';

    return SessionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      deviceInfo: deviceInfo,
      ipAddress: json['ip_address'] as String? ?? 'Unknown',
      isCurrentSession: json['is_current'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActivityAt: json['last_used'] != null
          ? DateTime.parse(json['last_used'] as String)
          : null,
      userAgent: userAgent,
      deviceName: deviceName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      if (lastActivityAt != null) 'last_used': lastActivityAt!.toIso8601String(),
      if (ipAddress != 'Unknown') 'ip_address': ipAddress,
      if (userAgent != null) 'user_agent': userAgent,
      if (deviceName != null) 'device_name': deviceName,
      'is_current': isCurrentSession,
    };
  }
}

class SessionsListModel {
  final List<SessionModel> sessions;
  final int total;

  SessionsListModel({
    required this.sessions,
    required this.total,
  });

  factory SessionsListModel.fromJson(Map<String, dynamic> json) {
    return SessionsListModel(
      sessions: (json['sessions'] as List)
          .map((session) => SessionModel.fromJson(session))
          .toList(),
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'total': total,
    };
  }
}
