import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../common_widgets/async_value_widget.dart';
import '../../../config/app_theme.dart';
import '../../../models/call_data.dart';
import '../../../utils/formatters.dart';
import 'call_details_controller.dart';

class CallDetailsScreen extends ConsumerStatefulWidget {
  const CallDetailsScreen({
    super.key,
    required this.callSid,
  });

  final String callSid;

  @override
  ConsumerState<CallDetailsScreen> createState() => _CallDetailsScreenState();
}

class _CallDetailsScreenState extends ConsumerState<CallDetailsScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final callDetailsAsync = ref.watch(callDetailsControllerProvider(widget.callSid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(callDetailsControllerProvider(widget.callSid).notifier).refresh();
            },
          ),
        ],
      ),
      body: AsyncValueWidget<CallData>(
        value: callDetailsAsync,
        data: (callData) {
          _notesController.text = callData.notes ?? '';
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                FadeInDown(
                  child: _buildHeaderCard(context, callData),
                ),
                
                const SizedBox(height: 20),
                
                // Audio Player (if recording exists)
                if (callData.recordingUrl != null) ...[
                  FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    child: _buildAudioPlayerCard(context, callData),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Transcript
                if (callData.transcript != null) ...[
                  FadeInRight(
                    delay: const Duration(milliseconds: 300),
                    child: _buildTranscriptCard(context, callData),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Key Insights
                if (callData.entities.isNotEmpty) ...[
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: _buildInsightsCard(context, callData),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Notes
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: _buildNotesCard(context, callData),
                ),
                
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, CallData callData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(callData.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    callData.contactName ?? 'Unknown Contact',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(callData.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    callData.status.displayName,
                    style: TextStyle(
                      color: _getStatusColor(callData.status),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Phone Number
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: AppTheme.subtleTextColor),
                const SizedBox(width: 8),
                Text(
                  Formatters.formatPhoneNumber(callData.phoneNumber),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Call Time
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: AppTheme.subtleTextColor),
                const SizedBox(width: 8),
                Text(
                  Formatters.formatDateTime(callData.startTime),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.subtleTextColor,
                  ),
                ),
              ],
            ),
            
            if (callData.duration != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer, size: 18, color: AppTheme.subtleTextColor),
                  const SizedBox(width: 8),
                  Text(
                    'Duration: ${Formatters.formatDurationWords(callData.duration!)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.subtleTextColor,
                    ),
                  ),
                ],
              ),
            ],
            
            if (callData.cost != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 18, color: AppTheme.subtleTextColor),
                  const SizedBox(width: 8),
                  Text(
                    'Cost: ${Formatters.formatCurrency(callData.cost!)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.subtleTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerCard(BuildContext context, CallData callData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.audiotrack, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Call Recording',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Call Recording',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to play recording',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.subtleTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.download,
                    color: AppTheme.subtleTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscriptCard(BuildContext context, CallData callData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Call Transcript',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                callData.transcript!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsCard(BuildContext context, CallData callData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: AppTheme.accentColor),
                const SizedBox(width: 8),
                Text(
                  'Key Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: callData.entities.map((entity) {
                return Chip(
                  avatar: Icon(
                    _getEntityIcon(entity.type),
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                  label: Text(
                    '${entity.type}: ${entity.value}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, CallData callData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.note, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Notes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Add your notes about this call...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Auto-save notes with debouncing in real implementation
              },
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(callDetailsControllerProvider(widget.callSid).notifier)
                      .updateNotes(_notesController.text);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notes saved'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Save Notes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(CallStatus status) {
    switch (status) {
      case CallStatus.completed:
        return Colors.green;
      case CallStatus.inProgress:
        return Colors.blue;
      case CallStatus.failed:
      case CallStatus.noAnswer:
        return Colors.red;
      case CallStatus.busy:
        return Colors.orange;
      default:
        return AppTheme.subtleTextColor;
    }
  }

  IconData _getEntityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'budget':
      case 'price':
      case 'cost':
        return Icons.attach_money;
      case 'location':
      case 'address':
        return Icons.location_on;
      case 'company':
      case 'organization':
        return Icons.business;
      case 'person':
      case 'name':
        return Icons.person;
      case 'date':
      case 'time':
        return Icons.schedule;
      case 'product':
        return Icons.inventory;
      default:
        return Icons.label;
    }
  }
}
