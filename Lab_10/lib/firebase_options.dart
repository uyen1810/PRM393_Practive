import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Cấu hình mặc định cho Firebase dựa trên `google-services.json`
/// Hỗ trợ cả Android, Web (Chrome, Edge) và Windows Desktop
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return web;
    }
  }

  static const String webClientId =
      '1005237689457-ogj0ckmagemg3fc1vd7da8io66rrv45n.apps.googleusercontent.com';

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyASkizTFQZUZJB_MmZs8zOhxWBp1B3xnIM',
    appId: '1:1005237689457:web:368ea0f45a8669881b4fd0',
    messagingSenderId: '1005237689457',
    projectId: 'lab10-flutter-9294f',
    authDomain: 'lab10-flutter-9294f.firebaseapp.com',
    storageBucket: 'lab10-flutter-9294f.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASkizTFQZUZJB_MmZs8zOhxWBp1B3xnIM',
    appId: '1:1005237689457:android:368ea0f45a8669881b4fd0',
    messagingSenderId: '1005237689457',
    projectId: 'lab10-flutter-9294f',
    storageBucket: 'lab10-flutter-9294f.firebasestorage.app',
  );
}
