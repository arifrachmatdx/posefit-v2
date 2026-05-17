// Mengimport Cloud Firestore
// Digunakan untuk menyimpan data exercise ke database
import 'package:cloud_firestore/cloud_firestore.dart';

// =====================================================
// FUNGSI SEED EXERCISES
// =====================================================

// Fungsi ini digunakan untuk upload data awal exercise
// ke Firestore secara otomatis
Future<void> seedExercises() async {
  // =====================================================
  // LIST DATA EXERCISE
  // =====================================================

  // List berisi semua data latihan
  final exercises = [
    // =================================================
    // PUSH UP
    // =================================================
    {
      // ID document Firestore
      "id": "push_up",

      // Nama exercise
      "title": "Push Up",

      // Kategori exercise
      "category": "Upper Body",

      // Jenis exercise
      "type": "pushUp",

      // Target repetisi
      "targetRepetition": 10,

      // Target durasi latihan dalam detik
      "targetDurationInSeconds": 60,

      // Status aktif
      "isActive": true,
    },

    // =================================================
    // PLANK
    // =================================================
    {
      "id": "plank",
      "title": "Plank",
      "category": "Upper Body",
      "type": "plank",
      "targetRepetition": 1,
      "targetDurationInSeconds": 30,
      "isActive": true,
    },

    // =================================================
    // SQUAT
    // =================================================
    {
      "id": "squat",
      "title": "Squat",
      "category": "Lower Body",
      "type": "squat",
      "targetRepetition": 15,
      "targetDurationInSeconds": 60,
      "isActive": true,
    },

    // =================================================
    // HIGH KNEES
    // =================================================
    {
      "id": "high_knees",
      "title": "High Knees",
      "category": "Cardio",
      "type": "highKnees",
      "targetRepetition": 20,
      "targetDurationInSeconds": 45,
      "isActive": true,
    },

    // =================================================
    // JUMPING JACK
    // =================================================
    {
      "id": "jumping_jack",
      "title": "Jumping Jack",
      "category": "Cardio",
      "type": "jumpingJack",
      "targetRepetition": 20,
      "targetDurationInSeconds": 60,
      "isActive": true,
    },

    // =================================================
    // STRETCH PLANK
    // =================================================
    {
      "id": "stretch_plank",
      "title": "Stretch Plank",
      "category": "Flexibility",
      "type": "plank",
      "targetRepetition": 1,
      "targetDurationInSeconds": 30,
      "isActive": true,
    },
  ];

  // =====================================================
  // LOOPING SEMUA EXERCISE
  // =====================================================

  // Mengulang semua data exercise
  for (var exercise in exercises) {
    // Mengambil ID document
    final id = exercise["id"];

    // Mengubah Map menjadi dynamic
    final data = Map<String, dynamic>.from(exercise);

    // Menghapus field id dari data
    // karena id akan digunakan sebagai document ID
    data.remove("id");

    // =================================================
    // UPLOAD KE FIRESTORE
    // =================================================

    await FirebaseFirestore.instance
        // Collection exercises
        .collection("exercises")
        // Document ID
        .doc(id as String)
        // Menyimpan data
        .set(data);
  }

  // =====================================================
  // LOG BERHASIL
  // =====================================================

  // Menampilkan pesan berhasil di console
  print("Exercises berhasil diupload");
}
