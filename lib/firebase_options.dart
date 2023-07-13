// File generated by FlutterFire CLI.
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNuVsJDukJOyIVUNWZfKVwrec3J40M-bY',
    appId: '1:202786949583:android:79d21ed26ce0aa4b5e2aba',
    messagingSenderId: '202786949583',
    projectId: 'circles-a21cb',
    storageBucket: 'circles-a21cb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDvp1l7RS9soSuo1rJmgJA-0ZSvSi-tbv4',
    appId: '1:202786949583:ios:77ce1c1efe9b21a95e2aba',
    messagingSenderId: '202786949583',
    projectId: 'circles-a21cb',
    storageBucket: 'circles-a21cb.appspot.com',
    androidClientId: '202786949583-rk82iok1vcgt5r20cd9so7n0a1hnqu01.apps.googleusercontent.com',
    iosClientId: '202786949583-ui2ogp1cr2rnep2b10p2nu08tpi548q6.apps.googleusercontent.com',
    iosBundleId: 'com.example.circlesapp',
  );
}
