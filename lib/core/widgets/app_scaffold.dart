import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../constants/app_colors.dart';
import '../theme/theme_mode_provider.dart';

/// Shared scaffold used across Title Secure screens.
///
/// Features:
///  - **Theme Switcher**: Animated Light / Dark theme toggle button in the AppBar.
///  - **Back to Dashboard**: Dedicated arrow on sub-pages to navigate directly back to the dashboard.
class AppScaffold extends ConsumerWidget {
  final Widget body;
  final String title;
  final List<Widget>? extraActions;

  /// Set to true on sub-pages (e.g., Submit, Track, Certificate, Payment, SMS Broadcast).
  /// Shows a back arrow that directly returns the user to their role-specific dashboard.
  final bool showBackToDashboard;

  /// When true, the Scaffold's built-in AppBar is used.
  /// Set to false if the child manages its own AppBar or is full-screen.
  final bool showAppBar;

  /// Optional PreferredSizeWidget override for a custom AppBar.
  final PreferredSizeWidget? customAppBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Background color override.
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.title = 'Title Secure',
    this.extraActions,
    this.showBackToDashboard = false,
    this.showAppBar = true,
    this.customAppBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  /// Returns the correct dashboard route for the signed-in user's role.
  static String dashboardRouteForRole(String? role) {
    switch ((role ?? '').toLowerCase()) {
      case 'admin':
        return AppRoutes.adminDashboard;
      case 'agent':
        return AppRoutes.agentDashboard;
      case 'notary':
        return AppRoutes.notaryDashboard;
      case 'client':
      default:
        return AppRoutes.clientDashboard;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider);
    final role = authState.user?.role;
    final targetDashboard = dashboardRouteForRole(role);

    // ── Build AppBar ──────────────────────────────────────────────────────────
    final PreferredSizeWidget effectiveAppBar = customAppBar ??
        AppBar(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          leading: showBackToDashboard
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  tooltip: 'Back to Dashboard',
                  onPressed: () {
                    // Navigate directly to the role dashboard as requested
                    context.go(targetDashboard);
                  },
                )
              : null,
          actions: [
            // ── Light / Dark Mode Switcher ────────────────────────────────────
            Tooltip(
              message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: anim,
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: Icon(
                    isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                    key: ValueKey(isDark),
                    color: isDark ? AppColors.goldLight : AppColors.primary,
                  ),
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
            ),
            if (extraActions != null) ...extraActions!,
          ],
        );

    return Scaffold(
      backgroundColor: backgroundColor ??
          (isDark ? AppColors.background : AppColors.backgroundLight),
      appBar: showAppBar ? effectiveAppBar : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
