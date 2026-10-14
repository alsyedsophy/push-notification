import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  void Function(Map<String, dynamic> data)? _onTap;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Channel for important notifications',
    importance: Importance.max,
  );

  Future<void> initialize({
    required void Function(Map<String, dynamic> data) onTap,
  }) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    _onTap = onTap;

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        try {
          final decodid = jsonDecode(payload);
          if (decodid is Map<String, dynamic>) {
            onTap(decodid);
          }
        } on FormatException {
          log("Formay Exception");
        }
      },
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_channel);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Channel for important notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(data),
    );
  }

  Future<void> handleAppLounchFromNotifications() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null) return;
    if (!details.didNotificationLaunchApp) return;

    final response = details.notificationResponse;
    final payload = response?.payload;

    if (payload == null || payload.isEmpty) return;

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        _onTap?.call(decoded);
      }
    } on FormatException {
      log('Invalid Notification Payload');
    }
  }
}
