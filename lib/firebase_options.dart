import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Pre-configured for project: my-to-do-planner-6b25f
/// Web App ID: 1:1074926288484:web:58d747aa2be80e71b6e971
class DefaultFirebaseOptions {
  /// Web API Key:
  /// Paste your API key from the Firebase Console Web App registration screen
  /// into the defaultValue below (starts with 'AIzaSy...'), or supply it at
  /// build time via `--dart-define=FIREBASE_WEB_API_KEY=your_key`.
  static const String _webApiKey = String.fromEnvironment(
    'FIREBASE_WEB_API_KEY',
    defaultValue: 'AIzaSy_YOUR_WEB_API_KEY_HERE',
  );

  /// Returns true if valid Firebase configuration credentials have been entered.
  static bool get isConfigured {
    if (kIsWeb) {
      return web.apiKey != 'AIzaSy_YOUR_WEB_API_KEY_HERE' &&
          web.apiKey != '[Use the API key from my Firebase registration screen]' &&
          !web.apiKey.startsWith('AIzaSy_YOUR') &&
          !web.apiKey.startsWith('[Use') &&
          web.apiKey.trim().isNotEmpty;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android.apiKey != 'AIzaSy_YOUR_ANDROID_API_KEY_HERE' &&
            android.apiKey.trim().isNotEmpty;
      default:
        return web.apiKey.isNotEmpty;
    }
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  // Web Firebase Configuration (Registered for my-to-do-planner-6b25f)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _webApiKey,
    appId: '1:1074926288484:web:58d747aa2be80e71b6e971',
    messagingSenderId: '1074926288484',
    projectId: 'my-to-do-planner-6b25f',
    authDomain: 'my-to-do-planner-6b25f.firebaseapp.com',
    storageBucket: 'my-to-do-planner-6b25f.firebasestorage.app',
  );

  // Android Firebase Configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSy_YOUR_ANDROID_API_KEY_HERE',
    appId: '1:1074926288484:android:placeholder',
    messagingSenderId: '1074926288484',
    projectId: 'my-to-do-planner-6b25f',
    storageBucket: 'my-to-do-planner-6b25f.firebasestorage.app',
  );

  // iOS Firebase Configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSy_YOUR_IOS_API_KEY_HERE',
    appId: '1:1074926288484:ios:placeholder',
    messagingSenderId: '1074926288484',
    projectId: 'my-to-do-planner-6b25f',
    storageBucket: 'my-to-do-planner-6b25f.firebasestorage.app',
    iosBundleId: 'com.interncircle.todoListApp',
  );
}
