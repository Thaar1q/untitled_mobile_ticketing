import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_error_view.dart';
import '../features/admin/presentation/screens/admin_ticket_management_screen.dart';
import '../features/auth/domain/models/app_user.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/common/presentation/screens/forbidden_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/tickets/presentation/screens/create_ticket_screen.dart';
import '../features/tickets/presentation/screens/ticket_detail_screen.dart';
import '../features/tickets/presentation/screens/tickets_list_screen.dart';
import 'app_routes.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this.ref) {
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  final Ref ref;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.tickets,
        builder: (context, state) => const TicketsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.createTicket,
        builder: (context, state) => const CreateTicketScreen(),
      ),
      GoRoute(
        path: AppRoutes.ticketDetail,
        builder: (context, state) {
          final ticketId = state.pathParameters['ticketId'] ?? '';
          return TicketDetailScreen(ticketId: ticketId);
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminTickets,
        builder: (context, state) => const AdminTicketManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.forbidden,
        builder: (context, state) => const ForbiddenScreen(),
      ),
    ],
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final location = state.matchedLocation;
      final isAuthRoute =
          location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.resetPassword;

      if (!auth.initialized) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      if (!auth.isAuthenticated) {
        return isAuthRoute ? null : AppRoutes.login;
      }

      if (location == AppRoutes.splash || isAuthRoute) {
        return AppRoutes.dashboard;
      }

      if (location == AppRoutes.adminTickets &&
          !auth.hasAnyRole({UserRole.helpdesk, UserRole.admin})) {
        return AppRoutes.forbidden;
      }

      if (location == AppRoutes.forbidden &&
          auth.hasAnyRole({UserRole.helpdesk, UserRole.admin})) {
        return AppRoutes.adminTickets;
      }

      return null;
    },
    errorBuilder: (context, state) {
      return Scaffold(
        body: AppErrorView(
          message: 'Halaman tidak ditemukan.',
          onRetry: () {
            final auth = ref.read(authStateProvider);
            context.go(
              auth.isAuthenticated ? AppRoutes.dashboard : AppRoutes.login,
            );
          },
        ),
      );
    },
  );
});
