import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/admin_controller.dart';

class BroadcastSmsScreen extends ConsumerStatefulWidget {
  const BroadcastSmsScreen({super.key});

  @override
  ConsumerState<BroadcastSmsScreen> createState() => _BroadcastSmsScreenState();
}

class _BroadcastSmsScreenState extends ConsumerState<BroadcastSmsScreen> {
  final _recipientsController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _recipientsController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onSendBroadcast() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter SMS message body.')),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      final raw = _recipientsController.text.trim();
      List<String> recipients = [];
      if (raw.isNotEmpty) {
        recipients = raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      }
      if (recipients.isEmpty) {
        recipients = ['+237699000000'];
      }

      await ref.read(adminRepositoryProvider).broadcastSms(
        phoneNumbers: recipients,
        message: message,
      );

      _messageController.clear();
      _recipientsController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Broadcast SMS message dispatched successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
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
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast SMS Notification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.deepPurple.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: const [
                    Icon(Icons.sms, color: Colors.deepPurple, size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Send immediate SMS alerts to registered clients regarding land title verification updates or platform announcements.',
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            CustomTextField(
              controller: _recipientsController,
              label: 'Recipients Filter / Phone Numbers',
              hint: 'e.g. ALL_USERS or 237690000000, 237670000000',
              prefixIcon: const Icon(Icons.people_outline),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'SMS Message Body',
                hintText: 'Enter broadcast text message (max 160 chars)...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Send Broadcast SMS',
              icon: Icons.send,
              isLoading: _isSending,
              onPressed: _onSendBroadcast,
            ),
          ],
        ),
      ),
    );
  }
}
