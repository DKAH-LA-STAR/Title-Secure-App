import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/land_title_model.dart';
import '../../../../core/theme/widgets/theme_mode_switch.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shield_verified_badge.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/ts_button.dart';
import '../../../../core/widgets/ts_card.dart';
import '../../../../core/widgets/ts_text_field.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/public_controller.dart';

class PublicVerificationScreen extends ConsumerStatefulWidget {
  const PublicVerificationScreen({super.key});

  @override
  ConsumerState<PublicVerificationScreen> createState() =>
      _PublicVerificationScreenState();
}

class _PublicVerificationScreenState
    extends ConsumerState<PublicVerificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleNumberController = TextEditingController();
  MobileScannerController? _scannerController;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleNumberController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  void _toggleScanner() {
    if (_isScanning) {
      _scannerController?.dispose();
      _scannerController = null;
    } else {
      _scannerController = MobileScannerController();
    }
    setState(() => _isScanning = !_isScanning);
  }

  void _onQrDetected(BarcodeCapture capture) {
    final qrValue = capture.barcodes.first.rawValue;
    if (qrValue == null) return;
    _toggleScanner();
    ref
        .read(publicVerificationControllerProvider.notifier)
        .verifyByQrHash(qrValue);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(publicVerificationControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider);
    final role = authState.user?.role;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.backgroundLight,
      body: SafeArea(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (role != null && role.isNotEmpty) {
                          context.go(AppScaffold.dashboardRouteForRole(role));
                        } else if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.welcome);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surface : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? AppColors.border : AppColors.borderLight,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verify Land Title',
                            style: TextStyle(
                              color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Free public verification',
                            style: TextStyle(
                              color: isDark ? AppColors.textMuted : AppColors.textMutedLight,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ThemeToggleButton(),
                    const SizedBox(width: 4),
                    if (role == null || role.isEmpty)
                      TextButton(
                        onPressed: () => context.push('/login'),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.dashboard_rounded, color: AppColors.primary),
                        tooltip: 'Go to Dashboard',
                        onPressed: () => context.go(AppScaffold.dashboardRouteForRole(role)),
                      ),
                  ],
                ),
              ).animate().fade(duration: 400.ms),

              const SizedBox(height: 16),

              // ── Tab Bar ───────────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: AppColors.onPrimary,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.search_rounded, size: 18),
                      text: 'Title Number',
                    ),
                    Tab(
                      icon: Icon(Icons.qr_code_scanner_rounded, size: 18),
                      text: 'Scan QR',
                    ),
                  ],
                ),
              ).animate(delay: 100.ms).fade(),

              const SizedBox(height: 20),

              // ── Tab Views ─────────────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Manual search tab
                    _buildManualSearchTab(state),
                    // QR scan tab
                    _buildQrScanTab(state),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildManualSearchTab(VerificationState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TsCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter the land title number',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                TsTextField(
                  controller: _titleNumberController,
                  hintText: 'e.g. LT-CM-2024-001',
                  prefixIcon: const Icon(Icons.document_scanner_outlined),
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                ),
                const SizedBox(height: 14),
                TsButton(
                  text: 'Verify Now',
                  isLoading: state.isLoading,
                  onPressed: _search,
                  icon: Icons.verified_user_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildResult(state),
        ],
      ),
    );
  }

  Widget _buildQrScanTab(VerificationState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (_isScanning)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: _scannerController!,
                      onDetect: _onQrDetected,
                    ),
                    // Corner overlays
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _QrOverlayPainter(),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: TsButton(
                          text: 'Cancel',
                          variant: TsButtonVariant.danger,
                          width: 140,
                          onPressed: _toggleScanner,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                TsCard(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppColors.secondary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: AppColors.secondary,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Scan QR Code on Document',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Point your camera at the QR code\nprinted on the official land title document.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TsButton(
                        text: 'Open Camera',
                        variant: TsButtonVariant.secondary,
                        onPressed: _toggleScanner,
                        icon: Icons.camera_alt_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildResult(state),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildResult(VerificationState state) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.result != null) {
      return _TitleResultCard(title: state.result!);
    }

    if (state.isNotFound || state.errorMessage != null) {
      return TsCard(
        borderColor: AppColors.danger.withValues(alpha: 0.4),
        child: Column(
          children: [
            const Icon(Icons.cancel_rounded, color: AppColors.danger, size: 48),
            const SizedBox(height: 12),
            Text(
              state.isNotFound ? 'Title Not Found' : 'Verification Failed',
              style: const TextStyle(
                color: AppColors.danger,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 6),
              Text(
                state.errorMessage!,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            TsButton(
              text: 'Try Again',
              variant: TsButtonVariant.ghost,
              onPressed: () =>
                  ref.read(publicVerificationControllerProvider.notifier).reset(),
            ),
          ],
        ),
      ).animate().fade().scale();
    }

    return const SizedBox.shrink();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    final titleNum = _titleNumberController.text.trim();
    if (titleNum.isNotEmpty) {
      ref
          .read(publicVerificationControllerProvider.notifier)
          .verifyByTitleNumber(titleNum);
    }
  }
}

/// Displays the full title verification result.
class _TitleResultCard extends StatelessWidget {
  final LandTitleModel title;
  const _TitleResultCard({required this.title});

  @override
  Widget build(BuildContext context) {
    final isValid = title.validityStatus.toLowerCase() == 'valid';

    return TsCard(
      borderColor: (isValid ? AppColors.success : AppColors.danger)
          .withValues(alpha: 0.4),
      child: Column(
        children: [
          ShieldVerifiedBadge(
            animate: isValid,
            label: isValid ? 'Verified ✓' : 'Invalid',
          ),
          const SizedBox(height: 20),
          _InfoRow(label: 'Title Number', value: title.titleNumber),
          const Divider(color: AppColors.border, height: 20),
          _InfoRow(label: 'Owner', value: title.ownerName),
          if (title.parcelId != null) ...[
            const Divider(color: AppColors.border, height: 20),
            _InfoRow(label: 'Parcel ID', value: title.parcelId!),
          ],
          if (title.locationAddress != null) ...[
            const Divider(color: AppColors.border, height: 20),
            _InfoRow(label: 'Location', value: title.locationAddress!),
          ],
          const Divider(color: AppColors.border, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              StatusBadge(status: title.validityStatus),
            ],
          ),
        ],
      ),
    ).animate().fade().scale();
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

/// Custom QR viewfinder corners.
class _QrOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const margin = 60.0;
    const length = 30.0;
    final r = Rect.fromLTRB(margin, margin, size.width - margin,
        size.height - margin);

    // Corners
    for (final isTop in [true, false]) {
      for (final isLeft in [true, false]) {
        final x = isLeft ? r.left : r.right;
        final y = isTop ? r.top : r.bottom;
        final dx = isLeft ? length : -length;
        final dy = isTop ? length : -length;
        canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
        canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
