import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../controllers/client_controllers.dart';
import '../../data/models/client_request_model.dart';
import '../../../../core/widgets/app_scaffold.dart';

class ClientTrackScreen extends ConsumerStatefulWidget {
  final String? initialCode;

  const ClientTrackScreen({super.key, this.initialCode});

  @override
  ConsumerState<ClientTrackScreen> createState() => _ClientTrackScreenState();
}

class _ClientTrackScreenState extends ConsumerState<ClientTrackScreen> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.initialCode ?? '');
    if (widget.initialCode != null && widget.initialCode!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(clientTrackControllerProvider.notifier).trackRequest(widget.initialCode!);
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onTrack() {
    ref.read(clientTrackControllerProvider.notifier).trackRequest(_codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientTrackControllerProvider);

    return AppScaffold(
      title: 'Track Request',
      showBackToDashboard: true,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _codeController,
              label: 'Tracking Code',
              hint: 'e.g. TRK-2026-X9A2',
              prefixIcon: const Icon(Icons.qr_code),
            ),
            const SizedBox(height: 14),

            CustomButton(
              text: 'Track Status',
              onPressed: _onTrack,
              isLoading: state.isLoading,
              icon: Icons.track_changes,
            ),

            if (state.errorMessage != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            ],

            if (state.isLoading) ...[
              const SizedBox(height: 40),
              const LoadingIndicator(message: 'Fetching tracking status...'),
            ] else if (state.trackedRequest != null) ...[
              const SizedBox(height: 24),
              _buildProgressStepperCard(state.trackedRequest!),
              const SizedBox(height: 20),
              _buildDetailsCard(state.trackedRequest!, state.certificateUrl),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStepperCard(ClientRequestModel request) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final textSecondary = isDark ? const Color(0xFFE5E7EB) : Colors.black87;
    final steps = [
      {'title': 'Submitted', 'desc': 'Request received (Pending)', 'key': 'pending'},
      {'title': 'Processing', 'desc': 'OCR & Text Extraction', 'key': 'processing'},
      {'title': 'Extracted', 'desc': 'NER Analysis complete', 'key': 'extracted'},
      {'title': 'In Review', 'desc': 'Notary Exception Audit', 'key': 'in_review'},
      {'title': 'Verified', 'desc': 'Certificate Issued', 'key': 'verified'},
    ];

    final currentStep = request.currentStepIndex;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Verification Progression',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.status.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stepper timeline view
            Column(
              children: List.generate(steps.length, (index) {
                final isCompleted = index <= currentStep;
                final isCurrent = index == currentStep;
                final isLast = index == steps.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: isCompleted
                              ? (isCurrent ? AppColors.primary : Colors.green)
                              : (isDark ? AppColors.surfaceVariant : Colors.grey.shade300),
                          child: Icon(
                            isCompleted ? Icons.check : Icons.circle_outlined,
                            size: 16,
                            color: isCompleted ? Colors.white : (isDark ? Colors.white54 : Colors.black54),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 40,
                            color: index < currentStep
                                ? Colors.green
                                : (isDark ? AppColors.border : Colors.grey.shade300),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              steps[index]['title']!,
                              style: TextStyle(
                                fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                                color: isCompleted ? textColor : (isDark ? Colors.white54 : Colors.black54),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              steps[index]['desc']!,
                              style: TextStyle(fontSize: 12, color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(ClientRequestModel request, String? certificateUrl) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            if (request.titleNumber != null) _row('Title Number', request.titleNumber!),
            if (request.ownerName != null) _row('Owner Name', request.ownerName!),
            if (request.parcelReference != null) _row('Parcel Reference', request.parcelReference!),
            if (request.location != null) _row('Location', request.location!),
            _row('Tracking Code', request.trackingCode),
            if (request.createdAt != null)
              _row('Submitted Date', request.createdAt!.toLocal().toString().split('.')[0]),

            if (request.status == 'verified' || certificateUrl != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading Certificate from ${certificateUrl ?? "API"}...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Verified Certificate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isDark ? const Color(0xFFE5E7EB) : Colors.black87)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}
