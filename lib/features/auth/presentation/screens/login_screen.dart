import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/widgets/theme_mode_switch.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/ts_button.dart';
import '../../../../core/widgets/ts_card.dart';
import '../../../../core/widgets/ts_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen<AuthState>(authControllerProvider, (_, next) {
      if (next.status == AuthStatus.authenticated) {
        final role = next.user?.role?.toLowerCase() ?? 'client';
        switch (role) {
          case 'agent':
            context.go(AppRoutes.agentDashboard);
            break;
          case 'notary':
            context.go(AppRoutes.notaryDashboard);
            break;
          case 'admin':
            context.go(AppRoutes.adminDashboard);
            break;
          default:
            context.go(AppRoutes.clientDashboard);
        }
      } else if (next.status == AuthStatus.error &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header Navigation (Back & Theme Toggle) ─────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                    ),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.initial);
                      }
                    },
                  ),
                  const Spacer(),
                  const ThemeToggleButton(),
                ],
              ),
            ),

            // ─── Scrollable Form ─────────────────────────────────────────
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // App Logo
                      const AppLogo(size: 80, showGlow: true)
                          .animate()
                          .scale(
                            begin: const Offset(0.75, 0.75),
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: 20),

                      // Title
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ).animate(delay: 150.ms).fade().slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 6),

                      Text(
                        'Sign in to your Title Secure account',
                        style: TextStyle(
                          color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight,
                          fontSize: 14,
                        ),
                      ).animate(delay: 200.ms).fade(),

                      const SizedBox(height: 28),

                  // Form card
                  TsCard(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _submitted
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (authState.status == AuthStatus.error &&
                              authState.errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.danger.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: AppColors.danger,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authState.errorMessage!,
                                      style: const TextStyle(
                                        color: AppColors.danger,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          TsTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: Validators.validateEmail,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                          ),
                          const SizedBox(height: 16),
                          TsTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            obscureText: _obscurePassword,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                            validator: Validators.validatePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.push('/forgot-password'),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TsButton.gold(
                            label: 'Sign In',
                            isLoading: isLoading,
                            backgroundColor: AppColors.gold,
                            onPressed: _submit,
                            icon: Icons.login_rounded,
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 300.ms).fade().slideY(begin: 0.15, end: 0),

                  const SizedBox(height: 24),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ).animate(delay: 450.ms).fade(),

                  // Public verify link
                  TextButton.icon(
                    onPressed: () => context.push(AppRoutes.verify),
                    icon: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                    label: const Text(
                      'Verify a title without login',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                      ),
                    ),
                  ).animate(delay: 500.ms).fade(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
