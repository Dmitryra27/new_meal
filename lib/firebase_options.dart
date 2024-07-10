import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'keys/keys.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  //final apiKey1 = dotenv.env['APIKEYWEB'] ?? '';

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '',
    appId: '1:539150273314:web:cc5a46281900cf6e9a737b',
    messagingSenderId: '539150273314',
    projectId: 'new-meal-7df05',
    authDomain: 'new-meal-7df05.firebaseapp.com',
    storageBucket: 'new-meal-7df05.appspot.com',
    measurementId: 'G-8W0LZQQ0YT',
  );
}

/*
const _storage = FlutterSecureStorage();
Future<String> getApiKeyFromSecureStorage() async {
  return await _storage.read(key: 'APIKEYWEB') ?? ''; // Установите значение по умолчанию
}

String apiKey = '';
String? api;

Future<void> initializeApiKey() async {
  api = await getApiKeyFromSecureStorage();
  if (api != null){
    apiKey = api!;
  };
}

Future<String> initializeApiKey2() async {
  String api1='';
  api = await getApiKeyFromSecureStorage();
  if (api != null){
    api1 = api!;
  };
  return api1;
}
*/
