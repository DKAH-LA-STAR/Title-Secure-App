import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/core/services/secure_storage.dart';
import 'package:title_secure/core/widgets/ts_button.dart';
import 'package:title_secure/features/auth/presentation/controllers/auth_controller.dart';
import 'package:title_secure/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:title_secure/features/auth/presentation/screens/login_screen.dart';
import 'package:title_secure/features/auth/presentation/screens/register_screen.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return ProviderScope(
      overrides: [
        secureStorageProvider.overrideWithValue(InMemorySecureStorageService()),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders login screen with email, password fields and buttons', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const LoginScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Sign In'), findsWidgets);
    });

    testWidgets('shows validation errors when submitting empty form', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const LoginScreen()));
      await tester.pumpAndSettle();

      // Tap Sign In button
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });
  });

  group('RegisterScreen Widget Tests', () {
    testWidgets('renders register screen with required fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const RegisterScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsWidgets);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.widgetWithText(TsButton, 'Create Account'), findsOneWidget);
    });

    testWidgets('shows validation error if passwords do not match', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const RegisterScreen()));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'John Doe');
      await tester.enterText(fields.at(1), 'john@example.com');
      await tester.enterText(fields.at(3), 'password123');
      await tester.enterText(fields.at(4), 'mismatch123');

      final buttonFinder = find.widgetWithText(TsButton, 'Create Account');
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('submits registration form with matching passwords and valid fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const RegisterScreen()));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Amadou Bello');
      await tester.enterText(fields.at(1), 'amadou@example.cm');
      await tester.enterText(fields.at(2), '+237690000000');
      await tester.enterText(fields.at(3), 'SecurePass123!');
      await tester.enterText(fields.at(4), 'SecurePass123!');

      final buttonFinder = find.widgetWithText(TsButton, 'Create Account');
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // No client-side validation errors should be displayed
      expect(find.text('Name is required'), findsNothing);
      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(find.text('Passwords do not match'), findsNothing);
    });
  });

  group('ForgotPasswordScreen Widget Tests', () {
    testWidgets('renders forgot password screen and handles reset request', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'user@example.com');
      final submitFinder = find.widgetWithText(TsButton, 'Send Reset Link');
      await tester.ensureVisible(submitFinder);
      await tester.tap(submitFinder);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
    });
  });
}
