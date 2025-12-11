import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  final _notificationActionController = StreamController<String>.broadcast();
  Stream<String> get notificationActionStream =>
      _notificationActionController.stream;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    try {
      final String timeZoneName = _getLocalTimeZone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('📍 Timezone configured: $timeZoneName');
      debugPrint('   Current local time: ${tz.TZDateTime.now(tz.local)}');
    } catch (e) {
      debugPrint('⚠️ Error configuring timezone, using UTC: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    debugPrint('📱 Notification tapped!');
    debugPrint('   ID: ${response.id}');
    debugPrint('   Payload: $payload');
    debugPrint('   Action ID: ${response.actionId}');
    debugPrint('   Input: ${response.input}');

    if (payload != null && payload.isNotEmpty) {
      debugPrint('✅ Emitting payload to stream: $payload');
      _notificationActionController.add(payload);
    } else {
      debugPrint('⚠️ Payload is empty or null');
    }
  }

  Future<void> requestPermissions() async {
    debugPrint('📢 Requesting notification permissions...');

    final androidPermission = await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    final iosPermission = await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    debugPrint('   Android permission: $androidPermission');
    debugPrint('   iOS permission: $iosPermission');

    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImpl != null) {
      final exactAlarmsPermission = await androidImpl
          .canScheduleExactNotifications();
      debugPrint('   Can schedule exact alarms: $exactAlarmsPermission');
      if (exactAlarmsPermission != true) {
        debugPrint(
          '⚠️ Cannot schedule exact alarms. Please request permission in settings.',
        );
      }
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? subText,
    StyleInformation? styleInformation,
    Color? color,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'investment_tracker_channel',
      'Investment Tracker',
      channelDescription: 'Notificaciones de Investment Tracker',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: color,
      subText: subText,
      styleInformation: styleInformation,
      enableVibration: true,
      playSound: true,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  Future<void> scheduleDailySummary({
    required int hour,
    required int minute,
  }) async {
    final scheduledTime = _nextInstanceOfTime(hour, minute);
    debugPrint('⏰ Scheduling daily notifications for: $scheduledTime');
    debugPrint(
      '   Requested time: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
    );
    debugPrint('   Now: ${tz.TZDateTime.now(tz.local)}');
    try {
      await _notifications.zonedSchedule(
        100,
        '📊 Daily Summary',
        'Check your portfolio performance',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_summary_channel',
            'Daily Summary',
            channelDescription: 'Daily notification with portfolio summary',
            importance: Importance.high,
            priority: Priority.high,
            color: Color(0xFF673AB7),
            styleInformation: BigTextStyleInformation(
              'It\'s time to check how your portfolio is doing today',
              htmlFormatBigText: true,
              contentTitle: '📊 Your daily summary is ready',
              htmlFormatContentTitle: true,
              summaryText: 'Investment Tracker',
              htmlFormatSummaryText: true,
            ),
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_summary',
      );
      debugPrint('✅ Notification scheduled successfully');
    } catch (e) {
      debugPrint('❌ Error scheduling notification (exactAllowWhileIdle): $e');
      try {
        await _notifications.zonedSchedule(
          100,
          '📊 Daily Summary',
          'Check your portfolio performance',
          scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'daily_summary_channel',
              'Daily Summary',
              channelDescription: 'Daily notification with portfolio summary',
              importance: Importance.high,
              priority: Priority.high,
              color: Color(0xFF673AB7),
              styleInformation: BigTextStyleInformation(
                'It\'s time to check how your portfolio is doing today',
                htmlFormatBigText: true,
                contentTitle: '📊 Your daily summary is ready',
                htmlFormatContentTitle: true,
                summaryText: 'Investment Tracker',
                htmlFormatSummaryText: true,
              ),
              enableVibration: true,
              playSound: true,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'daily_summary',
        );
        debugPrint('✅ Notification scheduled with alarmClock');
      } catch (e2) {
        debugPrint('❌ Failed to schedule notification (alarmClock): $e2');
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<bool> areNotificationsEnabled() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }

    return true;
  }

  void dispose() {
    _notificationActionController.close();
  }

  String _getLocalTimeZone() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    final offsetHours = offset.inHours;
    final offsetMinutes = offset.inMinutes % 60;

    debugPrint(
      '   System offset: UTC${offsetHours >= 0 ? '+' : ''}$offsetHours${offsetMinutes != 0 ? ':${offsetMinutes.abs()}' : ''}',
    );

    final commonTimezones = [];

    for (final timezoneName in commonTimezones) {
      try {
        final location = tz.getLocation(timezoneName);
        final tzNow = tz.TZDateTime.from(now, location);
        if (tzNow.timeZoneOffset == offset) {
          return timezoneName;
        }
      } catch (e) {}
    }

    if (offsetHours == 0) return 'UTC';
    if (offsetHours == 1) return 'Europe/Paris';
    if (offsetHours == 2) return 'Europe/Helsinki';
    if (offsetHours == -5) return 'America/New_York';
    if (offsetHours == -6) return 'America/Chicago';
    if (offsetHours == -8) return 'America/Los_Angeles';

    return 'UTC';
  }
}
