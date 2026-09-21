import 'package:flutter/material.dart';

/// Title Secure design token palette.
/// All colors match the Figma spec for the dark-navy glassmorphism theme.
abstract class AppColors {
  // ─── Backgrounds ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0A0E1A); // Deep navy
  static const Color surface = Color(0xFF111827); // Card surface
  static const Color surfaceVariant = Color(0xFF1F2937); // Elevated surface

  // ─── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFF59E0B); // Amber/gold
  static const Color primaryDark = Color(0xFFD97706); // Darker amber
  static const Color secondary = Color(0xFF14B8A6); // Teal
  static const Color secondaryDark = Color(0xFF0D9488); // Darker teal

  // ─── Role Accents ─────────────────────────────────────────────────────────
  static const Color adminAccent = Color(0xFF7C3AED); // Purple (admin)
  static const Color agentAccent = Color(0xFF3B82F6); // Blue (agent)
  static const Color notaryAccent = Color(0xFF8B5CF6); // Violet (notary)

  // ─── Semantic ─────────────────────────────────────────────────────────────
  static const Color danger = Color(0xFFEF4444); // Red
  static const Color dangerLight = Color(0xFFFCA5A5);
  static const Color success = Color(0xFF10B981); // Green
  static const Color successLight = Color(0xFF6EE7B7);
  static const Color warning = Color(0xFFF59E0B); // Amber (same as primary)
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color info = Color(0xFF3B82F6); // Blue

  // ─── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFFD1D5DB);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF374151);

  // ─── Borders & Dividers ───────────────────────────────────────────────────
  static const Color border = Color(0xFF1F2937);
  static const Color borderSubtle = Color(0xFF374151);
  static const Color borderGold = Color(0x33F59E0B); // 20% amber

  // ─── Status badge backgrounds (semi-transparent) ─────────────────────────
  static const Color pendingBg = Color(0x1FF59E0B);
  static const Color verifiedBg = Color(0x1F10B981);
  static const Color rejectedBg = Color(0x1FEF4444);
  static const Color paidBg = Color(0x1F14B8A6);
  static const Color unpaidBg = Color(0x1F6B7280);

  // ─── Gold & Brand Accents ────────────────────────────────────────────────
  static const Color gold = Color(0xFFFFD700); // Standard vibrant Gold
  static const Color goldMetallic = Color(0xFFD4AF37); // Classic Metallic Gold
  static const Color goldDark = Color(0xFFC59B27); // Rich Antique Gold
  static const Color goldLight = Color(0xFFFFE57F); // Light Gold Highlight
  static const Color onGold = Color(0xFF0A0E1A); // Deep navy for high contrast on gold

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient adminGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Light Mode Tokens ───────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceVariantLight = Color(0xFFF1F5F9); // Slate 100
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLight = Color(0xFF475569); // Slate 600
  static const Color textMutedLight = Color(0xFF94A3B8); // Slate 400
  static const Color textDisabledLight = Color(0xFFCBD5E1); // Slate 300
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color borderSubtleLight = Color(0xFFF1F5F9);
  static const Color borderGoldLight = Color(0x66F59E0B); // 40% amber

  // ─── Glassmorphism ────────────────────────────────────────────────────────
  static const Color glassBackground = Color(0xCC111827); // 80% #111827
  static const Color glassBackgroundLight = Color(0xF2FFFFFF); // 95% white
  static const Color glassBorder = Color(0x33F9FAFB); // 20% white
  static const Color glassBorderLight = Color(0x1F0F172A); // 12% slate

  // ─── Shimmer ──────────────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFF1F2937);
  static const Color shimmerHighlight = Color(0xFF374151);
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF8FAFC);

  // ─── On-colors (for text/icons on brand colors) ───────────────────────────
  static const Color onPrimary = Color(0xFF0A0E1A);
  static const Color onSecondary = Color(0xFF0A0E1A);
  static const Color onSurface = Color(0xFFF9FAFB);
  static const Color onBackground = Color(0xFFF9FAFB);
}
