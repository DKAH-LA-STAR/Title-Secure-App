import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/notary_controller.dart';
import '../../data/models/notary_exception_model.dart';

class NotaryExceptionReviewScreen extends ConsumerWidget {
  const NotaryExceptionReviewScreen({super.key});

  void _showResolveDialog(BuildContext context, WidgetRef ref, NotaryExceptionModel item) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Resolve Exception #${item.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reason: ${item.exceptionReason}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Resolution Note / Audit Findings',
                border: OutlineInputBorder(),
                hintText: 'Enter notary verification summary...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final note = noteController.text.trim();
              if (note.isEmpty) return;
              Navigator.pop(context);
              ref.read(notaryControllerProvider.notifier).resolveException(item.id, note);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Resolve Exception'),
          ),
        ],
      ),
    );
  }

  void _showValidityDialog(BuildContext context, WidgetRef ref, NotaryExceptionModel item) {
    String selectedValidity = item.validityStatus;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Update Title Validity #${item.id}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildValidityOption(
                  title: 'Valid (Legal & Authentic)',
                  value: 'valid',
                  current: selectedValidity,
                  onSelect: (val) => setState(() => selectedValidity = val),
                ),
                _buildValidityOption(
                  title: 'Disputed (Ownership Conflict)',
                  value: 'disputed',
                  current: selectedValidity,
                  onSelect: (val) => setState(() => selectedValidity = val),
                ),
                _buildValidityOption(
                  title: 'Revoked (Cancelled Title)',
                  value: 'revoked',
                  current: selectedValidity,
                  onSelect: (val) => setState(() => selectedValidity = val),
                ),
                _buildValidityOption(
                  title: 'Under Investigation',
                  value: 'under_investigation',
                  current: selectedValidity,
                  onSelect: (val) => setState(() => selectedValidity = val),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(notaryControllerProvider.notifier).updateValidity(item.id, selectedValidity);
                },
                child: const Text('Save Status'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildValidityOption({
    required String title,
    required String value,
    required String current,
    required ValueChanged<String> onSelect,
  }) {
    final isSelected = value == current;
    return ListTile(
      title: Text(title),
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? AppColors.primary : Colors.grey,
      ),
      onTap: () => onSelect(value),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notaryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notary Exception Review'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(notaryControllerProvider.notifier).fetchExceptions(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notaryControllerProvider.notifier).fetchExceptions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                elevation: 0,
                color: Colors.amber.shade900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: const [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.gavel, color: Colors.white, size: 30),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notary Audit Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Review OCR/NER exception flags, resolve discrepancy claims, and certify title validity.',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (state.successMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(state.successMessage!, style: TextStyle(color: Colors.green.shade900)),
                ),
              ],

              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(state.errorMessage!, style: TextStyle(color: Colors.red.shade900)),
                ),
              ],

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Flagged Exception Queue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Text(
                      '${state.exceptions.length} Pending',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.orange.shade800,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              if (state.isLoading && state.exceptions.isEmpty)
                const LoadingIndicator(message: 'Loading notary exception items...')
              else if (state.exceptions.isEmpty)
                Card(
                  elevation: 0,
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Center(
                      child: Text(
                        'No flagged exceptions pending review.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.exceptions.length,
                  itemBuilder: (context, index) {
                    final item = state.exceptions[index];
                    final isBusy = state.actionId == item.id;
                    return _buildExceptionItemCard(context, ref, item, isBusy);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExceptionItemCard(
    BuildContext context,
    WidgetRef ref,
    NotaryExceptionModel item,
    bool isBusy,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exception #${item.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.status.toUpperCase(),
                    style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              'Reason: ${item.exceptionReason}',
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            if (item.titleNumber != null) Text('Title Number: ${item.titleNumber}'),
            if (item.ownerName != null) Text('Owner Name: ${item.ownerName}'),
            if (item.parcelReference != null) Text('Parcel Ref: ${item.parcelReference}'),
            Text('Current Validity: ${item.validityStatus.toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.w600)),

            if (item.rawOcrText != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'OCR Text Snippet:\n${item.rawOcrText!}',
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isBusy ? null : () => _showValidityDialog(context, ref, item),
                    icon: const Icon(Icons.edit_note, size: 18),
                    label: const Text('Update Validity'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isBusy ? null : () => _showResolveDialog(context, ref, item),
                    icon: isBusy
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(isBusy ? 'Saving...' : 'Resolve Exception'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
