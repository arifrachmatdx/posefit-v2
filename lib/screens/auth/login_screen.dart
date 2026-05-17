// Mengimport Firebase Authentication
// Digunakan untuk login user
import 'package:firebase_auth/firebase_auth.dart';

// Mengimport Flutter Material UI
import 'package:flutter/material.dart';

// Mengimport halaman register
import 'register_screen.dart';

// Mengimport halaman menu utama
import '../menu/main_menu_screen.dart';

// =====================================================
// LOGIN SCREEN
// =====================================================

// StatefulWidget digunakan karena halaman ini
// memiliki data yang bisa berubah
// seperti loading dan input text
class LoginScreen extends StatefulWidget {
  // Constructor
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// =====================================================
// STATE LOGIN SCREEN
// =====================================================

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk mengambil isi input email
  final TextEditingController emailController = TextEditingController();

  // Controller untuk mengambil isi input password
  final TextEditingController passwordController = TextEditingController();

  // Penanda loading saat proses login
  bool isLoading = false;

  // =====================================================
  // FUNGSI LOGIN USER
  // =====================================================

  Future<void> loginUser() async {
    // Mengambil text email
    final email = emailController.text.trim();

    // Mengambil text password
    final password = passwordController.text.trim();

    // =================================================
    // VALIDASI INPUT
    // =================================================

    // Jika email atau password kosong
    if (email.isEmpty || password.isEmpty) {
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi')),
      );

      return;
    }

    try {
      // =================================================
      // MULAI LOADING
      // =================================================

      setState(() {
        isLoading = true;
      });

      // =================================================
      // LOGIN KE FIREBASE
      // =================================================

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        // Email user
        email: email,

        // Password user
        password: password,
      );

      // Mengecek apakah widget masih aktif
      if (!mounted) return;

      // =================================================
      // PINDAH KE MENU UTAMA
      // =================================================

      Navigator.pushReplacement(
        // Context halaman sekarang
        context,

        // Pindah ke MainMenuScreen
        MaterialPageRoute(builder: (context) => const MainMenuScreen()),
      );

      // ===================================================
      // ERROR FIREBASE AUTH
      // ===================================================
    } on FirebaseAuthException catch (e) {
      // Pesan default
      String message = 'Login gagal';

      // Jika email/password salah
      if (e.code == 'invalid-credential') {
        message = 'Email atau password salah';

        // Jika format email salah
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid';

        // Jika akun dinonaktifkan
      } else if (e.code == 'user-disabled') {
        message = 'Akun ini dinonaktifkan';
      }

      // Menampilkan pesan error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      // ===================================================
      // ERROR UMUM
      // ===================================================
    } catch (e) {
      // Menampilkan error lain
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      // Mengecek apakah widget masih aktif
      if (!mounted) return;

      // =================================================
      // STOP LOADING
      // =================================================

      setState(() {
        isLoading = false;
      });
    }
  }

  // =====================================================
  // DISPOSE CONTROLLER
  // =====================================================

  @override
  void dispose() {
    // Membersihkan controller email
    emailController.dispose();

    // Membersihkan controller password
    passwordController.dispose();

    super.dispose();
  }

  // =====================================================
  // UI LOGIN SCREEN
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =================================================
      // APP BAR
      // =================================================
      appBar: AppBar(
        // Judul halaman
        title: const Text('Login'),

        // Posisi judul di tengah
        centerTitle: true,
      ),

      // =================================================
      // BODY
      // =================================================
      body: SafeArea(
        // SafeArea agar UI tidak tertutup notch
        child: SingleChildScrollView(
          // Agar layar bisa discroll ketika keyboard muncul
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,

            // Menyesuaikan dengan keyboard
            20 + MediaQuery.of(context).viewInsets.bottom,
          ),

          child: ConstrainedBox(
            // Mengatur minimal tinggi layar
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),

            child: IntrinsicHeight(
              child: Column(
                // Isi column di tengah
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // Spacer atas
                  const Spacer(),

                  // =================================================
                  // ICON
                  // =================================================
                  const Icon(
                    Icons.fitness_center,
                    size: 80,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // JUDUL APLIKASI
                  // =================================================
                  const Text(
                    'Posefit',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Aplikasi Deteksi Gerakan Workout',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // INPUT EMAIL
                  // =================================================
                  TextField(
                    // Controller email
                    controller: emailController,

                    decoration: const InputDecoration(
                      // Label input
                      labelText: 'Email',

                      // Border kotak
                      border: OutlineInputBorder(),

                      // Icon email
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // INPUT PASSWORD
                  // =================================================
                  TextField(
                    // Controller password
                    controller: passwordController,

                    // Menyembunyikan password
                    obscureText: true,

                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // BUTTON LOGIN
                  // =================================================
                  SizedBox(
                    // Lebar penuh
                    width: double.infinity,

                    child: ElevatedButton(
                      // Jika loading tombol disable
                      onPressed: isLoading ? null : loginUser,

                      child:
                          // Jika loading tampilkan spinner
                          isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,

                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          // Jika tidak loading
                          : const Text('Login'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // BUTTON KE REGISTER
                  // =================================================
                  TextButton(
                    onPressed: () {
                      // Pindah ke halaman register
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },

                    child: const Text('Belum punya akun? Register'),
                  ),

                  // Spacer bawah
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
