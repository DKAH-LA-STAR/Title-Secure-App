import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/app/app.dart';
import 'package:title_secure/core/services/secure_storage.dart';
import 'package:title_secure/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  testWidgets('App renders Welcome screen initially with theme switcher and auth CTA', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        overrides: [
          secureStorageProvider.overrideWithValue(InMemorySecureStorageService()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Verify that Welcome Screen is rendered initially
    expect(find.text('Title Secure'), findsWidgets);
    expect(find.text('Get Started & Sign In'), findsOneWidget);
    expect(find.text('Verify a Land Title as Guest'), findsOneWidget);
  });
}
