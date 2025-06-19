import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../common_widgets/async_value_widget.dart';
import '../../../config/app_theme.dart';
import '../../../models/contact.dart';
import '../../../models/call_data.dart';
import '../../../utils/formatters.dart';
import '../../../data/crm_repository.dart';
import 'widgets/call_history_card.dart';

final contactDetailsProvider = FutureProvider.family<Contact, String>((ref, contactId) async {
  final crmRepository = ref.watch(crmRepositoryProvider);
  return await crmRepository.getContactById(contactId);
});

final contactCallHistoryProvider = FutureProvider.family<List<CallData>, String>((ref, contactId) async {
  final crmRepository = ref.watch(crmRepositoryProvider);
  return await crmRepository.getCallsForContact(contactId);
});

class ContactDetailsScreen extends ConsumerWidget {
  const ContactDetailsScreen({
    super.key,
    required this.contactId,
  });

  final String contactId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactAsync = ref.watch(contactDetailsProvider(contactId));
    final callHistoryAsync = ref.watch(contactCallHistoryProvider(contactId));

    return Scaffold(
      body: AsyncValueWidget<Contact>(
        value: contactAsync,
        data: (contact) => CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: FadeInDown(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  child: Text(
                                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contact.name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (contact.company != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          contact.company!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white.withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditContactDialog(context, contact);
                        break;
                      case 'delete':
                        _showDeleteContactDialog(context, ref, contact);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit Contact'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppTheme.errorColor),
                          SizedBox(width: 8),
                          Text(
                            'Delete Contact',
                            style: TextStyle(color: AppTheme.errorColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Contact Info
            SliverToBoxAdapter(
              child: FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: _buildContactInfoSection(context, contact),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: _buildQuickActionsSection(context, contact),
              ),
            ),

            // Call History
            SliverToBoxAdapter(
              child: FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Call History',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Call History List
            AsyncValueWidget<List<CallData>>(
              value: callHistoryAsync,
              data: (callHistory) {
                if (callHistory.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.phone_disabled,
                            size: 64,
                            color: AppTheme.subtleTextColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No call history',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.subtleTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start calling this contact to see history here',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.subtleTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final call = callHistory[index];
                      return FadeInUp(
                        delay: Duration(milliseconds: 500 + (index * 100)),
                        child: CallHistoryCard(
                          callData: call,
                          onTap: () {
                            // Navigate to call details
                          },
                        ),
                      );
                    },
                    childCount: callHistory.length,
                  ),
                );
              },
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      floatingActionButton: FadeInUp(
        delay: const Duration(milliseconds: 800),
        child: FloatingActionButton(
          onPressed: () => _makeCall(context, ref, contactId),
          child: const Icon(Icons.call),
        ),
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context, Contact contact) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Phone Number
            _buildInfoRow(
              context,
              Icons.phone,
              'Phone',
              Formatters.formatPhoneNumber(contact.phoneNumber),
            ),
            
            if (contact.email != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                Icons.email,
                'Email',
                contact.email!,
              ),
            ],
            
            if (contact.title != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                Icons.work,
                'Title',
                contact.title!,
              ),
            ],
            
            if (contact.notes != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                Icons.note,
                'Notes',
                contact.notes!,
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Tags
            if (contact.tags.isNotEmpty) ...[
              Text(
                'Tags',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: contact.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    labelStyle: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.subtleTextColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.subtleTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, Contact contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: InkWell(
                onTap: () => _makeCall(context, null, contactId),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Call',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              child: InkWell(
                onTap: () => _sendMessage(context, contact),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.message,
                          color: AppTheme.secondaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Message',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              child: InkWell(
                onTap: () => _scheduleFollowUp(context, contact),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.schedule,
                          color: AppTheme.accentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Follow-up',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _makeCall(BuildContext context, WidgetRef? ref, String contactId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Initiating call...')),
    );
  }

  void _sendMessage(BuildContext context, Contact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening messages for ${contact.name}')),
    );
  }

  void _scheduleFollowUp(BuildContext context, Contact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scheduling follow-up for ${contact.name}')),
    );
  }

  void _showEditContactDialog(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Contact'),
        content: const Text('Contact editing will be implemented in the next phase.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteContactDialog(BuildContext context, WidgetRef ref, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to contacts list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${contact.name} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
