import 'package:go_router/go_router.dart';

class NotificationNavigationHandler {
  final GoRouter router;

  NotificationNavigationHandler(this.router);

  void handler(Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case 'service_request':
        final requestId = data['requestId'];

        if (requestId is String && requestId.isNotEmpty) {
          router.go('/service-requests/$requestId');
        }
        break;

      case 'chat':
        final conversationId = data['conversationId'];

        if (conversationId is String && conversationId.isNotEmpty) {
          router.go('/chats/$conversationId');
        }
        break;

      default:
        // نوع إشعار غير معروف: لا تنفذ أي تنقل.
        break;
    }
  }
}
