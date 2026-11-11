// File generated for Firebase project user-management-b6be0.
// Web configuration was supplied in chat; Android configuration was read
// from google-services.json. Do not edit values unless Firebase config changes.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for iOS. '
          'Run the FlutterFire CLI to add iOS configuration.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for macOS. '
          'Run the FlutterFire CLI to add macOS configuration.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for Windows. '
          'Run the FlutterFire CLI to add Windows configuration.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for Linux. '
          'Run the FlutterFire CLI to add Linux configuration.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDHKx6kGYwqtZlC3GhDt9SsXBl-XuxWwBg',
    appId: '1:937874085396:web:f174182820490f1f92f901',
    messagingSenderId: '937874085396',
    projectId: 'product-management-admin-5076a',
    authDomain: 'product-management-admin-5076a.firebaseapp.com',
    storageBucket: 'product-management-admin-5076a.firebasestorage.app',
    measurementId: 'G-8YLQHZ463X',
  );


  
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCy-XVBBt-aywm8dRFJCBZRnbvi88nTDco',
    appId: '1:937874085396:android:3f570bef1dc2e6f192f901',
    messagingSenderId: '937874085396',
    projectId: 'product-management-admin-5076a',
    storageBucket: 'product-management-admin-5076a.firebasestorage.app',
  );

}
