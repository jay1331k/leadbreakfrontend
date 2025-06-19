import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock follow-up model for now
class FollowUp {
  final String id;
  final String contactId;
  final String contactName;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final FollowUpPriority priority;

  const FollowUp({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.priority = FollowUpPriority.medium,
  });

  FollowUp copyWith({
    String? id,
    String? contactId,
    String? contactName,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    FollowUpPriority? priority,
  }) {
    return FollowUp(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}

enum FollowUpPriority { low, medium, high, urgent }

extension FollowUpPriorityExtension on FollowUpPriority {
  String get displayName {
    switch (this) {
      case FollowUpPriority.low:
        return 'Low';
      case FollowUpPriority.medium:
        return 'Medium';
      case FollowUpPriority.high:
        return 'High';
      case FollowUpPriority.urgent:
        return 'Urgent';
    }
  }
}

final followUpsControllerProvider = AsyncNotifierProvider<FollowUpsController, List<FollowUp>>(() {
  return FollowUpsController();
});

class FollowUpsController extends AsyncNotifier<List<FollowUp>> {
  @override
  Future<List<FollowUp>> build() async {
    // Mock data for now
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      FollowUp(
        id: '1',
        contactId: 'contact1',
        contactName: 'John Doe',
        title: 'Follow up on product demo',
        description: 'Discuss pricing and implementation timeline',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: FollowUpPriority.high,
      ),
      FollowUp(
        id: '2',
        contactId: 'contact2',
        contactName: 'Jane Smith',
        title: 'Send proposal',
        description: 'Prepare and send detailed proposal for Q1 services',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        priority: FollowUpPriority.medium,
      ),
      FollowUp(
        id: '3',
        contactId: 'contact3',
        contactName: 'Mike Johnson',
        title: 'Check on decision',
        description: 'Follow up on their evaluation process',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        priority: FollowUpPriority.urgent,
      ),
    ];
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> completeFollowUp(String followUpId) async {
    final currentFollowUps = state.asData?.value ?? [];
    
    // Optimistically update
    final updatedFollowUps = currentFollowUps.map((followUp) {
      if (followUp.id == followUpId) {
        return followUp.copyWith(isCompleted: true);
      }
      return followUp;
    }).toList();
    
    state = AsyncValue.data(updatedFollowUps);
    
    // In a real app, you would call the API here
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> deleteFollowUp(String followUpId) async {
    final currentFollowUps = state.asData?.value ?? [];
    
    // Optimistically remove
    final updatedFollowUps = currentFollowUps
        .where((followUp) => followUp.id != followUpId)
        .toList();
    
    state = AsyncValue.data(updatedFollowUps);
    
    // In a real app, you would call the API here
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
