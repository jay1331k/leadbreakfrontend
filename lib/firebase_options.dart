// File generated for LeadBreak Firebase project
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
  // 🌐 WEB CONFIGURATION  
  // Updated with values from Firebase Console for leadbreak-ed330 project
  static const FirebaseOptions web = FirebaseOptions(
  apiKey: "AIzaSyChEdlBKrEEGwCcgCcW4S51MAngOeE9M7g",
  authDomain: "leadbreak-ed330.firebaseapp.com",
  projectId: "leadbreak-ed330",
  storageBucket: "leadbreak-ed330.firebasestorage.app",
  messagingSenderId: "352694946304",
  appId: "1:352694946304:web:8ea266f8751d74eb59a6e5",
  measurementId: "G-938QY2DJDS"
  );
  // ✅ ANDROID CONFIGURATION - Values from your google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDE_viodkyW0s-Bhdi4BVjCzd95ba3SS3k',     // ✅ From new google-services.json
    appId: '1:352694946304:android:c046900954d0eaaa59a6e5', // ✅ From new google-services.json
    messagingSenderId: '352694946304',                      // ✅ From new google-services.json  
    projectId: 'leadbreak-ed330',                           // ✅ From new google-services.json
    storageBucket: 'leadbreak-ed330.firebasestorage.app',   // ✅ From new google-services.json
  );
  // 🍎 iOS CONFIGURATION (for future use)
  // TODO: Add iOS app in Firebase Console when needed
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: 'REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: '352694946304',
    projectId: 'leadbreak-ed330',
    storageBucket: 'leadbreak-ed330.firebasestorage.app',
    iosBundleId: 'com.example.leadbreakfrontend',
  );
  // 🖥️ macOS CONFIGURATION (for future use)
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_WITH_MACOS_API_KEY',
    appId: 'REPLACE_WITH_MACOS_APP_ID',
    messagingSenderId: '352694946304',
    projectId: 'leadbreak-ed330',
    storageBucket: 'leadbreak-ed330.firebasestorage.app',
    iosBundleId: 'com.example.leadbreakfrontend',
  );
  // 🪟 WINDOWS CONFIGURATION 
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyChEdlBKrEEGwCcgCcW4S51MAngOeE9M7g",
    authDomain: "leadbreak-ed330.firebaseapp.com",
    projectId: "leadbreak-ed330",
    storageBucket: "leadbreak-ed330.firebasestorage.app",
    messagingSenderId: "352694946304",
    appId: "1:352694946304:web:8ea266f8751d74eb59a6e5",
    measurementId: "G-938QY2DJDS"
  );
}