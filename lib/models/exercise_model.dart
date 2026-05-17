// Mengimport library Flutter Material
// Digunakan untuk Color dan komponen UI lainnya
import 'package:flutter/material.dart';

// =====================================================
// ENUM JENIS EXERCISE
// =====================================================

// Enum digunakan untuk membuat pilihan data tetap
// Jadi exercise hanya bisa berisi salah satu nilai berikut
enum ExerciseType {
  // Push-up
  pushUp,

  // Squat
  squat,

  // Jumping Jack
  jumpingJack,

  // Plank
  plank,

  // High Knees
  highKnees,
}

// =====================================================
// MODEL DATA EXERCISE
// =====================================================

// Class ini digunakan sebagai blueprint / struktur data
// untuk menyimpan informasi latihan
class ExerciseModel {
  // Nama latihan
  // Contoh: Push Up Beginner
  final String title;

  // Kategori latihan
  // Contoh: Upper Body
  final String category;

  // Path gambar exercise
  // Contoh: assets/images/pushup.png
  final String imagePath;

  // Warna utama card exercise
  final Color color;

  // Jenis exercise
  // Menggunakan enum ExerciseType
  final ExerciseType type;

  // Target jumlah repetisi
  // Contoh: 10 push-up
  final int targetRepetition;

  // Target durasi latihan dalam detik
  // Contoh: 60 = 1 menit
  final int targetDurationInSeconds;

  // =====================================================
  // CONSTRUCTOR
  // =====================================================

  // Constructor digunakan untuk membuat object ExerciseModel
  // required artinya semua data wajib diisi
  ExerciseModel({
    required this.title,
    required this.category,
    required this.imagePath,
    required this.color,
    required this.type,
    required this.targetRepetition,
    required this.targetDurationInSeconds,
  });
}
