// Mengimport Firebase Authentication
// Digunakan untuk register user
import 'package:firebase_auth/firebase_auth.dart';

// Mengimport Flutter Material UI
import 'package:flutter/material.dart';

// Mengimport Cloud Firestore
// Digunakan untuk menyimpan data user ke database
import 'package:cloud_firestore/cloud_firestore.dart';

// =====================================================
// REGISTER SCREEN
// =====================================================

// StatefulWidget digunakan karena data pada halaman
// bisa berubah seperti loading dan input text
class RegisterScreen extends StatefulWidget {
  // Constructor
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// =====================================================
// STATE REGISTER SCREEN
// =====================================================

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk input nama
  final TextEditingController nameController = TextEditingController();

  // Controller untuk input email
  final TextEditingController emailController = TextEditingController();

  // Controller untuk input password
  final TextEditingController passwordController = TextEditingController();

  // Penanda loading saat proses register
  bool isLoading = false;

  // =====================================================
  // FUNGSI REGISTER USER
  // =====================================================

  Future<void> registerUser() async {
    // Mengambil text nama
    final name = nameController.text.trim();

    // Mengambil text email
    final email = emailController.text.trim();

    // Mengambil text password
    final password = passwordController.text.trim();

    // =================================================
    // VALIDASI INPUT
    // =================================================

    // Jika ada field kosong
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      // Menampilkan pesan error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));

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
      // REGISTER USER KE FIREBASE AUTH
      // =================================================

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            // Email user
            email: email,

            // Password user
            password: password,
          );

      // Mengambil data user hasil register
      final user = userCredential.user;

      // =================================================
      // SIMPAN DATA USER KE FIRESTORE
      // =================================================

      // Jika user berhasil dibuat
      if (user != null) {
        // Simpan data user ke collection users
        await FirebaseFirestore.instance
            .collection('users')
            // Document ID menggunakan UID user
            .doc(user.uid)
            // Menyimpan data
            .set({
              // Nama user
              'name': name,

              // Email user
              'email': email,

              // Waktu dibuat
              'createdAt': FieldValue.serverTimestamp(),
            });
      }

      // Mengecek apakah widget masih aktif
      if (!mounted) return;

      // =================================================
      // TAMPILKAN PESAN BERHASIL
      // =================================================

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Register berhasil')));

      // =================================================
      // KEMBALI KE HALAMAN LOGIN
      // =================================================

      Navigator.pop(context);

      // ===================================================
      // ERROR FIREBASE AUTH
      // ===================================================
    } on FirebaseAuthException catch (e) {
      // Pesan default
      String message = 'Terjadi kesalahan';

      // Jika email sudah dipakai
      if (e.code == 'email-already-in-use') {
        message = 'Email sudah digunakan';

        // Jika format email salah
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid';

        // Jika password terlalu lemah
      } else if (e.code == 'weak-password') {
        message = 'Password terlalu lemah, minimal 6 karakter';
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
    // Membersihkan controller nama
    nameController.dispose();

    // Membersihkan controller email
    emailController.dispose();

    // Membersihkan controller password
    passwordController.dispose();

    super.dispose();
  }

  // =====================================================
  // UI REGISTER SCREEN
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =================================================
      // APP BAR
      // =================================================
      appBar: AppBar(
        // Judul halaman
        title: const Text('Register'),

        // Judul di tengah
        centerTitle: true,
      ),

      // =================================================
      // BODY
      // =================================================
      body: SafeArea(
        // SafeArea agar UI tidak tertutup notch
        child: SingleChildScrollView(
          // Agar layar bisa discroll saat keyboard muncul
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,

            // Menyesuaikan dengan keyboard
            20 + MediaQuery.of(context).viewInsets.bottom,
          ),

          child: ConstrainedBox(
            // Mengatur tinggi minimum layar
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
                  const Icon(Icons.person_add, size: 80, color: Colors.blue),

                  const SizedBox(height: 20),

                  // =================================================
                  // JUDUL
                  // =================================================
                  const Text(
                    'Daftar Akun Posefit',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // INPUT NAMA
                  // =================================================
                  TextField(
                    // Controller nama
                    controller: nameController,

                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // INPUT EMAIL
                  // =================================================
                  TextField(
                    // Controller email
                    controller: emailController,

                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
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

                    // Password disembunyikan
                    obscureText: true,

                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // BUTTON REGISTER
                  // =================================================
                  SizedBox(
                    // Lebar penuh
                    width: double.infinity,

                    child: ElevatedButton(
                      // Jika loading tombol disable
                      onPressed: isLoading ? null : registerUser,

                      child:
                          // Jika loading tampilkan spinner
                          isLoading
                          ? const CircularProgressIndicator()
                          // Jika tidak loading
                          : const Text('Daftar'),
                    ),
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
