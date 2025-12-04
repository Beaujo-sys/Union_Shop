// Minimal manual options to unblock builds. Replace with your real values.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  // Use your Web config for currentPlatform (works for web; also fine for basic Android/iOS dev)
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
    apiKey: 'AIzaSyB-q__bHBTCnhLCfMLGgeZmLXWm_J--mkk',
    appId: '1:325714028498:web:a43c0fb9f3c5f8fb720a0b',
    messagingSenderId: '325714028498',
    projectId: 'my-shop-auth-union',
    authDomain: 'my-shop-auth-union.firebaseapp.com',
    // FirebaseOptions expects the appspot.com bucket name
    storageBucket: 'my-shop-auth-union.appspot.com',
  );
}