import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/broadcast_sms_screen.dart';
import '../../features/agent/presentation/screens/agent_dashboard_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/client/presentation/screens/certificate_screen.dart';
import '../../features/client/presentation/screens/client_dashboard_screen.dart';
import '../../features/client/presentation/screens/client_submit_screen.dart';
import '../../features/client/presentation/screens/client_track_screen.dart';
import '../../features/client/presentation/screens/payment_screen.dart';
import '../../features/notary/presentation/screens/notary_exception_review_screen.dart';
import '../../features/public/presentation/screens/public_verification_screen.dart';
import 'app_routes.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authControllerProvider,
      (_, __) => notifyListeners(),
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authControllerProvider);
    final isLoggedIn = authState.status == AuthStatus.authenticated;
    final matched = state.matchedLocation;

    // Unauthenticated public routes
    final isPublicRoute = matched == AppRoutes.initial ||
        matched == AppRoutes.welcome ||
        matched == AppRoutes.login ||
        matched == AppRoutes.register ||
        matched == AppRoutes.forgotPassword ||
        matched == AppRoutes.verify;

    // Checking local storage token or auth state loading - preserve current view
    if (authState.status == AuthStatus.initial ||
        authState.status == AuthStatus.loading) {
      return null;
    }

    // Restrict unauthenticated users to public routes
    if (!isLoggedIn) {
      if (isPublicRoute) return null;
      return AppRoutes.initial;
    }

    // Role-based dashboard determination
    final role = authState.user?.role?.toLowerCase() ?? 'client';
    String roleHome;
    switch (role) {
      case 'agent':
        roleHome = AppRoutes.agentDashboard;
        break;
      case 'notary':
        roleHome = AppRoutes.notaryDashboard;
        break;
      case 'admin':
        roleHome = AppRoutes.adminDashboard;
        break;
      case 'client':
      default:
        roleHome = AppRoutes.clientDashboard;
        break;
    }

    // Authenticated user trying to view login, register, or welcome screen
    if (matched == AppRoutes.login ||
        matched == AppRoutes.register ||
        matched == AppRoutes.initial ||
        matched == AppRoutes.welcome) {
      return roleHome;
    }

    // Restrict role access to appropriate subroutes
    if (matched.startsWith('/client') && role != 'client' && role != 'admin') {
      return roleHome;
    }
    if (matched.startsWith('/agent') && role != 'agent' && role != 'admin') {
      return roleHome;
    }
    if (matched.startsWith('/notary') && role != 'notary' && role != 'admin') {
      return roleHome;
    }
    if (matched.startsWith('/admin') && role != 'admin') {
      return roleHome;
    }

    return null;
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.initial,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: AppRoutes.initial,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
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
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verify,
        builder: (context, state) => const PublicVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.clientDashboard,
        builder: (context, state) => const ClientDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.clientSubmit,
        builder: (context, state) => const ClientSubmitScreen(),
      ),
      GoRoute(
        path: AppRoutes.clientTrack,
        builder: (context, state) {
          final code = state.uri.queryParameters['code'];
          return ClientTrackScreen(initialCode: code);
        },
      ),
      GoRoute(
        path: AppRoutes.clientCertificate,
        builder: (context, state) => const CertificateScreen(),
      ),
      GoRoute(
        path: AppRoutes.clientPayment,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: AppRoutes.agentDashboard,
        builder: (context, state) => const AgentDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.notaryDashboard,
        builder: (context, state) => const NotaryExceptionReviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.notaryExceptions,
        builder: (context, state) => const NotaryExceptionReviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminBroadcastSms,
        builder: (context, state) => const BroadcastSmsScreen(),
      ),
    ],
  );
});
