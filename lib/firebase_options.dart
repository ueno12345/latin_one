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
    apiKey: 'AIzaSyCa6m0bx5nBMslDpl13Jwz3G7VfzkTGMD8',
    appId: '1:424439546938:web:8994afb818e1cd42962103',
    messagingSenderId: '424439546938',
    projectId: 'latinone-1',
    authDomain: 'latinone-1.firebaseapp.com',
    storageBucket: 'latinone-1.appspot.com',
    measurementId: 'G-6T2X6XR3XV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDx5C25fJNiwP-VdGsWDcqOmdZBBeFH2L8',
    appId: '1:424439546938:android:71e2cabf8befe7d9962103',
    messagingSenderId: '424439546938',
    projectId: 'latinone-1',
    storageBucket: 'latinone-1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuqGZKuS7wfL1Rn6nx5QV9MNIl8TsuBaQ',
    appId: '1:424439546938:ios:74fa0a87d87347cc962103',
    messagingSenderId: '424439546938',
    projectId: 'latinone-1',
    storageBucket: 'latinone-1.appspot.com',
    iosBundleId: 'com.example.latinOne',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAuqGZKuS7wfL1Rn6nx5QV9MNIl8TsuBaQ',
    appId: '1:424439546938:ios:74fa0a87d87347cc962103',
    messagingSenderId: '424439546938',
    projectId: 'latinone-1',
    storageBucket: 'latinone-1.appspot.com',
    iosBundleId: 'com.example.latinOne',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCa6m0bx5nBMslDpl13Jwz3G7VfzkTGMD8',
    appId: '1:424439546938:web:3ef6fad56db43f0a962103',
    messagingSenderId: '424439546938',
    projectId: 'latinone-1',
    authDomain: 'latinone-1.firebaseapp.com',
    storageBucket: 'latinone-1.appspot.com',
    measurementId: 'G-NLH3CJ2BQQ',
  );

}