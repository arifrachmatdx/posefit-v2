// Mengimport library matematika untuk menghitung sudut dan jarak
import 'dart:math';

// Mengimport ML Kit Pose Detection
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// Mengimport model hasil deteksi exercise
import '../../models/exercise_detection_result.dart';

// Class utama untuk logika push-up
class PushUpLogic {
  // Menyimpan jumlah push-up yang berhasil dihitung
  int pushUpCount = 0;

  // Penanda apakah posisi badan sedang turun
  bool isLowered = false;

  // Fungsi utama untuk mendeteksi pose push-up
  ExerciseDetectionResult detect(Pose pose) {
    // Mengambil semua titik landmark tubuh
    final landmarks = pose.landmarks;

    // Mengambil titik tubuh sebelah kiri
    final leftShoulder = landmarks[PoseLandmarkType.leftShoulder];
    final leftElbow = landmarks[PoseLandmarkType.leftElbow];
    final leftWrist = landmarks[PoseLandmarkType.leftWrist];
    final leftHip = landmarks[PoseLandmarkType.leftHip];
    final leftKnee = landmarks[PoseLandmarkType.leftKnee];
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];

    // Mengambil titik tubuh sebelah kanan
    final rightShoulder = landmarks[PoseLandmarkType.rightShoulder];
    final rightElbow = landmarks[PoseLandmarkType.rightElbow];
    final rightWrist = landmarks[PoseLandmarkType.rightWrist];
    final rightHip = landmarks[PoseLandmarkType.rightHip];
    final rightKnee = landmarks[PoseLandmarkType.rightKnee];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];

    // Variabel untuk menyimpan sisi tubuh yang akan dipakai
    PoseLandmark? shoulder;
    PoseLandmark? elbow;
    PoseLandmark? wrist;
    PoseLandmark? hip;
    PoseLandmark? knee;
    PoseLandmark? ankle;

    // Mengecek apakah sisi kiri tubuh lengkap
    final leftSideReady =
        leftShoulder != null &&
        leftElbow != null &&
        leftWrist != null &&
        leftHip != null &&
        leftKnee != null;

    // Mengecek apakah sisi kanan tubuh lengkap
    final rightSideReady =
        rightShoulder != null &&
        rightElbow != null &&
        rightWrist != null &&
        rightHip != null &&
        rightKnee != null;

    // Prioritas menggunakan sisi kiri tubuh
    if (leftSideReady) {
      // Menyimpan landmark sisi kiri
      shoulder = leftShoulder;
      elbow = leftElbow;
      wrist = leftWrist;
      hip = leftHip;
      knee = leftKnee;
      ankle = leftAnkle;

      // Jika kiri tidak ada, gunakan sisi kanan
    } else if (rightSideReady) {
      shoulder = rightShoulder;
      elbow = rightElbow;
      wrist = rightWrist;
      hip = rightHip;
      knee = rightKnee;
      ankle = rightAnkle;
    } else {
      // Jika landmark tubuh belum lengkap
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Posisi tubuh belum lengkap',
        isValidPose: false,
        stage: 'incomplete',
      );
    }

    // Validasi tambahan agar landmark benar-benar lengkap
    if (shoulder == null ||
        elbow == null ||
        wrist == null ||
        hip == null ||
        knee == null) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Posisi tubuh belum lengkap',
        isValidPose: false,
        stage: 'incomplete',
      );
    }

    // =====================================================
    // VALIDASI AGAR PUSH-UP DILAKUKAN DARI SAMPING
    // =====================================================

    if (leftShoulder != null && rightShoulder != null) {
      // Menghitung lebar bahu
      final shoulderWidth = _distance(leftShoulder, rightShoulder);

      // Menghitung panjang tubuh samping
      final sideBodyLength = _distance(shoulder, hip);

      // Jika bahu terlalu lebar,
      // kemungkinan user menghadap depan kamera
      if (shoulderWidth > sideBodyLength * 0.75) {
        return ExerciseDetectionResult(
          repetition: pushUpCount,
          status: 'Arahkan kamera ke samping tubuh',
          isValidPose: false,
          stage: 'front_view',
        );
      }
    }

    // =====================================================
    // MENGHITUNG PANJANG BAGIAN TUBUH
    // =====================================================

    // Panjang lengan atas
    final upperArm = _distance(shoulder, elbow);

    // Panjang lengan bawah
    final foreArm = _distance(elbow, wrist);

    // Panjang seluruh lengan
    final fullArm = _distance(shoulder, wrist);

    // Panjang torso
    final torsoLength = _distance(shoulder, hip);

    // Panjang paha
    final thighLength = _distance(hip, knee);

    // =====================================================
    // ANTI FALSE POSITIVE
    // =====================================================

    // Jika kamera terlalu dekat
    if (fullArm < 60 || upperArm < 25 || foreArm < 25) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Terlalu dekat ke kamera',
        isValidPose: false,
        stage: 'too_close',
      );
    }

    // Jika tubuh tidak terlihat dari samping
    if (torsoLength < 40 || thighLength < 35) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Arahkan kamera ke samping tubuh',
        isValidPose: false,
        stage: 'wrong_view',
      );
    }

    // =====================================================
    // MENGHITUNG SUDUT
    // =====================================================

    // Sudut siku
    final elbowAngle = _calculateAngle(shoulder, elbow, wrist);

    // Sudut torso
    final torsoAngle = _calculateAngle(shoulder, hip, knee);

    // Mengecek apakah ankle tersedia
    final ankleReady = ankle != null;

    double? legAngle;

    // Jika ankle tersedia, hitung sudut kaki
    if (ankleReady) {
      legAngle = _calculateAngle(hip, knee, ankle!);
    }

    // Mengecek apakah posisi plank benar
    final inPlankPosition =
        torsoAngle > 135 && (legAngle == null || legAngle > 130);

    // Jika posisi plank salah
    if (!inPlankPosition) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Ambil posisi plank',
        isValidPose: false,
        stage: 'plank_invalid',
      );
    }

    // =====================================================
    // DETEKSI GERAKAN PUSH-UP
    // =====================================================

    // Jika siku menekuk (badan turun)
    if (elbowAngle < 105) {
      // Tandai bahwa user sedang turun
      isLowered = true;

      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Naikkan badan',
        isValidPose: true,
        stage: 'down',
      );
    }

    // Jika siku lurus kembali DAN sebelumnya turun
    if (elbowAngle > 145 && isLowered) {
      // Tambah jumlah push-up
      pushUpCount++;

      // Reset status turun
      isLowered = false;

      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Push-up terhitung',
        isValidPose: true,
        stage: 'up',
      );
    }

    // Posisi tengah
    if (!isLowered && elbowAngle >= 95 && elbowAngle <= 155) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Turunkan badan',
        isValidPose: true,
        stage: 'mid',
      );
    }

    // Posisi siap
    return ExerciseDetectionResult(
      repetition: pushUpCount,
      status: 'Pose siap',
      isValidPose: true,
      stage: 'ready',
    );
  }

  // =====================================================
  // FUNGSI MENGHITUNG SUDUT
  // =====================================================

  double _calculateAngle(PoseLandmark p1, PoseLandmark p2, PoseLandmark p3) {
    // Menghitung panjang sisi segitiga
    final a = _distance(p2, p3);
    final b = _distance(p1, p2);
    final c = _distance(p1, p3);

    // Mencegah pembagian 0
    if (a == 0 || b == 0) return 0;

    // Rumus cosine law
    final cosValue = ((b * b + a * a - c * c) / (2 * b * a)).clamp(-1.0, 1.0);

    // Mengubah ke derajat
    return acos(cosValue) * (180 / pi);
  }

  // =====================================================
  // FUNGSI MENGHITUNG JARAK ANTAR TITIK
  // =====================================================

  double _distance(PoseLandmark p1, PoseLandmark p2) {
    // Rumus jarak Euclidean
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }

  // =====================================================
  // RESET PUSH-UP
  // =====================================================

  void reset() {
    // Reset jumlah push-up
    pushUpCount = 0;

    // Reset status turun
    isLowered = false;
  }
}
