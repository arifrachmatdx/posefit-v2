// Mengimport Firebase Authentication
// Digunakan untuk mengecek status login user
import 'package:firebase_auth/firebase_auth.dart';

// Mengimport Flutter Material
import 'package:flutter/material.dart';

// Mengimport halaman login
import 'login_screen.dart';

// Mengimport halaman menu utama
import '../menu/main_menu_screen.dart';

// =====================================================
// AUTH WRAPPER
// =====================================================

// Widget ini digunakan untuk mengecek
// apakah user sudah login atau belum
class AuthWrapper extends StatelessWidget {
  // Constructor
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder digunakan untuk memantau perubahan login secara realtime
    return StreamBuilder<User?>(
      // Stream authStateChanges akan berubah ketika:
      // - user login
      // - user logout
      // - session berubah
      stream: FirebaseAuth.instance.authStateChanges(),

      // Builder akan dijalankan setiap ada perubahan auth
      builder: (context, snapshot) {
        // =================================================
        // SAAT MASIH LOADING
        // =================================================

        // Ketika Firebase masih mengecek status login
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading
          return const Scaffold(
            body: Center(
              // Loading spinner
              child: CircularProgressIndicator(),
            ),
          );
        }

        // =================================================
        // JIKA USER SUDAH LOGIN
        // =================================================

        // snapshot.hasData artinya user ditemukan / sudah login
        if (snapshot.hasData) {
          // Arahkan ke menu utama
          return const MainMenuScreen();
        }

        // =================================================
        // JIKA USER BELUM LOGIN
        // =================================================

        // Tampilkan halaman login
        return const LoginScreen();
      },
    );
  }
}
