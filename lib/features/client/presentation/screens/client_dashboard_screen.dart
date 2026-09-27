import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/widgets/app_scaffold.dart';

class ClientDashboardScreen extends ConsumerWidget {
  const ClientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    return AppScaffold(
      title: 'Client Dashboard',
      showBackToDashboard: false,
      extraActions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Sign Out',
          onPressed: () {
            ref.read(authControllerProvider.notifier).logout();
          },
        ),
      ],

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Welcome Header
            Card(
              elevation: 0,
              color: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            user?.name ?? 'Client User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?.email ?? '',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            // Submit Request Card
            _buildActionCard(
              context: context,
              title: 'Submit New Request',
              subtitle: 'Upload property deeds & submit verification request',
              icon: Icons.post_add,
              color: Colors.indigo,
              onTap: () => context.go('/client/submit'),
            ),

            const SizedBox(height: 14),

            // Track Request Card
            _buildActionCard(
              context: context,
              title: 'Track Request Status',
              subtitle: 'Check progression using your unique tracking code',
              icon: Icons.track_changes,
              color: Colors.teal,
              onTap: () => context.go('/client/track'),
            ),

            const SizedBox(height: 14),

            // Public Verification Card
            _buildActionCard(
              context: context,
              title: 'Public Title Search',
              subtitle: 'Search title authenticity by Title Number or QR Hash',
              icon: Icons.verified,
              color: Colors.purple,
              onTap: () => context.go('/verify'),
            ),

            const SizedBox(height: 14),

            // Certificate View Card
            _buildActionCard(
              context: context,
              title: 'View Land Certificate',
              subtitle: 'View your verified land title certificate & QR badge',
              icon: Icons.workspace_premium,
              color: Colors.amber.shade800,
              onTap: () => context.go('/client/certificate'),
            ),

            const SizedBox(height: 14),

            // Payment Card
            _buildActionCard(
              context: context,
              title: 'Pay Verification Fee',
              subtitle: 'Initiate Mobile Money payment (Orange / MTN)',
              icon: Icons.payment,
              color: Colors.green.shade700,
              onTap: () => context.go('/client/payment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
