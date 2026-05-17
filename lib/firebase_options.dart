// File ini dibuat otomatis oleh FlutterFire CLI
// ignore_for_file: type=lint

// Mengimport FirebaseOptions dari firebase_core
// FirebaseOptions digunakan untuk konfigurasi Firebase
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

// Mengimport informasi platform Flutter
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// =====================================================
// DEFAULT FIREBASE OPTIONS
// =====================================================

// Class ini digunakan untuk menyimpan
// konfigurasi Firebase untuk setiap platform
class DefaultFirebaseOptions {
  // ===================================================
  // MENENTUKAN PLATFORM YANG DIGUNAKAN
  // ===================================================

  // Getter currentPlatform digunakan untuk
  // mengambil konfigurasi Firebase sesuai platform
  static FirebaseOptions get currentPlatform {
    // Jika aplikasi berjalan di web
    if (kIsWeb) {
      // Gunakan konfigurasi web
      return web;
    }

    // Mengecek platform perangkat
    switch (defaultTargetPlatform) {
      // =================================================
      // ANDROID
      // =================================================

      case TargetPlatform.android:

        // Gunakan konfigurasi Android
        return android;

      // =================================================
      // IOS
      // =================================================

      case TargetPlatform.iOS:

        // Gunakan konfigurasi iOS
        return ios;

      // =================================================
      // MACOS
      // =================================================

      case TargetPlatform.macOS:

        // Gunakan konfigurasi macOS
        return macos;

      // =================================================
      // WINDOWS
      // =================================================

      case TargetPlatform.windows:

        // Gunakan konfigurasi Windows
        return windows;

      // =================================================
      // LINUX
      // =================================================

      case TargetPlatform.linux:

        // Error jika Linux belum dikonfigurasi
        throw UnsupportedError(
          // Pesan error
          'DefaultFirebaseOptions have not been configured for linux - '
          // Saran konfigurasi ulang
          'you can reconfigure this by running the FlutterFire CLI again.',
        );

      // =================================================
      // PLATFORM TIDAK DIDUKUNG
      // =================================================

      default:

        // Error jika platform tidak dikenali
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // =====================================================
  // KONFIGURASI FIREBASE WEB
  // =====================================================

  static const FirebaseOptions web = FirebaseOptions(
    // API Key Firebase
    apiKey: 'AIzaSyCr8JDQ_dJCg1gZ07ahwQAUJLf3p-Dohpc',

    // App ID Firebase
    appId: '1:441881788885:web:f735557db3bb440af87d5c',

    // Sender ID Firebase Messaging
    messagingSenderId: '441881788885',

    // Project ID Firebase
    projectId: 'posefit-964dd',

    // Domain Auth Firebase
    authDomain: 'posefit-964dd.firebaseapp.com',

    // Storage Bucket Firebase
    storageBucket: 'posefit-964dd.firebasestorage.app',

    // Google Analytics Measurement ID
    measurementId: 'G-CX0SSPCG8B',
  );

  // =====================================================
  // KONFIGURASI FIREBASE ANDROID
  // =====================================================

  static const FirebaseOptions android = FirebaseOptions(
    // API Key Android
    apiKey: 'AIzaSyDFGddZ4nAaNWipyt6wKVkheQIk2-d4hjk',

    // App ID Android
    appId: '1:441881788885:android:1a6147fdeef4ad94f87d5c',

    // Sender ID Firebase
    messagingSenderId: '441881788885',

    // Project ID Firebase
    projectId: 'posefit-964dd',

    // Storage Bucket Firebase
    storageBucket: 'posefit-964dd.firebasestorage.app',
  );

  // =====================================================
  // KONFIGURASI FIREBASE IOS
  // =====================================================

  static const FirebaseOptions ios = FirebaseOptions(
    // API Key iOS
    apiKey: 'AIzaSyASHZkXTr0Wcu7YS0kAyHyzgA3kTtKl4P0',

    // App ID iOS
    appId: '1:441881788885:ios:dca71aa895a9cc35f87d5c',

    // Sender ID Firebase
    messagingSenderId: '441881788885',

    // Project ID Firebase
    projectId: 'posefit-964dd',

    // Storage Bucket Firebase
    storageBucket: 'posefit-964dd.firebasestorage.app',

    // Bundle ID aplikasi iOS
    iosBundleId: 'com.example.posefit',
  );

  // =====================================================
  // KONFIGURASI FIREBASE MACOS
  // =====================================================

  static const FirebaseOptions macos = FirebaseOptions(
    // API Key macOS
    apiKey: 'AIzaSyASHZkXTr0Wcu7YS0kAyHyzgA3kTtKl4P0',

    // App ID macOS
    appId: '1:441881788885:ios:dca71aa895a9cc35f87d5c',

    // Sender ID Firebase
    messagingSenderId: '441881788885',

    // Project ID Firebase
    projectId: 'posefit-964dd',

    // Storage Bucket Firebase
    storageBucket: 'posefit-964dd.firebasestorage.app',

    // Bundle ID aplikasi macOS
    iosBundleId: 'com.example.posefit',
  );

  // =====================================================
  // KONFIGURASI FIREBASE WINDOWS
  // =====================================================

  static const FirebaseOptions windows = FirebaseOptions(
    // API Key Windows
    apiKey: 'AIzaSyCr8JDQ_dJCg1gZ07ahwQAUJLf3p-Dohpc',

    // App ID Windows
    appId: '1:441881788885:web:842a8e9c72d49912f87d5c',

    // Sender ID Firebase
    messagingSenderId: '441881788885',

    // Project ID Firebase
    projectId: 'posefit-964dd',

    // Domain Auth Firebase
    authDomain: 'posefit-964dd.firebaseapp.com',

    // Storage Bucket Firebase
    storageBucket: 'posefit-964dd.firebasestorage.app',

    // Google Analytics Measurement ID
    measurementId: 'G-MCLEKXDE6W',
  );
}
