import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/client_controllers.dart';
import '../../../../core/widgets/app_scaffold.dart';

class ClientSubmitScreen extends ConsumerStatefulWidget {
  const ClientSubmitScreen({super.key});

  @override
  ConsumerState<ClientSubmitScreen> createState() => _ClientSubmitScreenState();
}

class _ClientSubmitScreenState extends ConsumerState<ClientSubmitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _parcelRefController = TextEditingController();
  final _locationController = TextEditingController();

  PlatformFile? _selectedFile;

  @override
  void dispose() {
    _titleNumberController.dispose();
    _ownerNameController.dispose();
    _parcelRefController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(clientSubmitControllerProvider.notifier);
    final req = await controller.submitRequest(
      titleNumber: _titleNumberController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      parcelReference: _parcelRefController.text.trim(),
      location: _locationController.text.trim(),
      filePath: _selectedFile?.path,
    );

    if (req != null && mounted) {
      _showSuccessDialog(req.trackingCode);
    }
  }

  void _showSuccessDialog(String trackingCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Request Submitted'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your title verification request has been successfully created. Keep your tracking code safe:',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SelectableText(
                      trackingCode,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: AppColors.primary),
                    tooltip: 'Copy Tracking Code',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: trackingCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tracking code copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(clientSubmitControllerProvider.notifier).reset();
              context.go('/client/track?code=$trackingCode');
            },
            child: const Text('Track Request'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _titleNumberController.clear();
              _ownerNameController.clear();
              _parcelRefController.clear();
              _locationController.clear();
              setState(() {
                _selectedFile = null;
              });
              ref.read(clientSubmitControllerProvider.notifier).reset();
              context.go('/client/dashboard');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientSubmitControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? const Color(0xFFE5E7EB) : Colors.black87;

    return AppScaffold(
      title: 'Submit Request',
      showBackToDashboard: true,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: AppColors.primary.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.upload_file, color: AppColors.primary, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Upload land title deed or certificate scan (.pdf, .jpg, .png) for automated verification.',
                          style: TextStyle(fontSize: 13, color: textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                controller: _titleNumberController,
                label: 'Land Title Number *',
                hint: 'e.g. TN-987654',
                prefixIcon: const Icon(Icons.badge_outlined),
                validator: (v) => v == null || v.trim().isEmpty ? 'Title Number is required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _ownerNameController,
                label: 'Owner Full Name *',
                hint: 'e.g. Jean Dupont',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (v) => v == null || v.trim().isEmpty ? 'Owner Name is required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _parcelRefController,
                label: 'Parcel Reference *',
                hint: 'e.g. CAD-SECTION-B-104',
                prefixIcon: const Icon(Icons.map_outlined),
                validator: (v) => v == null || v.trim().isEmpty ? 'Parcel Reference is required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _locationController,
                label: 'Location / Region',
                hint: 'e.g. Yaoundé, Zone Sub-district 4',
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
              const SizedBox(height: 20),

              // File Picker Widget
              InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedFile != null
                          ? AppColors.primary
                          : (isDark ? AppColors.border : Colors.grey.shade400),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: _selectedFile != null
                        ? AppColors.primary.withValues(alpha: 0.05)
                        : (isDark ? AppColors.surfaceVariant : Colors.grey.shade50),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _selectedFile != null ? Icons.insert_drive_file : Icons.cloud_upload_outlined,
                        size: 36,
                        color: _selectedFile != null ? AppColors.primary : (isDark ? Colors.white54 : Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedFile != null
                            ? 'Attached: ${_selectedFile!.name}'
                            : 'Select PDF deed or image scan (.pdf, .jpg, .png)',
                        style: TextStyle(
                          fontWeight: _selectedFile != null ? FontWeight.bold : FontWeight.normal,
                          color: _selectedFile != null ? AppColors.primary : textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_selectedFile != null)
                        Text(
                          '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                    ],
                  ),
                ),
              ),

              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              ],

              const SizedBox(height: 24),

              CustomButton(
                text: 'Submit Verification Request',
                onPressed: _submitForm,
                isLoading: state.isLoading,
                icon: Icons.send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
