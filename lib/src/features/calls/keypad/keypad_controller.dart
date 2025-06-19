import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/crm_repository.dart';

final keypadControllerProvider = AsyncNotifierProvider<KeypadController, void>(() {
  return KeypadController();
});

final dialedNumberProvider = StateProvider<String>((ref) => '');

class KeypadController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial state needed
  }

  Future<void> makeCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
            final crmRepository = ref.read(crmRepositoryProvider);
      await crmRepository.initiateCall(phoneNumber);
      
      // Navigate to call in progress screen
      // Note: This would need to be handled differently in a real app
      // as we can't directly access context from a provider
      // For now, we'll just complete the async operation
    });
  }
  void addDigit(String digit) {
    final currentNumber = ref.read(dialedNumberProvider);
    // Limit to reasonable phone number length
    if (currentNumber.length < 15) {
      ref.read(dialedNumberProvider.notifier).state = currentNumber + digit;
    }
  }

  void removeLastDigit() {
    final currentNumber = ref.read(dialedNumberProvider);
    if (currentNumber.isNotEmpty) {
      ref.read(dialedNumberProvider.notifier).state = 
          currentNumber.substring(0, currentNumber.length - 1);
    }
  }

  void clearNumber() {
    ref.read(dialedNumberProvider.notifier).state = '';
  }

  void setNumber(String number) {
    ref.read(dialedNumberProvider.notifier).state = number;
  }
  String get currentNumber => ref.read(dialedNumberProvider);
}
