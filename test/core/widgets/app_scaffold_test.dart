import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/core/theme/theme_mode_provider.dart';
import 'package:title_secure/core/widgets/app_scaffold.dart';

void main() {
  group('AppScaffold Tests', () {
    testWidgets('renders title and theme toggle button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AppScaffold(
              title: 'Test Screen',
              showBackToDashboard: false,
              body: Text('Body Content'),
            ),
          ),
        ),
      );

      expect(find.text('Test Screen'), findsOneWidget);
      expect(find.text('Body Content'), findsOneWidget);

      // Theme toggle tooltip/button is present
      expect(find.byTooltip('Switch to Light Mode'), findsNothing);
      expect(find.byTooltip('Switch to Dark Mode'), findsOneWidget);
    });

    testWidgets('shows back-to-dashboard arrow when showBackToDashboard is true', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AppScaffold(
              title: 'Sub Screen',
              showBackToDashboard: true,
              body: Text('Sub Page'),
            ),
          ),
        ),
      );

      expect(find.byTooltip('Back to Dashboard'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('theme toggle switches theme mode', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AppScaffold(
              title: 'Theme Test',
              body: Text('Content'),
            ),
          ),
        ),
      );

      // Initially system or light/dark
      final initialMode = container.read(themeModeProvider);

      // Tap theme toggle button
      final toggleButton = find.byType(IconButton).first;
      await tester.tap(toggleButton);
      await tester.pumpAndSettle();

      final newMode = container.read(themeModeProvider);
      expect(newMode, isNot(equals(initialMode)));
    });
  });
}
