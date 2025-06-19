import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../common_widgets/async_value_widget.dart';
import '../../common_widgets/empty_placeholder.dart';
import '../../config/app_theme.dart';
import '../../utils/formatters.dart';
import 'follow_ups_controller.dart';

class FollowUpsScreen extends ConsumerWidget {
  const FollowUpsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followUpsAsync = ref.watch(followUpsControllerProvider);

    return Scaffold(
      body: AsyncValueWidget<List<FollowUp>>(
        value: followUpsAsync,
        data: (followUps) {
          if (followUps.isEmpty) {
            return const EmptyPlaceholder(
              icon: Icons.event_note,
              message: 'No follow-ups scheduled',
              subtitle: 'Stay on top of your leads by scheduling follow-ups',
            );
          }

          // Separate overdue, today, and upcoming follow-ups
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          
          final overdue = followUps.where((f) => 
            !f.isCompleted && f.dueDate.isBefore(today)
          ).toList();
          
          final todayFollowUps = followUps.where((f) => 
            !f.isCompleted && 
            f.dueDate.year == today.year &&
            f.dueDate.month == today.month &&
            f.dueDate.day == today.day
          ).toList();
          
          final upcoming = followUps.where((f) => 
            !f.isCompleted && f.dueDate.isAfter(today)
          ).toList();
          
          final completed = followUps.where((f) => f.isCompleted).toList();

          return RefreshIndicator(
            onRefresh: () => ref.read(followUpsControllerProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                // Overdue Section
                if (overdue.isNotEmpty) ...[
                  _buildSectionHeader('Overdue', overdue.length, Colors.red),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => FadeInUp(
                        delay: Duration(milliseconds: index * 100),
                        child: _FollowUpCard(
                          followUp: overdue[index],
                          isOverdue: true,
                          onComplete: (id) => ref.read(followUpsControllerProvider.notifier).completeFollowUp(id),
                          onDelete: (id) => ref.read(followUpsControllerProvider.notifier).deleteFollowUp(id),
                        ),
                      ),
                      childCount: overdue.length,
                    ),
                  ),
                ],

                // Today Section
                if (todayFollowUps.isNotEmpty) ...[
                  _buildSectionHeader('Today', todayFollowUps.length, AppTheme.secondaryColor),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => FadeInUp(
                        delay: Duration(milliseconds: (overdue.length + index) * 100),
                        child: _FollowUpCard(
                          followUp: todayFollowUps[index],
                          onComplete: (id) => ref.read(followUpsControllerProvider.notifier).completeFollowUp(id),
                          onDelete: (id) => ref.read(followUpsControllerProvider.notifier).deleteFollowUp(id),
                        ),
                      ),
                      childCount: todayFollowUps.length,
                    ),
                  ),
                ],

                // Upcoming Section
                if (upcoming.isNotEmpty) ...[
                  _buildSectionHeader('Upcoming', upcoming.length, AppTheme.accentColor),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => FadeInUp(
                        delay: Duration(milliseconds: (overdue.length + todayFollowUps.length + index) * 100),
                        child: _FollowUpCard(
                          followUp: upcoming[index],
                          onComplete: (id) => ref.read(followUpsControllerProvider.notifier).completeFollowUp(id),
                          onDelete: (id) => ref.read(followUpsControllerProvider.notifier).deleteFollowUp(id),
                        ),
                      ),
                      childCount: upcoming.length,
                    ),
                  ),
                ],

                // Completed Section
                if (completed.isNotEmpty) ...[
                  _buildSectionHeader('Completed', completed.length, Colors.green),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => FadeInUp(
                        delay: Duration(milliseconds: (overdue.length + todayFollowUps.length + upcoming.length + index) * 100),
                        child: _FollowUpCard(
                          followUp: completed[index],
                          isCompleted: true,
                          onDelete: (id) => ref.read(followUpsControllerProvider.notifier).deleteFollowUp(id),
                        ),
                      ),
                      childCount: completed.length,
                    ),
                  ),
                ],

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FadeInUp(
        delay: const Duration(milliseconds: 600),
        child: FloatingActionButton(
          onPressed: () => _showAddFollowUpDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFollowUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Follow-up'),
        content: const Text('Follow-up creation will be implemented in the next phase.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _FollowUpCard extends StatelessWidget {
  const _FollowUpCard({
    required this.followUp,
    this.isOverdue = false,
    this.isCompleted = false,
    this.onComplete,
    this.onDelete,
  });

  final FollowUp followUp;
  final bool isOverdue;
  final bool isCompleted;
  final Function(String id)? onComplete;
  final Function(String id)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: isOverdue ? 4 : 2,
        shadowColor: isOverdue ? Colors.red.withOpacity(0.2) : null,
        child: InkWell(
          onTap: () => _showFollowUpDetails(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority indicator
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            followUp.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Contact: ${followUp.contactName}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.subtleTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            followUp.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // Actions
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppTheme.subtleTextColor,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'complete':
                            onComplete?.call(followUp.id);
                            break;
                          case 'delete':
                            onDelete?.call(followUp.id);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (!isCompleted && onComplete != null)
                          const PopupMenuItem(
                            value: 'complete',
                            child: Row(
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Mark Complete'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: AppTheme.errorColor),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: AppTheme.errorColor),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Footer with date and priority
                Row(
                  children: [
                    Icon(
                      isOverdue ? Icons.warning : Icons.schedule,
                      size: 16,
                      color: isOverdue ? Colors.red : AppTheme.subtleTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOverdue 
                          ? 'Overdue by ${DateTime.now().difference(followUp.dueDate).inDays} days'
                          : Formatters.formatRelativeTime(followUp.dueDate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isOverdue ? Colors.red : AppTheme.subtleTextColor,
                        fontWeight: isOverdue ? FontWeight.w600 : null,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        followUp.priority.displayName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getPriorityColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor() {
    switch (followUp.priority) {
      case FollowUpPriority.low:
        return Colors.blue;
      case FollowUpPriority.medium:
        return Colors.orange;
      case FollowUpPriority.high:
        return Colors.red;
      case FollowUpPriority.urgent:
        return Colors.purple;
    }
  }

  void _showFollowUpDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(followUp.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact: ${followUp.contactName}'),
            const SizedBox(height: 8),
            Text('Due: ${Formatters.formatDateTime(followUp.dueDate)}'),
            const SizedBox(height: 8),
            Text('Priority: ${followUp.priority.displayName}'),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(followUp.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
