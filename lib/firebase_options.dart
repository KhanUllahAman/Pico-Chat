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
    apiKey: 'AIzaSyCzFXqn6Du1zeGqa2ugAA3qnCOlKfOPRX8',
    appId: '1:420713586773:android:92c304edc6b7ddd89774dc',
    messagingSenderId: '420713586773',
    projectId: 'pico-chat-f59cb',
    storageBucket: 'pico-chat-f59cb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgFzJy0gQM9Yc06BTnTfnEANaJtG6r6AE',
    appId: '1:420713586773:ios:dc41cce0e76e2e569774dc',
    messagingSenderId: '420713586773',
    projectId: 'pico-chat-f59cb',
    storageBucket: 'pico-chat-f59cb.appspot.com',
    androidClientId: '420713586773-mht4nt5n50n7duct20eepac7qj4lnhmu.apps.googleusercontent.com',
    iosClientId: '420713586773-9f2cur4sq8i9u0ka5re2ef1pehva30gp.apps.googleusercontent.com',
    iosBundleId: 'com.example.chattingapp',
  );
}
