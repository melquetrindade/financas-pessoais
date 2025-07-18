// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB2M2L7M_vKh75YJswEdhbAFzL9drkDHEA',
    appId: '1:272756769676:web:67e4ca45edada9212a0ca9',
    messagingSenderId: '272756769676',
    projectId: 'walletfy-122db',
    authDomain: 'walletfy-122db.firebaseapp.com',
    storageBucket: 'walletfy-122db.firebasestorage.app',
    measurementId: 'G-ZHLYXXGV98',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNc65s5QAfoGofGel0o5aSNTqRTfv7DwY',
    appId: '1:272756769676:android:f206b6ab5337c1b72a0ca9',
    messagingSenderId: '272756769676',
    projectId: 'walletfy-122db',
    storageBucket: 'walletfy-122db.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOnpxLCsUHdKa3lwy8LAHRClYjhZltMZ8',
    appId: '1:272756769676:ios:c84362aa132f5aa22a0ca9',
    messagingSenderId: '272756769676',
    projectId: 'walletfy-122db',
    storageBucket: 'walletfy-122db.firebasestorage.app',
    iosBundleId: 'com.example.financasPessoais',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCOnpxLCsUHdKa3lwy8LAHRClYjhZltMZ8',
    appId: '1:272756769676:ios:c84362aa132f5aa22a0ca9',
    messagingSenderId: '272756769676',
    projectId: 'walletfy-122db',
    storageBucket: 'walletfy-122db.firebasestorage.app',
    iosBundleId: 'com.example.financasPessoais',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB2M2L7M_vKh75YJswEdhbAFzL9drkDHEA',
    appId: '1:272756769676:web:28809f2bf42fa6cc2a0ca9',
    messagingSenderId: '272756769676',
    projectId: 'walletfy-122db',
    authDomain: 'walletfy-122db.firebaseapp.com',
    storageBucket: 'walletfy-122db.firebasestorage.app',
    measurementId: 'G-TDE3B8HMWV',
  );
}
