import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/app/app.dart';

void main() {
  testWidgets('App renders login screen initially', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify that login screen is rendered
    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Login'), findsOneWidget);
  });
}
