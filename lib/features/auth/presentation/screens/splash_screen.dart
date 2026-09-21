import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../presentation/controllers/auth_controller.dart';

/// Animated splash screen with shield logo.
/// Auto-redirects based on stored auth token via [AuthController.checkAuthStatus].
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state to settle, then redirect
    ref.listen<AuthState>(authControllerProvider, (_, next) {
      if (next.status == AuthStatus.authenticated) {
        final role = next.user?.role?.toLowerCase() ?? 'client';
        switch (role) {
          case 'agent':
            context.go('/agent/dashboard');
            break;
          case 'notary':
            context.go('/notary/dashboard');
            break;
          case 'admin':
            context.go('/admin/dashboard');
            break;
          default:
            context.go('/client/dashboard');
        }
      } else if (next.status == AuthStatus.unauthenticated) {
        context.go('/login');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shield logo with glow
              AnimatedBuilder(
                animation: _glowController,
                builder: (_, __) => Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: 0.2 + _glowController.value * 0.3,
                        ),
                        blurRadius: 40 + _glowController.value * 20,
                        spreadRadius: 5 + _glowController.value * 10,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.surface,
                          AppColors.background,
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: AppColors.primary,
                      size: 56,
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                  )
                  .fade(duration: 600.ms),

              const SizedBox(height: 32),

              // App name
              const Text(
                'TITLE SECURE',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                ),
              )
                  .animate(delay: 400.ms)
                  .fade(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 8),

              const Text(
                'Secure Land. Secure Future.',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              )
                  .animate(delay: 600.ms)
                  .fade(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 80),

              // Loading indicator
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
                  .animate(delay: 800.ms)
                  .fade(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
