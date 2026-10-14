import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:push_notification/features/notifications/local_notification_service.dart';
import 'package:push_notification/features/notifications/notification_navigation_handler.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> getFCMToken() async {
    try {
      final token = await _messaging.getToken();

      if (kDebugMode) {
        log('FCM Token: $token');
      }

      return token;
    } catch (e, stackTrace) {
      log('Failed to get FCM Token', error: e, stackTrace: stackTrace);

      return null;
    }
  }

  // الاستماع إلى تغيّر الـ Token
  void listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen(
      (newToken) {
        if (kDebugMode) {
          log('FCM Token refreshed: $newToken');
        }
      },
      onError: (Object error) {
        log('FCM Token refresh error', error: error);
      },
    );
  }

  Future<String?> init() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('Notification permission: ${settings.authorizationStatus}');

    final String? token = await _messaging.getToken();
    if (kDebugMode) {
      log('FCM Token: $token');
    }

    //  الاستماع إلى الرسائل أثناء فتح التطبيق
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Foreground message received');
      log('Message ID: ${message.messageId}');
      log('Title: ${message.notification?.title}');
      log('Body: ${message.notification?.body}');
      log('Data: ${message.data}');

      final notifications = message.notification;
      if (notifications == null) {
        return;
      }

      if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
        return;
      }

      await LocalNotificationService.instance.showNotification(
        id: message.messageId.hashCode,
        title: notifications.title ?? "New Notification",
        body: notifications.body ?? "",
        data: message.data,
      );
    });

    //  متابعة تحديث الـ Token
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        debugPrint('FCM Token refreshed: $newToken');
      }

      // لاحقًا: تحديث الـ Token على الخادم
    });
    return token;
  }

  Future<void> handelNotificationInteraction(
    NotificationNavigationHandler handler,
  ) async {
    // الحاله الاولى لو التطبيق مغلق
    final initMessage = await _messaging.getInitialMessage();
    if (initMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => handler.handler(initMessage.data),
      );
    }

    // الحاله الثانيه التطبيق فى الخلفيه
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) => handler.handler(event.data),
    );
  }
}
