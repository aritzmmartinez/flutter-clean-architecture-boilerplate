/// Session entity - Represents an active user session
class SessionEntity {
  final String id;
  final String userId;
  final String deviceInfo;
  final String ipAddress;
  final bool isCurrentSession;
  final DateTime createdAt;
  final DateTime? lastActivityAt;

  const SessionEntity({
    required this.id,
    required this.userId,
    required this.deviceInfo,
    required this.ipAddress,
    required this.isCurrentSession,
    required this.createdAt,
    this.lastActivityAt,
  });

  /// Check if session is stale (inactive for more than 30 days)
  bool get isStale {
    final activityDate = lastActivityAt ?? createdAt;
    final difference = DateTime.now().difference(activityDate);
    return difference.inDays > 30;
  }
}
