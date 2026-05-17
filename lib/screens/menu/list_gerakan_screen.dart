// Mengimport Flutter Material UI
import 'package:flutter/material.dart';

// Mengimport model exercise
import '../../models/exercise_model.dart';

// Mengimport halaman detection screen
import '../detection/detection_screen.dart';

// =====================================================
// HALAMAN LIST GERAKAN
// =====================================================

// StatefulWidget digunakan karena data
// filteredExercises dapat berubah
class ListGerakanScreen extends StatefulWidget {
  // Kategori yang dikirim dari halaman sebelumnya
  final String category;

  // Constructor
  const ListGerakanScreen({super.key, required this.category});

  @override
  State<ListGerakanScreen> createState() => _ListGerakanScreenState();
}

// =====================================================
// STATE LIST GERAKAN SCREEN
// =====================================================

class _ListGerakanScreenState extends State<ListGerakanScreen> {
  // =====================================================
  // SEMUA DATA EXERCISE
  // =====================================================

  // List semua gerakan workout
  final List<ExerciseModel> allExercises = [
    // =================================================
    // PUSH UP
    // =================================================
    ExerciseModel(
      // Nama exercise
      title: 'Push Up',

      // Kategori exercise
      category: 'Upper Body',

      // Path gambar
      imagePath: '',

      // Warna card
      color: Colors.blue,

      // Jenis exercise
      type: ExerciseType.pushUp,

      // Target repetisi
      targetRepetition: 10,

      // Durasi latihan dalam detik
      targetDurationInSeconds: 60,
    ),

    // =================================================
    // PLANK
    // =================================================
    ExerciseModel(
      title: 'Plank',
      category: 'Upper Body',
      imagePath: '',
      color: Colors.indigo,
      type: ExerciseType.plank,
      targetRepetition: 1,
      targetDurationInSeconds: 30,
    ),

    // =================================================
    // SQUAT
    // =================================================
    ExerciseModel(
      title: 'Squat',
      category: 'Lower Body',
      imagePath: '',
      color: Colors.green,
      type: ExerciseType.squat,
      targetRepetition: 15,
      targetDurationInSeconds: 60,
    ),

    // =================================================
    // HIGH KNEES
    // =================================================
    ExerciseModel(
      title: 'High Knees',
      category: 'Lower Body',
      imagePath: '',
      color: Colors.teal,
      type: ExerciseType.highKnees,
      targetRepetition: 20,
      targetDurationInSeconds: 45,
    ),

    // =================================================
    // JUMPING JACK
    // =================================================
    ExerciseModel(
      title: 'Jumping Jack',
      category: 'Cardio',
      imagePath: '',
      color: Colors.orange,
      type: ExerciseType.jumpingJack,
      targetRepetition: 20,
      targetDurationInSeconds: 60,
    ),

    // =================================================
    // PLANK STRETCH
    // =================================================
    ExerciseModel(
      title: 'Plank Stretch',
      category: 'Flexibility',
      imagePath: '',
      color: Colors.purple,
      type: ExerciseType.plank,
      targetRepetition: 1,
      targetDurationInSeconds: 30,
    ),
  ];

  // =====================================================
  // LIST HASIL FILTER KATEGORI
  // =====================================================

  // List untuk menyimpan exercise
  // berdasarkan kategori yang dipilih
  List<ExerciseModel> filteredExercises = [];

  // =====================================================
  // INIT STATE
  // =====================================================

  @override
  void initState() {
    super.initState();

    // Filter exercise berdasarkan kategori
    filteredExercises = allExercises
        // Mencari category yang sama
        .where((exercise) => exercise.category == widget.category)
        // Mengubah hasil menjadi list
        .toList();
  }

  // =====================================================
  // BUILD UI
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =================================================
      // APP BAR
      // =================================================
      appBar: AppBar(
        // Judul halaman
        title: Text('List Gerakan - ${widget.category}'),

        // Judul di tengah
        centerTitle: true,
      ),

      // =================================================
      // BODY
      // =================================================
      body:
          // Jika tidak ada exercise
          filteredExercises.isEmpty
          // =================================================
          // TAMPILKAN PESAN KOSONG
          // =================================================
          ? const Center(
              child: Text(
                // Pesan jika list kosong
                'Belum ada gerakan pada kategori ini',

                style: TextStyle(fontSize: 18),
              ),
            )
          // =================================================
          // TAMPILKAN LIST EXERCISE
          // =================================================
          : ListView.builder(
              // Padding list
              padding: const EdgeInsets.all(16),

              // Jumlah item list
              itemCount: filteredExercises.length,

              // Builder item list
              itemBuilder: (context, index) {
                // Mengambil data exercise
                final exercise = filteredExercises[index];

                return Container(
                  // Margin bawah antar card
                  margin: const EdgeInsets.only(bottom: 16),

                  // Dekorasi card
                  decoration: BoxDecoration(
                    // Warna berdasarkan exercise
                    color: exercise.color,

                    // Rounded corner
                    borderRadius: BorderRadius.circular(16),
                  ),

                  // =================================================
                  // LIST TILE
                  // =================================================
                  child: ListTile(
                    // Padding isi card
                    contentPadding: const EdgeInsets.all(16),

                    // =================================================
                    // ICON
                    // =================================================
                    leading: const Icon(
                      Icons.fitness_center,

                      // Warna icon
                      color: Colors.white,

                      // Ukuran icon
                      size: 32,
                    ),

                    // =================================================
                    // TITLE
                    // =================================================
                    title: Text(
                      // Nama exercise
                      exercise.title,

                      style: const TextStyle(
                        // Warna text
                        color: Colors.white,

                        // Ukuran text
                        fontSize: 20,

                        // Font tebal
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // =================================================
                    // SUBTITLE
                    // =================================================
                    subtitle: Text(
                      // Nama kategori
                      exercise.category,

                      style: const TextStyle(color: Colors.white70),
                    ),

                    // =================================================
                    // ICON PANAH
                    // =================================================
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),

                    // =================================================
                    // SAAT CARD DIKLIK
                    // =================================================
                    onTap: () {
                      // Pindah ke halaman detection
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          // Mengirim data exercise
                          builder: (context) => DetectionScreen(
                            // Exercise yang dipilih
                            exercise: exercise,
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
