import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/theme/widgets/theme_mode_switch.dart';
import '../../../../core/widgets/ts_button.dart';
import '../../../../core/widgets/ts_card.dart';
import '../../../../core/widgets/ts_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart'; // provides apiClientProvider

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.post(
        ApiEndpoints.forgotPassword,
        body: {'email': _emailController.text.trim()},
      );
      if (mounted) setState(() => _sent = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send reset email. Try again.'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.backgroundLight,
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Back button + Theme Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/login');
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                          size: 20,
                        ),
                      ),
                      const ThemeToggleButton(),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 20),

                  Text(
                    'Reset Password',
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate(delay: 100.ms).fade(),

                  const SizedBox(height: 8),

                  Text(
                    'Enter your email to receive a reset link',
                    style: TextStyle(color: isDark ? AppColors.textSecondary : Colors.black87, fontSize: 14),
                    textAlign: TextAlign.center,
                  ).animate(delay: 150.ms).fade(),

                  const SizedBox(height: 32),

                  if (_sent)
                    TsCard(
                      padding: const EdgeInsets.all(24),
                      borderColor: AppColors.success.withValues(alpha: 0.4),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.mark_email_read_rounded,
                            color: AppColors.success,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Reset link sent!',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check ${_emailController.text} for instructions.',
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondary : Colors.black87,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TsButton(
                            text: 'Back to Login',
                            variant: TsButtonVariant.ghost,
                            onPressed: () => context.go('/login'),
                          ),
                        ],
                      ),
                    ).animate().fade().scale()
                  else
                    TsCard(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TsTextField(
                              controller: _emailController,
                              labelText: 'Email address',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email_outlined),
                              validator: Validators.validateEmail,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: 20),
                            TsButton(
                              text: 'Send Reset Link',
                              isLoading: _isLoading,
                              onPressed: _submit,
                              icon: Icons.send_rounded,
                            ),
                          ],
                        ),
                      ),
                    ).animate(delay: 200.ms).fade().slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
