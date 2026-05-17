// Mengimport Cloud Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// Mengimport Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';

// Mengimport Flutter Material UI
import 'package:flutter/material.dart';

// Mengimport halaman kategori gerakan
import 'kategori_gerakan_screen.dart';

// Mengimport halaman riwayat latihan
import 'riwayat_latihan_screen.dart';

// Mengimport fungsi seed exercises
import '../../utils/seed_exercises.dart';

// Halaman menu utama aplikasi
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  // Fungsi untuk logout user
  Future<void> logout(BuildContext context) async {
    // Menampilkan dialog konfirmasi logout
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah kamu yakin ingin logout?'),
          actions: [
            // Tombol batal logout
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),

            // Tombol konfirmasi logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    // Jika user memilih logout
    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil user yang sedang login
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // AppBar menu utama
      appBar: AppBar(
        title: const Text('Main Menu'),
        centerTitle: true,
        actions: [
          // Tombol logout di kanan atas
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: SafeArea(
        // FutureBuilder digunakan untuk mengambil data user dari Firestore
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .get(),

          builder: (context, snapshot) {
            // Nama default jika data user belum ada
            String displayName = 'User';

            // Jika data user ditemukan di Firestore
            if (snapshot.hasData && snapshot.data!.data() != null) {
              final userData = snapshot.data!.data()!;

              // Ambil nama user dari Firestore
              displayName = userData['name'] ?? 'User';
            }
            // Jika data nama tidak ada, gunakan email
            else if (user?.email != null) {
              displayName = user!.email!;
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Card ucapan selamat datang
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat Datang',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 6),

                        // Menampilkan nama user
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Pilih menu untuk mulai latihan workout dengan deteksi gerakan.',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Menu kategori gerakan
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.category, color: Colors.blue),
                      title: const Text('Kategori Gerakan'),
                      subtitle: const Text('Lihat daftar kategori workout'),
                      trailing: const Icon(Icons.arrow_forward_ios),

                      // Pindah ke halaman kategori gerakan
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KategoriGerakanScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Menu riwayat latihan
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Colors.blue),
                      title: const Text('Riwayat Latihan'),
                      subtitle: const Text('Lihat hasil latihan sebelumnya'),
                      trailing: const Icon(Icons.arrow_forward_ios),

                      // Pindah ke halaman riwayat latihan
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RiwayatLatihanScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Tombol ini bisa digunakan untuk upload data exercise awal ke Firestore
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await seedExercises();
                  //   },
                  //   child: const Text("Upload Exercises"),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
