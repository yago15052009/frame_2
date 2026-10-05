// ATENÇÃO: Substitua os valores abaixo pelas configurações do seu projeto Firebase.
// Acesse: https://console.firebase.google.com → Seu projeto → Configurações → Seus apps → Web
// Copie os valores do objeto firebaseConfig e cole aqui.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return web;
    }
  }

  // ▼ Preencha com os dados do seu projeto Firebase (Web)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'SUA_API_KEY',
    appId: 'SEU_APP_ID',
    messagingSenderId: 'SEU_MESSAGING_SENDER_ID',
    projectId: 'SEU_PROJECT_ID',
    authDomain: 'SEU_PROJECT_ID.firebaseapp.com',
    storageBucket: 'SEU_PROJECT_ID.appspot.com',
  );

  // ▼ Preencha com os dados do seu projeto Firebase (Android) — opcional
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'SUA_API_KEY_ANDROID',
    appId: 'SEU_APP_ID_ANDROID',
    messagingSenderId: 'SEU_MESSAGING_SENDER_ID',
    projectId: 'SEU_PROJECT_ID',
    storageBucket: 'SEU_PROJECT_ID.appspot.com',
  );
}
