class ActivityLogModel {
  final String id;
  final String action;
  final String description;
  final String? ipAddress;
  final String? userAgent;
  final String? deviceName;
  final DateTime createdAt;

  ActivityLogModel({
    required this.id,
    required this.action,
    required this.description,
    this.ipAddress,
    this.userAgent,
    this.deviceName,
    required this.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'] as String,
      action: json['action'] as String,
      description: json['description'] as String,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      deviceName: json['device_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'description': description,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (userAgent != null) 'user_agent': userAgent,
      if (deviceName != null) 'device_name': deviceName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ActivityLogListModel {
  final List<ActivityLogModel> activities;
  final int total;

  ActivityLogListModel({
    required this.activities,
    required this.total,
  });

  factory ActivityLogListModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogListModel(
      activities: (json['activities'] as List)
          .map((activity) => ActivityLogModel.fromJson(activity))
          .toList(),
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'total': total,
    };
  }
}
