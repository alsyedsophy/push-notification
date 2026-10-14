import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/app/app.dart';
import 'package:push_notification/app/router/app_router.dart';
import 'package:push_notification/features/notifications/firebase_messaging_background_handler.dart';
import 'package:push_notification/features/notifications/local_notification_service.dart';
import 'package:push_notification/features/notifications/notification_navigation_handler.dart';
import 'package:push_notification/features/notifications/notification_service.dart';
import 'package:push_notification/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.instance.getFCMToken();
  NotificationService.instance.listenToTokenRefresh();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final notificationNavigationHandler = NotificationNavigationHandler(
    appRouter,
  );

  await LocalNotificationService.instance.initialize(
    onTap: notificationNavigationHandler.handler,
  );

  await LocalNotificationService.instance.handleAppLounchFromNotifications();

  await NotificationService.instance.init();
  await NotificationService.instance.handelNotificationInteraction(
    notificationNavigationHandler,
  );
  runApp(const MyApp());
}
