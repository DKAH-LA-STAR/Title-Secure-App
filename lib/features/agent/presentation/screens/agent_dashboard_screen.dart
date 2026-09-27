import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/agent_controller.dart';
import '../../data/models/extraction_model.dart';
import '../../../../core/widgets/app_scaffold.dart';

class AgentDashboardScreen extends ConsumerStatefulWidget {
  const AgentDashboardScreen({super.key});

  @override
  ConsumerState<AgentDashboardScreen> createState() => _AgentDashboardScreenState();
}

class _AgentDashboardScreenState extends ConsumerState<AgentDashboardScreen> {
  final _titleController = TextEditingController();
  PlatformFile? _selectedFile;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );
    if (res != null && res.files.isNotEmpty) {
      setState(() {
        _selectedFile = res.files.first;
      });
    }
  }

  void _uploadDocument() {
    if (_selectedFile == null || _selectedFile!.path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file to upload')),
      );
      return;
    }

    ref.read(agentControllerProvider.notifier).uploadDocument(
          _selectedFile!.path!,
          titleNumber: _titleController.text.trim(),
        );

    _titleController.clear();
    setState(() {
      _selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(agentControllerProvider);

    return AppScaffold(
      title: 'Agent Dashboard',
      showBackToDashboard: false,
      extraActions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Refresh',
          onPressed: () => ref.read(agentControllerProvider.notifier).fetchExtractions(),
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          tooltip: 'Sign Out',
          onPressed: () => ref.read(authControllerProvider.notifier).logout(),
        ),
      ],

      body: RefreshIndicator(
        onRefresh: () => ref.read(agentControllerProvider.notifier).fetchExtractions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header card
              Card(
                elevation: 0,
                color: Colors.blue.shade900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.document_scanner, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'OCR & Extraction Management',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Upload land deeds for text extraction and automated OCR processing.',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Upload Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload New Document for OCR',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title Number (Optional)',
                          hintText: 'e.g. TN-88231',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),

                      OutlinedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.attach_file),
                        label: Text(_selectedFile != null
                            ? _selectedFile!.name
                            : 'Choose Document (.pdf, .jpg, .png)'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomButton(
                        text: 'Upload & Queue Extraction',
                        onPressed: _uploadDocument,
                        isLoading: state.isLoading,
                        icon: Icons.cloud_upload,
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
                  child: Text(
                    state.successMessage!,
                    style: TextStyle(color: Colors.green.shade900),
                  ),
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
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Extraction Queue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${state.extractions.length} items',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (state.isLoading && state.extractions.isEmpty)
                const LoadingIndicator(message: 'Loading extraction queue...')
              else if (state.extractions.isEmpty)
                Card(
                  elevation: 0,
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Center(
                      child: Text(
                        'No extractions found. Upload a document above.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.extractions.length,
                  itemBuilder: (context, index) {
                    final item = state.extractions[index];
                    return _buildExtractionCard(item, state.processingOcrId == item.id);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExtractionCard(ExtractionModel item, bool isProcessing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Extraction #${item.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Chip(
                  label: Text(
                    item.status.toUpperCase(),
                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: item.hasException
                      ? Colors.orange.shade800
                      : (item.status == 'completed' ? Colors.green : Colors.blue),
                ),
              ],
            ),
            if (item.titleNumber != null) Text('Title Number: ${item.titleNumber}'),
            if (item.ownerName != null) Text('Owner Name: ${item.ownerName}'),
            if (item.hasException)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  'Exception: ${item.exceptionReason ?? "Flagged for Notary review"}',
                  style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            if (item.rawText != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.rawText!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
              ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: isProcessing
                      ? null
                      : () => ref.read(agentControllerProvider.notifier).processOcr(item.id),
                  icon: isProcessing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow, size: 16),
                  label: Text(isProcessing ? 'Processing...' : 'Run OCR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
