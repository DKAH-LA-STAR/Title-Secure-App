import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import 'ts_card.dart';

/// Large monospace tracking code display with copy-to-clipboard action.
class TrackingCodeCard extends StatelessWidget {
  final String code;
  final String? label;

  const TrackingCodeCard({
    super.key,
    required this.code,
    this.label = 'Tracking Code',
  });

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tracking code copied!'),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TsCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondary
                    : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (label != null) const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  code,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 3.0,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.copy_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: () => _copy(context),
                tooltip: 'Copy to clipboard',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
