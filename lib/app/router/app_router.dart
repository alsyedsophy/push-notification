import 'package:go_router/go_router.dart';
import 'package:push_notification/features/home/home_page.dart';
import 'package:push_notification/features/service_requests/service_request_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(
      path: '/service-requests/:requestId',
      builder: (context, state) {
        final requestId = state.pathParameters['requestId']!;
        return ServiceRequestScreen(requestId: requestId);
      },
    ),
  ],
);
