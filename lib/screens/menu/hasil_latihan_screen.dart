// Mengimport Flutter Material UI
import 'package:flutter/material.dart';

// Mengimport model exercise
import '../../models/exercise_model.dart';

// =====================================================
// HALAMAN HASIL LATIHAN
// =====================================================

// StatelessWidget digunakan karena halaman ini
// tidak memiliki perubahan data setelah dibuat
class HasilLatihanScreen extends StatelessWidget {
  // Data exercise yang selesai dilakukan
  final ExerciseModel exercise;

  // Jumlah repetisi hasil latihan
  final int repetitionCount;

  // Text durasi latihan
  // Contoh: 01:25
  final String durationText;

  // Constructor
  const HasilLatihanScreen({
    super.key,

    // Data exercise wajib diisi
    required this.exercise,

    // Repetisi wajib diisi
    required this.repetitionCount,

    // Durasi wajib diisi
    required this.durationText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =================================================
      // APP BAR
      // =================================================
      appBar: AppBar(
        // Judul halaman
        title: const Text('Hasil Latihan'),

        // Judul di tengah
        centerTitle: true,
      ),

      // =================================================
      // BODY
      // =================================================
      body: SafeArea(
        // SafeArea agar UI tidak tertutup notch/status bar
        child: Padding(
          // Padding seluruh isi halaman
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // =================================================
              // CARD INFORMASI EXERCISE
              // =================================================
              Container(
                // Lebar penuh
                width: double.infinity,

                // Padding dalam container
                padding: const EdgeInsets.all(24),

                // Dekorasi container
                decoration: BoxDecoration(
                  // Warna berdasarkan exercise
                  color: exercise.color,

                  // Membuat sudut rounded
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    // Icon trophy / kemenangan
                    const Icon(
                      Icons.emoji_events,

                      // Ukuran icon
                      size: 70,

                      // Warna icon
                      color: Colors.white,
                    ),

                    const SizedBox(height: 16),

                    // =================================================
                    // NAMA EXERCISE
                    // =================================================
                    Text(
                      // Nama exercise
                      exercise.title,

                      style: const TextStyle(
                        // Warna text
                        color: Colors.white,

                        // Ukuran font
                        fontSize: 24,

                        // Font tebal
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // =================================================
                    // KATEGORI EXERCISE
                    // =================================================
                    Text(
                      // Kategori exercise
                      exercise.category,

                      style: const TextStyle(
                        // Warna text sedikit transparan
                        color: Colors.white70,

                        // Ukuran font
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =================================================
              // CARD JUMLAH REPETISI
              // =================================================
              Container(
                // Lebar penuh
                width: double.infinity,

                // Padding dalam container
                padding: const EdgeInsets.all(24),

                // Dekorasi container
                decoration: BoxDecoration(
                  // Background hijau muda
                  color: Colors.green.shade50,

                  // Rounded corner
                  borderRadius: BorderRadius.circular(16),

                  // Border hijau
                  border: Border.all(color: Colors.green.shade200),
                ),

                child: Column(
                  children: [
                    // Judul repetisi
                    const Text(
                      'Jumlah Repetisi',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =================================================
                    // TOTAL REPETISI
                    // =================================================
                    Text(
                      // Menampilkan jumlah repetisi
                      '$repetitionCount',

                      style: const TextStyle(
                        // Ukuran text besar
                        fontSize: 42,

                        // Tebal
                        fontWeight: FontWeight.bold,

                        // Warna hijau
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // CARD DURASI LATIHAN
              // =================================================
              Container(
                // Lebar penuh
                width: double.infinity,

                // Padding dalam container
                padding: const EdgeInsets.all(24),

                // Dekorasi container
                decoration: BoxDecoration(
                  // Background biru muda
                  color: Colors.blue.shade50,

                  // Rounded corner
                  borderRadius: BorderRadius.circular(16),

                  // Border biru
                  border: Border.all(color: Colors.blue.shade200),
                ),

                child: Column(
                  children: [
                    // Judul durasi
                    const Text(
                      'Durasi Latihan',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =================================================
                    // TOTAL DURASI
                    // =================================================
                    Text(
                      // Menampilkan durasi latihan
                      durationText,

                      style: const TextStyle(
                        // Ukuran text
                        fontSize: 32,

                        // Tebal
                        fontWeight: FontWeight.bold,

                        // Warna biru
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              // Spacer agar tombol berada di bawah
              const Spacer(),

              // =================================================
              // BUTTON KEMBALI KE AWAL
              // =================================================
              SizedBox(
                // Lebar penuh
                width: double.infinity,

                child: ElevatedButton(
                  // Fungsi ketika tombol ditekan
                  onPressed: () {
                    // Kembali ke halaman pertama
                    Navigator.popUntil(
                      context,

                      // route.isFirst = halaman pertama
                      (route) => route.isFirst,
                    );
                  },

                  // Text tombol
                  child: const Text('Kembali ke Awal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
