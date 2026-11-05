import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Generated template for cross-platform Firebase integration.
/// Replace placeholder values with your Firebase Project Configuration from:
/// https://console.firebase.google.com/
class DefaultFirebaseOptions {
  /// Returns true if valid Firebase configuration credentials have been entered.
  static bool get isConfigured {
    if (kIsWeb) {
      return web.apiKey != 'AIzaSy_YOUR_WEB_API_KEY_HERE' &&
          web.apiKey.isNotEmpty;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android.apiKey != 'AIzaSy_YOUR_ANDROID_API_KEY_HERE' &&
            android.apiKey.isNotEmpty;
      default:
        return web.apiKey != 'AIzaSy_YOUR_WEB_API_KEY_HERE';
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

  // Web Firebase Configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSy_YOUR_WEB_API_KEY_HERE',
    appId: '1:1234567890:web:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'your-todo-planner-project',
    authDomain: 'your-todo-planner-project.firebaseapp.com',
    storageBucket: 'your-todo-planner-project.appspot.com',
  );

  // Android Firebase Configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSy_YOUR_ANDROID_API_KEY_HERE',
    appId: '1:1234567890:android:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'your-todo-planner-project',
    storageBucket: 'your-todo-planner-project.appspot.com',
  );

  // iOS Firebase Configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSy_YOUR_IOS_API_KEY_HERE',
    appId: '1:1234567890:ios:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'your-todo-planner-project',
    storageBucket: 'your-todo-planner-project.appspot.com',
    iosBundleId: 'com.interncircle.todoListApp',
  );
}
