import 'package:flutter/foundation.dart';

/// Debug configuration for reducing console spam in development
class DebugConfig {
  static const bool _kReduceAnimationLogs = true;
  static const bool _kReduceGoogleSignInLogs = true;
  
  /// Whether to reduce animation-related console output
  static bool get reduceAnimationLogs => _kReduceAnimationLogs && kDebugMode;
  
  /// Whether to reduce Google Sign-In related console output  
  static bool get reduceGoogleSignInLogs => _kReduceGoogleSignInLogs && kDebugMode;
  
  /// Log only important messages during development
  static void debugLog(String message, {bool important = false}) {
    if (kDebugMode && (important || !_shouldFilterMessage(message))) {
      print('[LeadBreak] $message');
    }
  }
  
  static bool _shouldFilterMessage(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('animate') ||
           lowerMessage.contains('google') ||
           lowerMessage.contains('gsi') ||
           lowerMessage.contains('oauth');
  }
}
