import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Status badge enumerations matching backend values.
enum TsStatus {
  pending,
  verified,
  rejected,
  paid,
  unpaid,
  active,
  inactive,
  processing,
  failed,
  duplicate,
  underReview,
  valid,
  invalid,
}

extension TsStatusX on TsStatus {
  Color get backgroundColor {
    switch (this) {
      case TsStatus.pending:
        return AppColors.pendingBg;
      case TsStatus.verified:
      case TsStatus.paid:
      case TsStatus.active:
      case TsStatus.valid:
        return AppColors.verifiedBg;
      case TsStatus.rejected:
      case TsStatus.failed:
      case TsStatus.duplicate:
      case TsStatus.invalid:
        return AppColors.rejectedBg;
      case TsStatus.processing:
        return AppColors.paidBg;
      case TsStatus.underReview:
        return AppColors.pendingBg;
      case TsStatus.unpaid:
      case TsStatus.inactive:
        return AppColors.unpaidBg;
    }
  }

  Color get textColor {
    switch (this) {
      case TsStatus.pending:
      case TsStatus.underReview:
        return AppColors.primary;
      case TsStatus.verified:
      case TsStatus.paid:
      case TsStatus.active:
      case TsStatus.valid:
        return AppColors.success;
      case TsStatus.rejected:
      case TsStatus.failed:
      case TsStatus.duplicate:
      case TsStatus.invalid:
        return AppColors.danger;
      case TsStatus.processing:
        return AppColors.secondary;
      case TsStatus.unpaid:
      case TsStatus.inactive:
        return AppColors.textMuted;
    }
  }

  IconData? get icon {
    switch (this) {
      case TsStatus.verified:
      case TsStatus.valid:
        return Icons.verified_rounded;
      case TsStatus.rejected:
      case TsStatus.invalid:
      case TsStatus.failed:
        return Icons.cancel_rounded;
      case TsStatus.pending:
      case TsStatus.underReview:
        return Icons.schedule_rounded;
      case TsStatus.paid:
        return Icons.check_circle_rounded;
      case TsStatus.duplicate:
        return Icons.warning_rounded;
      case TsStatus.processing:
        return Icons.sync_rounded;
      default:
        return null;
    }
  }

  String label(String raw) {
    return raw.replaceAll('_', ' ').split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');
  }
}

/// Colored pill badge for request/payment/validity status values.
class StatusBadge extends StatelessWidget {
  final String status;
  final bool showIcon;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.fontSize = 12,
  });

  TsStatus _parseStatus() {
    switch (status.toLowerCase()) {
      case 'verified':
        return TsStatus.verified;
      case 'rejected':
        return TsStatus.rejected;
      case 'paid':
        return TsStatus.paid;
      case 'unpaid':
        return TsStatus.unpaid;
      case 'processing':
        return TsStatus.processing;
      case 'failed':
        return TsStatus.failed;
      case 'duplicate':
        return TsStatus.duplicate;
      case 'under_review':
      case 'under review':
        return TsStatus.underReview;
      case 'valid':
        return TsStatus.valid;
      case 'invalid':
        return TsStatus.invalid;
      case 'active':
        return TsStatus.active;
      case 'inactive':
        return TsStatus.inactive;
      case 'pending':
      default:
        return TsStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tsStatus = _parseStatus();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tsStatus.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tsStatus.textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && tsStatus.icon != null) ...[
            Icon(tsStatus.icon!, size: fontSize + 1, color: tsStatus.textColor),
            SizedBox(width: fontSize * 0.3),
          ],
          Text(
            tsStatus.label(status),
            style: TextStyle(
              color: tsStatus.textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
