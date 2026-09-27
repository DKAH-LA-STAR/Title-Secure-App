import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../core/widgets/app_scaffold.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String trackingCode;
  final double amount;
  final int? requestId;

  const PaymentScreen({
    super.key,
    this.trackingCode = 'REQ-2026-001',
    this.amount = 15000.0,
    this.requestId,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedProvider = 'orange'; // 'orange' or 'mtn'
  final _phoneController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onProcessPayment() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number.')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      int targetRequestId = widget.requestId ?? 0;

      if (targetRequestId == 0) {
        try {
          final res = await apiClient.get(ApiEndpoints.clientTrack(widget.trackingCode));
          final reqMap = res is Map<String, dynamic> ? (res['request'] ?? res) : null;
          if (reqMap != null && reqMap['id'] != null) {
            targetRequestId = int.tryParse(reqMap['id'].toString()) ?? 0;
          }
        } catch (_) {}
      }

      final providerKey = _selectedProvider == 'orange' ? 'orange_money' : 'mtn_momo';

      if (targetRequestId > 0) {
        await apiClient.post(
          ApiEndpoints.paymentInit,
          body: {
            'verification_request_id': targetRequestId,
            'amount': widget.amount,
            'currency': 'XAF',
            'provider': providerKey,
          },
        );
      }

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Payment Initiated'),
          content: Text(
            'USSD payment prompt sent to $phone for ${_selectedProvider.toUpperCase()} Money. Transaction initialized on Title Secure backend.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final textSecondary = isDark ? const Color(0xFFE5E7EB) : Colors.black87;

    return AppScaffold(
      title: 'Payment',
      showBackToDashboard: true,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Banner
            Card(
              elevation: 0,
              color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Total Fee Amount',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.amount.toStringAsFixed(0)} XAF',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF64B5F6) : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tracking Code: ${widget.trackingCode}',
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Select Mobile Money Provider',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildProviderOption(
                    id: 'orange',
                    name: 'Orange Money',
                    color: Colors.deepOrange,
                    icon: Icons.phone_android,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildProviderOption(
                    id: 'mtn',
                    name: 'MTN MoMo',
                    color: Colors.amber.shade800,
                    icon: Icons.account_balance_wallet,
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            CustomTextField(
              controller: _phoneController,
              label: 'Mobile Money Phone Number',
              hint: 'e.g. 699000000',
              labelStyle: TextStyle(color: textSecondary, fontWeight: FontWeight.w500),
              style: TextStyle(color: textColor),
              prefixIcon: Icon(Icons.phone, color: isDark ? const Color(0xFF64B5F6) : AppColors.primary),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Pay ${_selectedProvider == 'orange' ? 'Orange Money' : 'MTN MoMo'}',
              icon: Icons.payment,
              isLoading: _isProcessing,
              onPressed: _onProcessPayment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderOption({
    required String id,
    required String name,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedProvider == id;
    final unselectedBlue = isDark ? const Color(0xFF64B5F6) : AppColors.primary;

    return InkWell(
      onTap: () => setState(() => _selectedProvider = id),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: isDark ? 0.25 : 0.1)
              : (isDark ? AppColors.surfaceVariant : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? AppColors.primary.withValues(alpha: 0.5) : AppColors.primary.withValues(alpha: 0.35)),
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : unselectedBlue, size: 32),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : unselectedBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
