import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/auth_form_card.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _submitted = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AuthFormCard(
            title: 'Forgot Password',
            child: _submitted
                ? Column(
                    children: [
                      const Icon(Icons.mark_email_read_outlined, size: 64, color: Colors.green),
                      const SizedBox(height: 16),
                      const Text(
                        'Password reset instructions have been sent to your email.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Back to Login',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Enter your email address to receive reset instructions.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Send Instructions',
                          isLoading: _isLoading,
                          onPressed: _onSubmit,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
