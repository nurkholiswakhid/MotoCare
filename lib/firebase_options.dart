import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return webOptions;
  }

  static const FirebaseOptions webOptions = FirebaseOptions(
    apiKey: 'AIzaSyDwJVn7Hfh8PFTAphClbCJAtpS2TB0JiyA',
    appId: '1:516451377145:web:bbfadd75df17e3554da728',
    messagingSenderId: '516451377145',
    projectId: 'flutter-service-schedule',
    authDomain: 'flutter-service-schedule.firebaseapp.com',
    databaseURL: 'https://flutter-service-schedule.firebaseio.com',
    storageBucket: 'flutter-service-schedule.firebasestorage.app',
  );

  static const FirebaseOptions androidOptions = FirebaseOptions(
    apiKey: 'AIzaSyDwJVn7Hfh8PFTAphClbCJAtpS2TB0JiyA',
    appId: '1:516451377145:android:bbfadd75df17e3554da728',
    messagingSenderId: '516451377145',
    projectId: 'flutter-service-schedule',
    storageBucket: 'flutter-service-schedule.firebasestorage.app',
  );

  static const FirebaseOptions iosOptions = FirebaseOptions(
    apiKey: 'AIzaSyDwJVn7Hfh8PFTAphClbCJAtpS2TB0JiyA',
    appId: '1:516451377145:ios:bbfadd75df17e3554da728',
    messagingSenderId: '516451377145',
    projectId: 'flutter-service-schedule',
    databaseURL: 'https://flutter-service-schedule.firebaseio.com',
    storageBucket: 'flutter-service-schedule.firebasestorage.app',
  );
}
