import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_mode_provider.dart';
import 'routes/router.dart';

class App extends ConsumerWidget {
  final List<Override> overrides;

  const App({super.key, this.overrides = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (overrides.isNotEmpty) {
      return ProviderScope(
        overrides: overrides,
        child: const AppContent(),
      );
    }
    return const AppContent();
  }
}

class AppContent extends ConsumerWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Title Secure',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // ─── Localization ───────────────────────────────────────────────────
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
      ],

      routerConfig: router,
    );
  }
}
