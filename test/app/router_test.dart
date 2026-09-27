import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/app/app.dart';
import 'package:title_secure/app/routes/app_routes.dart';
import 'package:title_secure/app/routes/router.dart';
import 'package:title_secure/core/services/secure_storage.dart';
import 'package:title_secure/features/auth/data/models/user_model.dart';
import 'package:title_secure/features/auth/presentation/controllers/auth_controller.dart';
import 'package:title_secure/features/client/presentation/screens/client_dashboard_screen.dart';

void main() {
  group('Router Authentication & Redirection Tests', () {
    testWidgets('Router redirects client to ClientDashboardScreen upon authentication', (tester) async {
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(InMemorySecureStorageService()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      final router = container.read(routerProvider);

      // Navigate to register screen
      router.go(AppRoutes.register);
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsWidgets);

      // Simulate successful client authentication
      container.read(authControllerProvider.notifier).state = const AuthState(
        status: AuthStatus.authenticated,
        user: UserModel(
          id: 1,
          name: 'Jean Dupont',
          email: 'jean@example.com',
          role: 'client',
        ),
      );

      await tester.pumpAndSettle();

      // Client should automatically be redirected to client dashboard
      expect(find.byType(ClientDashboardScreen), findsOneWidget);
    });

    testWidgets('Router stays on login screen when login status is error', (tester) async {
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(InMemorySecureStorageService()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      final router = container.read(routerProvider);

      // Navigate to login screen
      router.go(AppRoutes.login);
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);

      // Simulate login error
      container.read(authControllerProvider.notifier).state = const AuthState(
        status: AuthStatus.error,
        errorMessage: 'Invalid login credentials',
      );

      await tester.pumpAndSettle();

      // Should remain on login screen and show the error banner
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Invalid login credentials'), findsWidgets);
    });
  });
}
