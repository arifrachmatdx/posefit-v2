// Mengimport Cloud Firestore
// Digunakan untuk mengambil data riwayat latihan
import 'package:cloud_firestore/cloud_firestore.dart';

// Mengimport Firebase Auth
// Digunakan untuk mengecek user yang sedang login
import 'package:firebase_auth/firebase_auth.dart';

// Mengimport Flutter Material UI
import 'package:flutter/material.dart';

// Halaman untuk menampilkan riwayat latihan user
class RiwayatLatihanScreen extends StatelessWidget {
  const RiwayatLatihanScreen({super.key});

  // Fungsi untuk mengubah detik menjadi format MM:SS
  String formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    final minuteText = minutes.toString().padLeft(2, '0');
    final secondText = seconds.toString().padLeft(2, '0');

    return '$minuteText:$secondText';
  }

  // Fungsi untuk mengubah Timestamp Firestore menjadi format tanggal
  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil user yang sedang login
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // AppBar halaman riwayat
      appBar: AppBar(title: const Text('Riwayat Latihan'), centerTitle: true),

      // Jika user belum login
      body: user == null
          ? const Center(child: Text('User belum login'))
          // Jika user sudah login, ambil data dari Firestore
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              // Stream digunakan agar data riwayat berubah secara realtime
              stream: FirebaseFirestore.instance
                  .collection('workout_history')
                  .where('userId', isEqualTo: user.uid)
                  .orderBy('date', descending: true)
                  .snapshots(),

              builder: (context, snapshot) {
                // Saat data masih loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Jika terjadi error saat mengambil data
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi error: ${snapshot.error}'),
                  );
                }

                // Jika data kosong
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada riwayat latihan',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                // Mengambil semua dokumen riwayat latihan
                final docs = snapshot.data!.docs;

                // Menampilkan data riwayat dalam bentuk list
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // Mengambil data dari setiap dokumen
                    final data = docs[index].data();

                    // Mengambil judul latihan
                    final exerciseTitle = data['exerciseTitle'] ?? '-';

                    // Mengambil kategori latihan
                    final category = data['category'] ?? '-';

                    // Mengambil jumlah repetisi
                    final repetition = data['repetition'] ?? 0;

                    // Mengambil durasi latihan
                    final duration = data['duration'] ?? 0;

                    // Mengambil tanggal latihan
                    final date = data['date'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        // Icon riwayat
                        leading: const Icon(Icons.history, color: Colors.blue),

                        // Judul latihan
                        title: Text(
                          exerciseTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        // Detail riwayat latihan
                        subtitle: Text(
                          'Kategori: $category\n'
                          'Repetisi: $repetition\n'
                          'Durasi: ${formatDuration(duration)}\n'
                          'Waktu: ${date is Timestamp ? formatDate(date) : '-'}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
