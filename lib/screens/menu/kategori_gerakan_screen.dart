// Mengimport Flutter Material UI
import 'package:flutter/material.dart';

// Mengimport halaman list gerakan
import 'list_gerakan_screen.dart';

// =====================================================
// HALAMAN KATEGORI GERAKAN
// =====================================================

// StatelessWidget digunakan karena data kategori
// tidak berubah selama halaman berjalan
class KategoriGerakanScreen extends StatelessWidget {
  // Constructor
  const KategoriGerakanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // =================================================
    // LIST KATEGORI GERAKAN
    // =================================================

    // List berisi nama kategori workout
    final List<String> categories = [
      // Latihan tubuh bagian atas
      'Upper Body',

      // Latihan tubuh bagian bawah
      'Lower Body',

      // Latihan cardio
      'Cardio',

      // Latihan flexibility / peregangan
      'Flexibility',
    ];

    return Scaffold(
      // =================================================
      // APP BAR
      // =================================================
      appBar: AppBar(
        // Judul halaman
        title: const Text('Kategori Gerakan'),

        // Judul di tengah
        centerTitle: true,
      ),

      // =================================================
      // BODY
      // =================================================
      body: ListView.builder(
        // Padding list
        padding: const EdgeInsets.all(16),

        // Jumlah item berdasarkan jumlah kategori
        itemCount: categories.length,

        // Builder untuk membuat item list
        itemBuilder: (context, index) {
          return Card(
            // =================================================
            // LIST TILE
            // =================================================
            child: ListTile(
              // Icon sebelah kiri
              leading: const Icon(Icons.fitness_center, color: Colors.blue),

              // Nama kategori
              title: Text(categories[index]),

              // Icon panah kanan
              trailing: const Icon(Icons.arrow_forward_ios),

              // =================================================
              // SAAT ITEM DIKLIK
              // =================================================
              onTap: () {
                // Pindah ke halaman list gerakan
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    // Mengirim category ke halaman berikutnya
                    builder: (context) => ListGerakanScreen(
                      // Category yang dipilih
                      category: categories[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
