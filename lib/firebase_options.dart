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
    apiKey: 'AIzaSyDrutNGoPEZkKNNAhsv1yicZPtrA6V4Ig0',
    appId: '1:314276848048:web:4a9c31dcc3d5261d94b675',
    messagingSenderId: '314276848048',
    projectId: 'socialme-app',
    authDomain: 'socialme-app.firebaseapp.com',
    storageBucket: 'socialme-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-nTKBPaADdIJF8KNBwWvnO-OkRtLZ8fE',
    appId: '1:314276848048:android:c1ebbc3977fc7e6994b675',
    messagingSenderId: '314276848048',
    projectId: 'socialme-app',
    storageBucket: 'socialme-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdREGAMARfpoP1vCEHjVzVyLozDvJJfmY',
    appId: '1:314276848048:ios:d2d2dbd954e77d1594b675',
    messagingSenderId: '314276848048',
    projectId: 'socialme-app',
    storageBucket: 'socialme-app.appspot.com',
    iosBundleId: 'com.example.socializemeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAdREGAMARfpoP1vCEHjVzVyLozDvJJfmY',
    appId: '1:314276848048:ios:d2d2dbd954e77d1594b675',
    messagingSenderId: '314276848048',
    projectId: 'socialme-app',
    storageBucket: 'socialme-app.appspot.com',
    iosBundleId: 'com.example.socializemeApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDrutNGoPEZkKNNAhsv1yicZPtrA6V4Ig0',
    appId: '1:314276848048:web:31d5aaaf1261083e94b675',
    messagingSenderId: '314276848048',
    projectId: 'socialme-app',
    authDomain: 'socialme-app.firebaseapp.com',
    storageBucket: 'socialme-app.appspot.com',
  );
}
