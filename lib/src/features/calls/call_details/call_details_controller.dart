import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/crm_repository.dart';
import '../../../models/call_data.dart';

final callDetailsControllerProvider = AsyncNotifierProvider.family<CallDetailsController, CallData, String>(() {
  return CallDetailsController();
});

class CallDetailsController extends FamilyAsyncNotifier<CallData, String> {
  @override
  Future<CallData> build(String callSid) async {
    final crmRepository = ref.watch(crmRepositoryProvider);
    return await crmRepository.getCallById(callSid);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final crmRepository = ref.read(crmRepositoryProvider);
      return await crmRepository.getCallById(arg);
    });
  }

  Future<void> updateNotes(String notes) async {
    final currentCall = state.asData?.value;
    if (currentCall == null) return;

    // Optimistically update
    final updatedCall = currentCall.copyWith(notes: notes);
    state = AsyncValue.data(updatedCall);

    // In a real app, you would call the API here
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
