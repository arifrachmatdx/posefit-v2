// Class untuk menyimpan hasil deteksi exercise
class ExerciseDetectionResult {
  // Menyimpan jumlah repetisi
  // Contoh: push-up sudah 5 kali
  final int repetition;

  // Menyimpan status gerakan
  // Contoh: "Turunkan badan", "Naikkan badan"
  final String status;

  // Menandakan apakah pose valid atau tidak
  // true  = pose benar
  // false = pose salah / tidak terdeteksi
  final bool isValidPose;

  // Menyimpan tahapan gerakan
  // Contoh:
  // idle  = belum mulai
  // down  = posisi turun
  // up    = posisi naik
  // ready = posisi siap
  final String stage;

  // Constructor utama
  // required artinya wajib diisi
  const ExerciseDetectionResult({
    required this.repetition,
    required this.status,
    required this.isValidPose,
    required this.stage,
  });

  // =====================================================
  // DATA AWAL / DEFAULT
  // =====================================================

  // Factory constructor digunakan untuk membuat
  // object awal sebelum workout dimulai
  factory ExerciseDetectionResult.initial() {
    // Mengembalikan data default
    return const ExerciseDetectionResult(
      // Belum ada repetisi
      repetition: 0,

      // Status awal
      status: 'Belum ada gerakan',

      // Pose belum valid
      isValidPose: false,

      // Tahap idle = diam / belum mulai
      stage: 'idle',
    );
  }
}
