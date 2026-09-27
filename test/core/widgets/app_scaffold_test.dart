import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/core/theme/theme_mode_provider.dart';
import 'package:title_secure/core/widgets/app_scaffold.dart';
import 'package:title_secure/core/widgets/corner_logos_overlay.dart';

void main() {
  group('CornerLogosOverlay Tests', () {
    testWidgets('renders all four corner logos and child content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CornerLogosOverlay(
              child: Center(child: Text('Main Content')),
            ),
          ),
        ),
      );

      // Verify child content exists
      expect(find.text('Main Content'), findsOneWidget);

      // Verify 4 corner logos exist (4 Image or Icon fallback widgets inside CornerLogosOverlay)
      final positionedWidgets = find.descendant(
        of: find.byType(CornerLogosOverlay),
        matching: find.byType(Positioned),
      );
      expect(positionedWidgets, findsNWidgets(4));
    });
  });

  group('AppScaffold Tests', () {
    testWidgets('renders title, theme toggle button, and corner logos', (tester) async {
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
      expect(find.byType(CornerLogosOverlay), findsOneWidget);

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
