// Mengimport package camera
// Digunakan untuk mengakses kamera perangkat
import 'package:camera/camera.dart';

// Mengimport Firebase Core
// Digunakan untuk inisialisasi Firebase
import 'package:firebase_core/firebase_core.dart';

// Mengimport Flutter Material UI
import 'package:flutter/material.dart';

// Mengimport SystemChrome
// Digunakan untuk mengatur orientasi layar
import 'package:flutter/services.dart';

// Mengimport file firebase_options.dart
// Berisi konfigurasi Firebase
import 'firebase_options.dart';

// Mengimport AuthWrapper
// Digunakan untuk mengecek status login user
import 'screens/auth/auth_wrapper.dart';

// =====================================================
// VARIABLE GLOBAL CAMERA
// =====================================================

// Menyimpan daftar kamera perangkat
late List<CameraDescription> cameras;

// =====================================================
// MAIN FUNCTION
// =====================================================

// Fungsi pertama yang dijalankan aplikasi
Future<void> main() async {
  // Memastikan Flutter sudah siap sebelum menjalankan async code
  WidgetsFlutterBinding.ensureInitialized();

  // ===================================================
  // INISIALISASI FIREBASE
  // ===================================================

  // Menghubungkan aplikasi dengan Firebase
  await Firebase.initializeApp(
    // Menggunakan konfigurasi platform saat ini
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ===================================================
  // MENGATUR ORIENTASI LAYAR
  // ===================================================

  // Mengatur orientasi yang diizinkan
  await SystemChrome.setPreferredOrientations([
    // Portrait tegak
    DeviceOrientation.portraitUp,

    // Landscape kiri
    DeviceOrientation.landscapeLeft,

    // Landscape kanan
    DeviceOrientation.landscapeRight,
  ]);

  // ===================================================
  // MENGAMBIL SEMUA KAMERA PERANGKAT
  // ===================================================

  // Mengambil daftar kamera
  cameras = await availableCameras();

  // ===================================================
  // MENJALANKAN APLIKASI
  // ===================================================

  runApp(const MyApp());
}

// =====================================================
// ROOT APPLICATION
// =====================================================

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  // Constructor
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan banner debug
      debugShowCheckedModeBanner: false,

      // Nama aplikasi
      title: 'Posefit',

      // Theme aplikasi
      theme: ThemeData(
        // Warna utama aplikasi
        primarySwatch: Colors.blue,
      ),

      // Halaman pertama aplikasi
      home: const AuthWrapper(),
    );
  }
}
