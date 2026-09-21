import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/widgets/theme_mode_switch.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/ts_button.dart';
import '../../../../core/widgets/ts_card.dart';

/// Landing / Welcome Screen for Title Secure.
/// Serves as the primary entry point with theme switcher, value propositions,
/// and direct navigation to Authentication before verification and document submission.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header with Logo & Theme Switcher ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const AppLogo(size: 36, showGlow: false),
                  const SizedBox(width: 10),
                  Text(
                    'Title Secure',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const Spacer(),
                  // Light / Dark mode switcher button
                  const ThemeToggleButton(),
                ],
              ),
            ),

            // ─── Scrollable Content ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ─── Hero Logo Emblem ────────────────────────────────────
                    const AppLogo(size: 110, showGlow: true)
                        .animate()
                        .fade(duration: 500.ms)
                        .scale(
                          begin: const Offset(0.85, 0.85),
                          end: const Offset(1, 1),
                          curve: Curves.easeOutBack,
                        ),

                    const SizedBox(height: 24),

                    // ─── Headline & Tagline ──────────────────────────────────
                    Text(
                      'Secure Land Title\nVerification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                      ),
                    ).animate().fade(delay: 150.ms, duration: 400.ms).slideY(begin: 0.15, end: 0),

                    const SizedBox(height: 12),

                    Text(
                      'Verify authentic property ownership, prevent double-sales, and submit title deeds for certified notary review.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                      ),
                    ).animate().fade(delay: 250.ms, duration: 400.ms),

                    const SizedBox(height: 28),

                    // ─── Feature Highlights ──────────────────────────────────
                    _buildFeatureCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.qr_code_scanner_rounded,
                      iconColor: AppColors.primary,
                      title: 'Instant QR & Title Verification',
                      description: 'Scan biometric certificates or enter title numbers for immediate authenticity check.',
                    ).animate().fade(delay: 350.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 12),

                    _buildFeatureCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.upload_file_rounded,
                      iconColor: AppColors.secondary,
                      title: 'Secure Document Submission',
                      description: 'Upload title deeds and cadastral boundary plans for legal notary validation.',
                    ).animate().fade(delay: 450.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 12),

                    _buildFeatureCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.security_rounded,
                      iconColor: AppColors.adminAccent,
                      title: 'Anti-Fraud & Duplicate Shield',
                      description: 'AI-assisted cadastral boundary cross-checks to eliminate conflicting land claims.',
                    ).animate().fade(delay: 550.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ─── Bottom Actions (Authentication & Guest Access) ──────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surface.withValues(alpha: 0.9)
                    : AppColors.surfaceLight.withValues(alpha: 0.9),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.border : AppColors.borderLight,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Primary CTA -> Go to Authentication
                  TsButton.gold(
                    label: 'Get Started & Sign In',
                    icon: Icons.arrow_forward_rounded,
                    backgroundColor: AppColors.gold,
                    onPressed: () => context.push(AppRoutes.login),
                  ),

                  const SizedBox(height: 10),

                  // Secondary CTA -> Guest Public Verification
                  TsButton.outline(
                    label: 'Verify a Land Title as Guest',
                    icon: Icons.search_rounded,
                    onPressed: () => context.push(AppRoutes.verify),
                  ),
                ],
              ),
            ).animate().fade(delay: 600.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return TsCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
