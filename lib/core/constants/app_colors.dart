import 'package:flutter/material.dart';

/// Title Secure design token palette.
/// Uniform blue theme throughout the app.
abstract class AppColors {
  // ─── Backgrounds ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0A0F1E); // Deep navy blue
  static const Color surface = Color(0xFF0D1B2A); // Card surface
  static const Color surfaceVariant = Color(0xFF1A2A40); // Elevated surface

  // ─── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1565C0); // Primary blue
  static const Color primaryDark = Color(0xFF0D47A1); // Darker blue
  static const Color secondary = Color(0xFF1E88E5); // Medium blue
  static const Color secondaryDark = Color(0xFF1565C0); // Darker medium blue

  // ─── Role Accents ─────────────────────────────────────────────────────────
  static const Color adminAccent = Color(0xFF0288D1); // Light blue (admin)
  static const Color agentAccent = Color(0xFF1976D2); // Blue (agent)
  static const Color notaryAccent = Color(0xFF01579B); // Dark blue (notary)

  // ─── Semantic ─────────────────────────────────────────────────────────────
  static const Color danger = Color(0xFFEF4444); // Red
  static const Color dangerLight = Color(0xFFFCA5A5);
  static const Color success = Color(0xFF10B981); // Green
  static const Color successLight = Color(0xFF6EE7B7);
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color info = Color(0xFF1E88E5); // Blue

  // ─── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFFD1D5DB);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFF374151);

  /// Returns white in dark mode, black in light mode.
  static Color adaptiveText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

  /// Returns off-white in dark mode, dark slate in light mode.
  static Color adaptiveSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF1F2937);

  /// Returns light gray in dark mode, medium dark in light mode.
  static Color adaptiveMuted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563);

  // ─── Borders & Dividers ───────────────────────────────────────────────────
  static const Color border = Color(0xFF1A2A40);
  static const Color borderSubtle = Color(0xFF243B55);
  static const Color borderGold = Color(0x331565C0); // 20% primary blue

  // ─── Status badge backgrounds (semi-transparent) ─────────────────────────
  static const Color pendingBg = Color(0x1F1E88E5);
  static const Color verifiedBg = Color(0x1F10B981);
  static const Color rejectedBg = Color(0x1FEF4444);
  static const Color paidBg = Color(0x1F1565C0);
  static const Color unpaidBg = Color(0x1F6B7280);

  // ─── Blue Brand Accents ───────────────────────────────────────────────────
  static const Color gold = Color(0xFF1565C0); // Mapped to primary blue
  static const Color goldMetallic = Color(0xFF1976D2); // Blue variant
  static const Color goldDark = Color(0xFF0D47A1); // Dark blue
  static const Color goldLight = Color(0xFF42A5F5); // Light blue highlight
  static const Color onGold = Color(0xFFF9FAFB); // White text on blue

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient adminGradient = LinearGradient(
    colors: [Color(0xFF0288D1), Color(0xFF01579B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0F1E), Color(0xFF0D1B2A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Light Mode Tokens ───────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF0F4FF); // Light blue tint
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceVariantLight = Color(0xFFE3EAF8); // Blue-tinted slate
  static const Color textPrimaryLight = Color(0xFF000000); // Pure black
  static const Color textSecondaryLight = Color(0xFF1F2937); // Dark near-black
  static const Color textMutedLight = Color(0xFF374151); // Dark charcoal for high visibility
  static const Color textDisabledLight = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFBDD0E8); // Light blue border
  static const Color borderSubtleLight = Color(0xFFE3EAF8);
  static const Color borderGoldLight = Color(0x661565C0); // 40% primary blue

  // ─── Glassmorphism ────────────────────────────────────────────────────────
  static const Color glassBackground = Color(0xCC0D1B2A); // 80% surface
  static const Color glassBackgroundLight = Color(0xF2FFFFFF); // 95% white
  static const Color glassBorder = Color(0x331E88E5); // 20% blue
  static const Color glassBorderLight = Color(0x1F1565C0); // 12% blue

  // ─── Shimmer ──────────────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFF1A2A40);
  static const Color shimmerHighlight = Color(0xFF243B55);
  static const Color shimmerBaseLight = Color(0xFFBDD0E8);
  static const Color shimmerHighlightLight = Color(0xFFE3EAF8);

  // ─── On-colors (for text/icons on brand colors) ───────────────────────────
  static const Color onPrimary = Color(0xFFF9FAFB);
  static const Color onSecondary = Color(0xFFF9FAFB);
  static const Color onSurface = Color(0xFFF9FAFB);
  static const Color onBackground = Color(0xFFF9FAFB);
}
