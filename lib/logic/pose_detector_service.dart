// Mengimport library ML Kit Pose Detection
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// Mengimport model exercise
import '../models/exercise_model.dart';

// Mengimport model hasil deteksi
import '../models/exercise_detection_result.dart';

// Mengimport logika push-up
import 'exercises/pushup_logic.dart';

// Service utama untuk pose detection
class PoseDetectorService {
  // Membuat object PoseDetector dari ML Kit
  final PoseDetector poseDetector = PoseDetector(
    // Konfigurasi detector
    options: PoseDetectorOptions(
      // Mode stream digunakan untuk realtime camera
      mode: PoseDetectionMode.stream,

      // Menggunakan model accurate agar lebih presisi
      model: PoseDetectionModel.accurate,
    ),
  );

  // Membuat instance logika push-up
  final PushUpLogic _pushUpLogic = PushUpLogic();

  // =====================================================
  // MEMPROSES GAMBAR DARI CAMERA
  // =====================================================

  // Fungsi untuk mendeteksi pose dari InputImage
  Future<List<Pose>> processImage(InputImage inputImage) async {
    // Mengirim gambar ke ML Kit
    // lalu mengembalikan hasil pose
    return await poseDetector.processImage(inputImage);
  }

  // =====================================================
  // MEMPROSES LATIHAN BERDASARKAN JENIS EXERCISE
  // =====================================================

  ExerciseDetectionResult processExercise({
    // Jenis exercise yang dipilih
    required ExerciseType exerciseType,

    // Pose hasil deteksi kamera
    required Pose pose,
  }) {
    // Switch digunakan untuk memilih logika exercise
    switch (exerciseType) {
      // =================================================
      // PUSH UP
      // =================================================
      case ExerciseType.pushUp:

        // Menggunakan logika push-up
        return _pushUpLogic.detect(pose);

      // =================================================
      // SQUAT
      // =================================================
      case ExerciseType.squat:

        // Placeholder sementara
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika squat belum dipasang',
          isValidPose: false,
          stage: 'idle',
        );

      // =================================================
      // JUMPING JACK
      // =================================================
      case ExerciseType.jumpingJack:

        // Placeholder sementara
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika jumping jack belum dipasang',
          isValidPose: false,
          stage: 'idle',
        );

      // =================================================
      // PLANK
      // =================================================
      case ExerciseType.plank:

        // Placeholder sementara
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika plank belum dipasang',
          isValidPose: false,
          stage: 'idle',
        );

      // =================================================
      // HIGH KNEES
      // =================================================
      case ExerciseType.highKnees:

        // Placeholder sementara
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika high knees belum dipasang',
          isValidPose: false,
          stage: 'idle',
        );
    }
  }

  // =====================================================
  // RESET DATA EXERCISE
  // =====================================================

  void resetExercise(ExerciseType exerciseType) {
    // Memilih exercise yang akan di-reset
    switch (exerciseType) {
      // Reset push-up
      case ExerciseType.pushUp:
        _pushUpLogic.reset();
        break;

      // Exercise lain belum memiliki reset logic
      case ExerciseType.squat:
      case ExerciseType.jumpingJack:
      case ExerciseType.plank:
      case ExerciseType.highKnees:
        break;
    }
  }

  // =====================================================
  // MENUTUP POSE DETECTOR
  // =====================================================

  void dispose() {
    // Menutup detector agar memory tidak bocor
    poseDetector.close();
  }
}
