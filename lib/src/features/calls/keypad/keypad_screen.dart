import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';
import '../../../utils/formatters.dart';
import 'keypad_controller.dart';

class KeypadButton {
  final String digit;
  final String letters;
  
  const KeypadButton(this.digit, this.letters);
}

class KeypadScreen extends ConsumerWidget {
  const KeypadScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialedNumber = ref.watch(dialedNumberProvider);
    final keypadState = ref.watch(keypadControllerProvider);
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Listen for keypad controller state changes
    ref.listen<AsyncValue<void>>(keypadControllerProvider, (previous, state) {
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initiate call: ${state.error}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    });

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20.0, 
          20.0, 
          20.0, 
          keyboardHeight > 0 ? 20.0 : 20.0
        ),
        child: Column(
          children: [
            // Phone number display
            FadeInDown(
              child: _buildPhoneNumberDisplay(context, dialedNumber, ref),
            ),

            SizedBox(height: screenSize.height * 0.03),

            // Keypad - Non-scrollable, proportional
            Expanded(
              flex: 6,
              child: FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: _buildFixedKeypad(context, ref),
              ),
            ),

            SizedBox(height: screenSize.height * 0.02),

            // Call button
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: _buildCallButton(context, ref, dialedNumber, keypadState),
            ),

            SizedBox(height: screenSize.height * 0.01),
          ],
        ),
      ),
    );
  }
  Widget _buildPhoneNumberDisplay(BuildContext context, String dialedNumber, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter Phone Number',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.subtleTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(minHeight: 60),
            child: Center(
              child: SelectableText(
                dialedNumber.isEmpty 
                    ? '+1 (___) ___-____' 
                    : Formatters.formatPhoneNumber(dialedNumber),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: dialedNumber.isEmpty 
                      ? AppTheme.subtleTextColor.withOpacity(0.5)
                      : AppTheme.textColor,
                ),
              ),
            ),
          ),
          if (dialedNumber.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Clear all button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref.read(keypadControllerProvider.notifier).clearNumber();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.clear,
                      color: AppTheme.subtleTextColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Backspace button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref.read(keypadControllerProvider.notifier).removeLastDigit();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.backspace_outlined,
                      color: AppTheme.subtleTextColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFixedKeypad(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = (screenSize.width - 80) / 3 - 16; // Account for padding and spacing
    
    final keypadData = [
      [
        KeypadButton('1', ''),
        KeypadButton('2', 'ABC'),
        KeypadButton('3', 'DEF'),
      ],
      [
        KeypadButton('4', 'GHI'),
        KeypadButton('5', 'JKL'),
        KeypadButton('6', 'MNO'),
      ],
      [
        KeypadButton('7', 'PQRS'),
        KeypadButton('8', 'TUV'),
        KeypadButton('9', 'WXYZ'),
      ],
      [
        KeypadButton('*', ''),
        KeypadButton('0', '+'),
        KeypadButton('#', ''),
      ],
    ];

    return Column(
      children: keypadData.map((row) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: row.map((button) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildKeypadButton(button, ref, buttonSize),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeypadButton(KeypadButton button, WidgetRef ref, double size) {
    return Material(
      color: AppTheme.surfaceColor,
      borderRadius: BorderRadius.circular(size / 4),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.15),
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 4),
        onTap: () {
          HapticFeedback.lightImpact();
          ref.read(keypadControllerProvider.notifier).addDigit(button.digit);
        },
        child: Container(
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 4),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.1),
              width: 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.surfaceColor,
                AppTheme.backgroundColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                button.digit,
                style: TextStyle(
                  fontSize: size * 0.3,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textColor,
                ),
              ),
              if (button.letters.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  button.letters,
                  style: TextStyle(
                    fontSize: size * 0.12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.subtleTextColor,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCallButton(
    BuildContext context, 
    WidgetRef ref, 
    String dialedNumber, 
    AsyncValue<void> keypadState,
  ) {
    final isEnabled = dialedNumber.isNotEmpty && !keypadState.isLoading;
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = screenSize.width * 0.2;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Video call button (placeholder for future)
        Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(buttonSize / 2),
              onTap: isEnabled ? () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Video call feature coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } : null,
              child: Icon(
                Icons.videocam,
                size: buttonSize * 0.35,
                color: isEnabled 
                    ? AppTheme.primaryColor 
                    : AppTheme.subtleTextColor.withOpacity(0.5),
              ),
            ),
          ),
        ),
        
        // Voice call button
        Pulse(
          infinite: isEnabled,
          child: Container(
            width: buttonSize * 1.2,
            height: buttonSize * 1.2,
            decoration: BoxDecoration(
              gradient: isEnabled
                  ? LinearGradient(
                      colors: [
                        Colors.green.shade400,
                        Colors.green.shade600,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        AppTheme.subtleTextColor.withOpacity(0.3),
                        AppTheme.subtleTextColor.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              shape: BoxShape.circle,
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(buttonSize * 0.6),
                onTap: isEnabled
                    ? () async {
                        HapticFeedback.heavyImpact();
                        await ref.read(keypadControllerProvider.notifier).makeCall(dialedNumber);
                        // Clear the number after initiating call
                        ref.read(keypadControllerProvider.notifier).clearNumber();
                        
                        // Show success message
                        if (!keypadState.hasError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Calling ${Formatters.formatPhoneNumber(dialedNumber)}...'),
                              backgroundColor: Colors.green,
                              action: SnackBarAction(
                                label: 'Cancel',
                                textColor: Colors.white,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                child: Center(
                  child: keypadState.isLoading
                      ? SizedBox(
                          width: buttonSize * 0.3,
                          height: buttonSize * 0.3,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          Icons.call,
                          size: buttonSize * 0.4,
                          color: isEnabled ? Colors.white : AppTheme.subtleTextColor,
                        ),
                ),
              ),
            ),
          ),
        ),

        // Add contact button (placeholder for future)
        Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(buttonSize / 2),
              onTap: isEnabled ? () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Add ${Formatters.formatPhoneNumber(dialedNumber)} to contacts?'),
                    action: SnackBarAction(
                      label: 'Add',
                      onPressed: () {
                        // TODO: Navigate to add contact screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add contact feature coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } : null,
              child: Icon(
                Icons.person_add,
                size: buttonSize * 0.35,
                color: isEnabled 
                    ? AppTheme.primaryColor 
                    : AppTheme.subtleTextColor.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
