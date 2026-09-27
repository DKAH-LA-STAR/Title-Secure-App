import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/app_scaffold.dart';

class CertificateScreen extends StatelessWidget {
  final String titleNumber;
  final String ownerName;
  final String parcelReference;
  final String validityStatus;
  final String? qrHash;

  const CertificateScreen({
    super.key,
    this.titleNumber = 'TN-2026-89412',
    this.ownerName = 'Jean-Paul Mbida',
    this.parcelReference = 'PARCEL-YAO-901',
    this.validityStatus = 'VALID',
    this.qrHash = 'hash_a8f93c02d847',
  });

  @override
  Widget build(BuildContext context) {
    final qrData = qrHash ?? titleNumber;

    return AppScaffold(
      title: 'Certificate',
      showBackToDashboard: true,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  // Top Certificate Header Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.workspace_premium, color: Colors.white, size: 48),
                        SizedBox(height: 8),
                        Text(
                          'REPUBLIC OF CAMEROON',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'OFFICIAL LAND TITLE CERTIFICATE',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Status Chip
                        Chip(
                          avatar: const Icon(Icons.check_circle, color: Colors.white, size: 18),
                          label: Text(
                            validityStatus.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                        const SizedBox(height: 20),

                        _buildInfoRow('Title Number', titleNumber),
                        _buildInfoRow('Owner Name', ownerName),
                        _buildInfoRow('Parcel Reference', parcelReference),
                        _buildInfoRow('Issue Date', '04 Sept 2026'),

                        const Divider(height: 32),

                        // QR Code Display
                        QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 160.0,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scan to verify authenticity',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Download / Share Certificate',
              icon: Icons.share,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Certificate document export initiated.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
